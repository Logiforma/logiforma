<script setup lang="ts">
/**
 * MorphingBackground.vue
 *
 * A fixed, full-viewport ThreeJS canvas that lives BEHIND all page content.
 * The scene morphs through a sequence of distinct shapes driven by scroll
 * progress (0 → 1) on the home page; non-home routes are pinned to a fixed
 * progress so each page reads as visually distinct.
 *
 * Sequence (zero-overlap visibility windows):
 *   rings    p=[0.00..0.18]   — three glass torus rings, hero state
 *   knotA    p=[0.20..0.48]   — glass torus knot drifting in
 *   sphere   p=[0.46..0.65]   — iridescent sphere, mid-state
 *   knotC    p=[0.63..1.00]   — chrome torus knot with starfield
 *
 * Departing shapes exit by drifting off-axis while the incoming shape blooms
 * in from a different position — never two shapes overlapping at the same
 * point in space, so the transition reads as intentional, not glitchy.
 *
 * Performance:
 *   - DPR clamped: 1.0 on mobile, 1.5 on desktop
 *   - Frame throttled to ~30fps on mobile via delta accumulator
 *   - `transmission` (the expensive screen-space refraction pass) disabled
 *     on mobile — metalness + clearcoat fill the visual gap
 *   - Env map built once and cached across mounts / route changes
 *   - Pauses rAF loop when document is hidden
 *   - Geometry resolution adapts to device
 */
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRoute } from 'vue-router'
import * as THREE from 'three'

const route = useRoute()
const canvasRef = ref<HTMLCanvasElement | null>(null)
const supportsWebGL = ref(true)

/**
 * Fixed morph progress for each non-home route.
 * Home uses scroll-driven progress; all others freeze at a distinctive state.
 * Tuned so each page lands inside one shape's "stable" window, not a transition.
 */
const ROUTE_PROGRESS: Record<string, number> = {
  '/': -1,          // special: scroll-driven
  '/about': 0.06,   // rings — structured, layered hero feel
  '/services': 0.32,// glass knot — technical, refractive
  '/pricing': 0.55, // iridescent sphere — premium, singular
  '/contact': 0.85, // chrome knot + stars — bold, finished
}

// --- Three globals (module-scoped to component instance) -----------------
let renderer: THREE.WebGLRenderer | null = null
let scene: THREE.Scene | null = null
let camera: THREE.PerspectiveCamera | null = null
let knotA: THREE.Mesh | null = null      // glass knot, p≈0.2..0.48
let knotC: THREE.Mesh | null = null      // chrome knot, p≈0.63..1.0
let sphere: THREE.Mesh | null = null
let starField: THREE.Points | null = null
let ringGroup: THREE.Group | null = null
let frameId = 0
let scrollProgress = 0
let smoothedProgress = 0
let targetProgress = 0
const clock = new THREE.Clock()
let visibilityHandler: (() => void) | null = null
let scrollHandler: (() => void) | null = null
let prefersReducedMotion = false
let isMobile = false
let frameAccumulator = 0
const MOBILE_FRAME_INTERVAL = 1 / 30  // 30fps cap on mobile

// Mouse parallax: target offsets (-1..1) and smoothed values
let mouseX = 0
let mouseY = 0
let smoothMouseX = 0
let smoothMouseY = 0
let mouseHandler: ((e: MouseEvent) => void) | null = null

// --- Module-level env map cache (survives component remounts) ------------
let cachedEnvMap: THREE.Texture | null = null

// --- Color palette per state (linearized via Color) ---------------------
const BG_A = new THREE.Color('#050505') // deep black for hero
const BG_B = new THREE.Color('#060914') // deep navy — readable, dark UI-compatible
const BG_C = new THREE.Color('#0a0a0f') // near-black with cool tint

const MAT_A_COLOR = new THREE.Color('#cfd6dd') // pale steel (glass)
const MAT_B_COLOR = new THREE.Color('#ffffff') // sphere
const MAT_C_COLOR = new THREE.Color('#d8d8d8') // chrome

// --- Math helpers --------------------------------------------------------
function lerp(a: number, b: number, t: number): number {
  return a + (b - a) * t
}

function clamp01(x: number): number {
  return Math.min(1, Math.max(0, x))
}

function smoothstep(t: number): number {
  const x = clamp01(t)
  return x * x * (3 - 2 * x)
}

/**
 * Visibility envelope: returns 1 inside [fadeInEnd, fadeOutStart], smoothly
 * ramping from 0 over [start, fadeInEnd] and back to 0 over [fadeOutStart, end].
 * Returns exactly 0 outside [start, end] so we can skip rendering entirely.
 */
function envelope(p: number, start: number, fadeInEnd: number, fadeOutStart: number, end: number): number {
  if (p <= start || p >= end) return 0
  if (p < fadeInEnd) return smoothstep((p - start) / (fadeInEnd - start))
  if (p > fadeOutStart) return smoothstep((end - p) / (end - fadeOutStart))
  return 1
}

function lerp3(a: number, b: number, c: number, p: number): number {
  if (p < 0.5) return lerp(a, b, smoothstep(p / 0.5))
  return lerp(b, c, smoothstep((p - 0.5) / 0.5))
}

function lerp3Color(out: THREE.Color, a: THREE.Color, b: THREE.Color, c: THREE.Color, p: number) {
  if (p < 0.5) {
    out.copy(a).lerp(b, smoothstep(p / 0.5))
  } else {
    out.copy(b).lerp(c, smoothstep((p - 0.5) / 0.5))
  }
}

function computeScrollProgress(): number {
  const doc = document.documentElement
  const max = doc.scrollHeight - window.innerHeight
  if (max <= 0) return 0
  return clamp01(window.scrollY / max)
}

/**
 * Build the cached environment map once. Subsequent calls return the cache.
 */
function getEnvironmentMap(r: THREE.WebGLRenderer): THREE.Texture | null {
  if (cachedEnvMap) return cachedEnvMap
  const size = 256
  const c = document.createElement('canvas')
  c.width = size * 2
  c.height = size
  const ctx = c.getContext('2d')
  if (!ctx) return null
  const grad = ctx.createLinearGradient(0, 0, 0, size)
  grad.addColorStop(0, '#ffffff')
  grad.addColorStop(0.45, '#bcbcc6')
  grad.addColorStop(0.55, '#3a3a44')
  grad.addColorStop(1.0, '#050505')
  ctx.fillStyle = grad
  ctx.fillRect(0, 0, size * 2, size)
  for (let i = 0; i < 6; i++) {
    const cx = Math.random() * size * 2
    const cy = Math.random() * size
    const rr = 20 + Math.random() * 60
    const radial = ctx.createRadialGradient(cx, cy, 0, cx, cy, rr)
    radial.addColorStop(0, 'rgba(255,220,180,0.9)')
    radial.addColorStop(1, 'rgba(255,220,180,0)')
    ctx.fillStyle = radial
    ctx.beginPath()
    ctx.arc(cx, cy, rr, 0, Math.PI * 2)
    ctx.fill()
  }
  const tex = new THREE.CanvasTexture(c)
  tex.mapping = THREE.EquirectangularReflectionMapping
  tex.colorSpace = THREE.SRGBColorSpace

  const pmrem = new THREE.PMREMGenerator(r)
  const envRT = pmrem.fromEquirectangular(tex)
  tex.dispose()
  pmrem.dispose()
  cachedEnvMap = envRT.texture
  return cachedEnvMap
}

function buildStarfield(): THREE.Points {
  const count = isMobile ? 600 : 1200
  const positions = new Float32Array(count * 3)
  for (let i = 0; i < count; i++) {
    const r = 30 + Math.random() * 70
    const theta = Math.random() * Math.PI * 2
    const phi = Math.acos(2 * Math.random() - 1)
    positions[i * 3] = r * Math.sin(phi) * Math.cos(theta)
    positions[i * 3 + 1] = r * Math.sin(phi) * Math.sin(theta)
    positions[i * 3 + 2] = r * Math.cos(phi)
  }
  const geometry = new THREE.BufferGeometry()
  geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
  const material = new THREE.PointsMaterial({
    color: 0xffffff,
    size: 0.12,
    sizeAttenuation: true,
    transparent: true,
    opacity: 0,
    depthWrite: false,
  })
  return new THREE.Points(geometry, material)
}

/**
 * Build a torus-knot mesh with the given material params. p=2, q=1 produces
 * the wide, graceful loops from the brand design (vs the star-pretzel p/q=2/3).
 */
function buildKnot(matParams: THREE.MeshPhysicalMaterialParameters): THREE.Mesh {
  const tubular = isMobile ? 128 : 256
  const radial = isMobile ? 16 : 28
  const geom = new THREE.TorusKnotGeometry(1.5, 0.50, tubular, radial, 2, 1)
  const mat = new THREE.MeshPhysicalMaterial(matParams)
  return new THREE.Mesh(geom, mat)
}

function initScene(canvas: HTMLCanvasElement) {
  const w = window.innerWidth
  const h = window.innerHeight

  renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: !isMobile,
    alpha: false,
    powerPreference: 'high-performance',
  })
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, isMobile ? 1.0 : 1.5))
  renderer.setSize(w, h, false)
  renderer.toneMapping = THREE.ACESFilmicToneMapping
  renderer.toneMappingExposure = 1.0
  renderer.outputColorSpace = THREE.SRGBColorSpace

  scene = new THREE.Scene()
  scene.background = BG_A.clone()

  camera = new THREE.PerspectiveCamera(40, w / h, 0.1, 200)
  camera.position.set(0, 0, 7)
  camera.lookAt(0, 0, 0)

  // Lighting
  const hemi = new THREE.HemisphereLight(0xffffff, 0x222233, 0.65)
  scene.add(hemi)

  const keyLight = new THREE.DirectionalLight(0xffffff, 1.8)
  keyLight.position.set(4, 5, 6)
  scene.add(keyLight)

  const rimLight = new THREE.DirectionalLight(0xfff0e0, 1.2)
  rimLight.position.set(-6, -3, -4)
  scene.add(rimLight)

  // Glass knot — visible mid-early. On mobile, transmission is the single
  // most expensive feature in Three.js; substitute high roughness inversion
  // + iridescence for a similar refractive look at a fraction of the cost.
  knotA = buildKnot({
    color: MAT_A_COLOR.clone(),
    metalness: isMobile ? 0.25 : 0.0,
    roughness: isMobile ? 0.15 : 0.05,
    transmission: isMobile ? 0.0 : 1.0,
    thickness: isMobile ? 0.0 : 1.2,
    ior: 1.5,
    attenuationDistance: 5,
    clearcoat: 1.0,
    clearcoatRoughness: 0.05,
    iridescence: isMobile ? 0.4 : 0.1,
    iridescenceIOR: 1.3,
    transparent: true,
    opacity: 0,
    side: THREE.DoubleSide,
    envMapIntensity: 1.2,
  })
  knotA.scale.setScalar(1.4)
  scene.add(knotA)

  // Chrome knot — visible late. Pure metalness, no transmission ever.
  knotC = buildKnot({
    color: MAT_C_COLOR.clone(),
    metalness: 1.0,
    roughness: 0.08,
    clearcoat: 0.7,
    clearcoatRoughness: 0.1,
    transparent: true,
    opacity: 0,
    envMapIntensity: 1.6,
  })
  knotC.scale.setScalar(1.15)
  scene.add(knotC)

  // Iridescent sphere
  const sphereSegW = isMobile ? 48 : 96
  const sphereSegH = isMobile ? 32 : 64
  const sphereGeom = new THREE.SphereGeometry(1.0, sphereSegW, sphereSegH)
  const sphereMat = new THREE.MeshPhysicalMaterial({
    color: MAT_B_COLOR.clone(),
    metalness: isMobile ? 0.3 : 0.0,
    roughness: isMobile ? 0.15 : 0.05,
    transmission: isMobile ? 0.0 : 0.9,
    thickness: isMobile ? 0.0 : 1.0,
    ior: 1.4,
    clearcoat: 1.0,
    clearcoatRoughness: 0.0,
    iridescence: 1.0,
    iridescenceIOR: 1.45,
    iridescenceThicknessRange: [100, 800],
    transparent: true,
    opacity: 0,
    envMapIntensity: 1.6,
  })
  sphere = new THREE.Mesh(sphereGeom, sphereMat)
  sphere.scale.setScalar(1.0)
  scene.add(sphere)

  // Ring group — three offset rings, home hero state only.
  ringGroup = new THREE.Group()
  ringGroup.position.set(1.4, 0, 0)
  const ringDefs = [
    { r: 2.0, tube: 0.34, rx: 0,              ry: 0,             rz: 0 },
    { r: 1.6, tube: 0.32, rx: Math.PI / 3.5,  ry: Math.PI / 5,   rz: 0 },
    { r: 2.4, tube: 0.36, rx: -Math.PI / 5,   ry: Math.PI / 2.8, rz: Math.PI / 10 },
  ]
  const ringRadial = isMobile ? 20 : 36
  const ringTubular = isMobile ? 60 : 100
  for (const rd of ringDefs) {
    const rg = new THREE.TorusGeometry(rd.r, rd.tube, ringRadial, ringTubular)
    const rm = new THREE.MeshPhysicalMaterial({
      color: new THREE.Color('#c8d2db'),
      metalness: isMobile ? 0.3 : 0.1,
      roughness: isMobile ? 0.15 : 0.04,
      transmission: isMobile ? 0.0 : 0.98,
      thickness: isMobile ? 0.0 : 1.1,
      ior: 1.52,
      clearcoat: 1.0,
      clearcoatRoughness: 0.03,
      iridescence: isMobile ? 0.4 : 0.25,
      iridescenceIOR: 1.3,
      transparent: true,
      opacity: 0,
      side: THREE.DoubleSide,
      envMapIntensity: 1.5,
    })
    const ringMesh = new THREE.Mesh(rg, rm)
    ringMesh.rotation.set(rd.rx, rd.ry, rd.rz)
    ringGroup.add(ringMesh)
  }
  scene.add(ringGroup)

  starField = buildStarfield()
  scene.add(starField)

  const env = getEnvironmentMap(renderer)
  if (env) scene.environment = env
}

/**
 * Per-frame update. Each shape has its own visibility envelope (no overlap)
 * and its own exit trajectory so transitions read as motion, not crossfade.
 */
function tick() {
  if (!renderer || !scene || !camera) return
  frameId = requestAnimationFrame(tick)

  const dt = clock.getDelta()

  // Frame throttle on mobile (skip ~half of frames to hit 30fps)
  if (isMobile) {
    frameAccumulator += dt
    if (frameAccumulator < MOBILE_FRAME_INTERVAL) return
    frameAccumulator = 0
  }

  const isHome = route.path === '/'
  if (isHome) targetProgress = scrollProgress
  smoothedProgress += (targetProgress - smoothedProgress) * 0.08

  const p = smoothedProgress
  const t = clock.elapsedTime

  // ----- Background ----
  if (scene.background instanceof THREE.Color) {
    lerp3Color(scene.background, BG_A, BG_B, BG_C, p)
  }

  // ----- Camera with mouse parallax ----
  smoothMouseX += (mouseX - smoothMouseX) * 0.04
  smoothMouseY += (mouseY - smoothMouseY) * 0.04
  const parallaxX = smoothMouseX * 0.6
  const parallaxY = smoothMouseY * 0.4
  const camZ = lerp3(7, 6.5, 8, p)
  const camY = lerp3(0, 0.2, -0.2, p) + parallaxY
  camera.position.x += (parallaxX - camera.position.x) * 0.1
  camera.position.y += (camY - camera.position.y) * 0.1
  camera.position.z += (camZ - camera.position.z) * 0.1
  camera.lookAt(0, 0, 0)

  // ===================================================================
  // Visibility envelopes (zero-overlap windows; max 2% crossfade region)
  // ===================================================================
  // Rings start at negative p so they're fully visible at p=0 (home top, no scroll).
  // KnotC extends past p=1 so it's fully visible at p=1 (home bottom).
  const vRings  = envelope(p, -0.10, -0.02, 0.14, 0.20)
  const vKnotA  = envelope(p,  0.18,  0.26, 0.42, 0.48)
  const vSphere = envelope(p,  0.46,  0.54, 0.58, 0.66)
  const vKnotC  = envelope(p,  0.64,  0.74, 1.10, 1.20)

  // ----- Ring group: exits by drifting right and shrinking ----
  if (ringGroup) {
    ringGroup.visible = vRings > 0.001
    if (ringGroup.visible) {
      const exitX = lerp(1.4, 4.0, 1 - vRings)
      const exitY = Math.sin(t * 0.45) * 0.12
      ringGroup.position.x = exitX
      ringGroup.position.y = exitY
      ringGroup.rotation.y += dt * 0.035
      let ri = 0
      for (const child of ringGroup.children) {
        const rm = child as THREE.Mesh
        rm.rotation.x += dt * (0.12 + ri * 0.06)
        rm.rotation.y += dt * (0.09 + ri * 0.04)
        ;(rm.material as THREE.MeshPhysicalMaterial).opacity = vRings
        ri++
      }
    }
  }

  // ----- Glass knot: enters from upper-right, exits to lower-left ----
  if (knotA) {
    knotA.visible = vKnotA > 0.001
    if (knotA.visible) {
      const mat = knotA.material as THREE.MeshPhysicalMaterial
      // Enter from upper-right at vKnotA=0, settle center at 1, drift left as it exits
      const localT = (p - 0.18) / (0.48 - 0.18) // 0..1 across active range
      const driftX = lerp(2.5, -1.5, smoothstep(localT))
      const driftY = lerp(1.5, -0.8, smoothstep(localT))
      knotA.position.x += (driftX - knotA.position.x) * 0.06
      knotA.position.y += (driftY - knotA.position.y) * 0.06

      knotA.rotation.x += dt * 0.18
      knotA.rotation.y += dt * 0.22

      mat.opacity = vKnotA
      mat.envMapIntensity = 1.2
    }
  }

  // ----- Sphere: blooms from center, exits by drifting up ----
  if (sphere) {
    sphere.visible = vSphere > 0.001
    if (sphere.visible) {
      const mat = sphere.material as THREE.MeshPhysicalMaterial
      // Sphere stays near center, slight float
      const driftY = lerp(-0.5, 0.8, smoothstep((p - 0.46) / 0.20)) + Math.sin(t * 0.6) * 0.08
      sphere.position.x = 0
      sphere.position.y += (driftY - sphere.position.y) * 0.08
      // Bloom in via scale (only when actively transitioning, not a hack)
      const bloomScale = lerp(0.5, 1.2, smoothstep(vSphere))
      sphere.scale.setScalar(bloomScale)
      sphere.rotation.y += dt * 0.15
      mat.opacity = vSphere
    }
  }

  // ----- Chrome knot: enters from lower-right, settles center ----
  if (knotC) {
    knotC.visible = vKnotC > 0.001
    if (knotC.visible) {
      const mat = knotC.material as THREE.MeshPhysicalMaterial
      const localT = clamp01((p - 0.64) / 0.36)
      const driftX = lerp(2.0, -0.2, smoothstep(localT))
      const driftY = lerp(-1.5, -0.1, smoothstep(localT))
      knotC.position.x += (driftX - knotC.position.x) * 0.06
      knotC.position.y += (driftY - knotC.position.y) * 0.06

      knotC.rotation.x += dt * 0.10
      knotC.rotation.y += dt * 0.14
      knotC.rotation.z = -0.2

      mat.opacity = vKnotC
    }
  }

  // ----- Starfield (chrome-knot era only) ----
  if (starField) {
    const mat = starField.material as THREE.PointsMaterial
    mat.opacity = smoothstep(Math.max(0, (p - 0.55) / 0.45))
    starField.visible = mat.opacity > 0.001
    starField.rotation.y += dt * 0.01
    starField.rotation.x += dt * 0.005
  }

  renderer.render(scene, camera)
  document.documentElement.style.setProperty('--morph-p', p.toFixed(3))
}

function onResize() {
  if (!renderer || !camera) return
  const w = window.innerWidth
  const h = window.innerHeight
  renderer.setSize(w, h, false)
  camera.aspect = w / h
  camera.updateProjectionMatrix()
}

function onScroll() {
  scrollProgress = computeScrollProgress()
}

function updateTargetProgress() {
  const path = route.path
  const fixed = ROUTE_PROGRESS[path]
  if (fixed === undefined) {
    targetProgress = 0.06
  } else if (fixed === -1) {
    targetProgress = scrollProgress
  } else {
    targetProgress = fixed
  }
}

function detectWebGL(): boolean {
  try {
    const c = document.createElement('canvas')
    return !!(window.WebGLRenderingContext &&
      (c.getContext('webgl2') || c.getContext('webgl')))
  } catch {
    return false
  }
}

onMounted(() => {
  prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  isMobile = window.matchMedia('(max-width: 768px)').matches ||
    /Mobi|Android/i.test(navigator.userAgent)

  if (!detectWebGL()) {
    supportsWebGL.value = false
    return
  }

  const canvas = canvasRef.value
  if (!canvas) return

  initScene(canvas)

  scrollHandler = () => onScroll()
  window.addEventListener('scroll', scrollHandler, { passive: true })
  window.addEventListener('resize', onResize)

  // Mouse parallax — disabled on touch / reduced-motion
  if (!isMobile && !prefersReducedMotion) {
    mouseHandler = (e: MouseEvent) => {
      mouseX = (e.clientX / window.innerWidth) * 2 - 1
      mouseY = -((e.clientY / window.innerHeight) * 2 - 1)
    }
    window.addEventListener('mousemove', mouseHandler, { passive: true })
  }

  visibilityHandler = () => {
    if (document.hidden) {
      if (frameId) cancelAnimationFrame(frameId)
      frameId = 0
    } else if (!frameId) {
      clock.getDelta()
      tick()
    }
  }
  document.addEventListener('visibilitychange', visibilityHandler)

  onScroll()
  updateTargetProgress()

  if (prefersReducedMotion) {
    // Render a single static frame, no animation loop
    smoothedProgress = targetProgress
    tick()
    if (frameId) cancelAnimationFrame(frameId)
    frameId = 0
  } else {
    tick()
  }

  watch(() => route.path, () => {
    updateTargetProgress()
    window.scrollTo(0, 0)
  })
})

onBeforeUnmount(() => {
  if (frameId) cancelAnimationFrame(frameId)
  if (scrollHandler) window.removeEventListener('scroll', scrollHandler)
  if (mouseHandler) window.removeEventListener('mousemove', mouseHandler)
  window.removeEventListener('resize', onResize)
  if (visibilityHandler) document.removeEventListener('visibilitychange', visibilityHandler)

  if (ringGroup) {
    ringGroup.children.forEach((child) => {
      const m = child as THREE.Mesh
      m.geometry.dispose()
      ;(m.material as THREE.Material).dispose()
    })
    ringGroup = null
  }
  if (knotA) {
    knotA.geometry.dispose()
    ;(knotA.material as THREE.Material).dispose()
    knotA = null
  }
  if (knotC) {
    knotC.geometry.dispose()
    ;(knotC.material as THREE.Material).dispose()
    knotC = null
  }
  if (sphere) {
    sphere.geometry.dispose()
    ;(sphere.material as THREE.Material).dispose()
    sphere = null
  }
  if (starField) {
    starField.geometry.dispose()
    ;(starField.material as THREE.Material).dispose()
    starField = null
  }
  // Note: cachedEnvMap is intentionally kept across mounts.
  renderer?.dispose()
  scene = null
  camera = null
  renderer = null
})
</script>

<template>
  <div class="morph-bg" aria-hidden="true">
    <canvas v-if="supportsWebGL" ref="canvasRef" class="morph-bg__canvas" />
    <div v-else class="morph-bg__fallback" />
  </div>
</template>

<style scoped>
.morph-bg {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;
  max-width: 100vw;
  max-height: 100dvh;
}

.morph-bg__canvas {
  display: block;
  width: 100%;
  height: 100%;
  max-width: 100vw;
  max-height: 100dvh;
}

/* Static fallback gradient for WebGL-disabled clients */
.morph-bg__fallback {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(1200px 800px at 80% 10%, rgba(120, 140, 180, 0.18), transparent 60%),
    radial-gradient(900px 700px at 30% 60%, rgba(80, 100, 160, 0.14), transparent 60%),
    linear-gradient(180deg, #050505 0%, #060914 50%, #0a0a0f 100%);
}
</style>

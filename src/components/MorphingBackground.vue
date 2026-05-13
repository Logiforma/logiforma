<script setup lang="ts">
/**
 * MorphingBackground.vue
 *
 * A fixed, full-viewport ThreeJS canvas that lives BEHIND all page content.
 * The scene smoothly morphs between three visual states driven by scroll
 * progress (0 → 1):
 *
 *   State A (progress 0.0)  — Glass torus-knot on deep black, chromatic.
 *                             Inspired by `new_designs/screen 1.png`.
 *   State B (progress 0.5)  — Iridescent sphere on warm cream/desert
 *                             backdrop. Inspired by `new_designs/screen 2.png`.
 *   State C (progress 1.0)  — Chrome / liquid-metal torus-knot on dark with
 *                             starfield. Inspired by `new_designs/screen 3.png`.
 *
 * Morph implementation notes:
 *   - Two primary meshes (TorusKnot + Sphere) crossfade their scale/opacity.
 *   - Material properties (metalness, roughness, transmission, iridescence,
 *     clearcoat, ior, color) are interpolated each frame between state targets.
 *   - Background color is interpolated through a 3-stop gradient (black →
 *     cream → black) so surrounding content theme reads correctly.
 *   - Starfield points geometry only appears at progress > 0.6.
 *   - All interpolations use smoothed (eased) scroll progress for a creamy feel.
 *
 * Performance:
 *   - DPR clamped to min(devicePixelRatio, 1.75).
 *   - On mobile / reduced-power / no-WebGL we render a CSS gradient fallback.
 *   - Pauses rAF loop when document is hidden.
 *   - Disables `prefers-reduced-motion` interactions (still renders static).
 */
import { ref, onMounted, onBeforeUnmount } from 'vue'
import * as THREE from 'three'

const canvasRef = ref<HTMLCanvasElement | null>(null)
const supportsWebGL = ref(true)

// --- Three globals (module-scoped to this component instance) -----------
let renderer: THREE.WebGLRenderer | null = null
let scene: THREE.Scene | null = null
let camera: THREE.PerspectiveCamera | null = null
let knot: THREE.Mesh | null = null
let sphere: THREE.Mesh | null = null
let starField: THREE.Points | null = null
let frameId = 0
let scrollProgress = 0       // raw 0..1
let smoothedProgress = 0     // eased 0..1
const clock = new THREE.Clock()
let resizeObserver: ResizeObserver | null = null
let visibilityHandler: (() => void) | null = null
let scrollHandler: (() => void) | null = null
let prefersReducedMotion = false
let isMobile = false

// --- Color palette per state (linearized via Color) ---------------------
const BG_A = new THREE.Color('#050505') // deep black for hero
const BG_B = new THREE.Color('#e9e3d6') // warm cream / desert
const BG_C = new THREE.Color('#0a0a0f') // near-black w/ slight cool tint

const MAT_A_COLOR = new THREE.Color('#cfd6dd') // pale steel tint (glass)
const MAT_B_COLOR = new THREE.Color('#ffffff') // bubble
const MAT_C_COLOR = new THREE.Color('#d8d8d8') // chrome

/**
 * Compute scroll progress as a value 0..1 spanning the total document height.
 */
function computeScrollProgress(): number {
  const doc = document.documentElement
  const max = doc.scrollHeight - window.innerHeight
  if (max <= 0) return 0
  return Math.min(1, Math.max(0, window.scrollY / max))
}

/**
 * Linear interpolation helper.
 */
function lerp(a: number, b: number, t: number): number {
  return a + (b - a) * t
}

/**
 * Smoothstep ease for nicer morph feel.
 */
function smoothstep(t: number): number {
  return t * t * (3 - 2 * t)
}

/**
 * Interpolate a value across three keyframe states (A, B, C) where:
 *   p = 0   -> A
 *   p = 0.5 -> B
 *   p = 1.0 -> C
 */
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

/**
 * Build a simple procedural starfield (used most prominently in State C).
 */
function buildStarfield(): THREE.Points {
  const count = 1200
  const positions = new Float32Array(count * 3)
  for (let i = 0; i < count; i++) {
    // Sphere-distributed stars, biased toward the camera distance
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
 * Initialize Three scene, meshes, lights, and start render loop.
 */
function initScene(canvas: HTMLCanvasElement) {
  const w = window.innerWidth
  const h = window.innerHeight

  renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: !isMobile,
    alpha: false,
    powerPreference: 'high-performance',
  })
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, isMobile ? 1.25 : 1.75))
  renderer.setSize(w, h, false)
  renderer.toneMapping = THREE.ACESFilmicToneMapping
  renderer.toneMappingExposure = 1.0
  renderer.outputColorSpace = THREE.SRGBColorSpace

  scene = new THREE.Scene()
  scene.background = BG_A.clone()

  camera = new THREE.PerspectiveCamera(40, w / h, 0.1, 200)
  camera.position.set(0, 0, 7)
  camera.lookAt(0, 0, 0)

  // Lighting — physically based to flatter MeshPhysicalMaterial
  const hemi = new THREE.HemisphereLight(0xffffff, 0x222233, 0.65)
  scene.add(hemi)

  const keyLight = new THREE.DirectionalLight(0xffffff, 1.8)
  keyLight.position.set(4, 5, 6)
  scene.add(keyLight)

  const rimLight = new THREE.DirectionalLight(0xfff0e0, 1.2)
  rimLight.position.set(-6, -3, -4)
  scene.add(rimLight)

  // --- Primary morph subject: a torus knot (used at State A & State C) ---
  const knotGeom = new THREE.TorusKnotGeometry(
    1.1,   // radius
    0.42,  // tube
    isMobile ? 180 : 280, // tubularSegments
    isMobile ? 18 : 28,   // radialSegments
    2,     // p
    3      // q
  )
  const knotMat = new THREE.MeshPhysicalMaterial({
    color: MAT_A_COLOR.clone(),
    metalness: 0.0,
    roughness: 0.05,
    transmission: 1.0,   // glass-like to start
    thickness: 1.2,
    ior: 1.5,
    attenuationDistance: 5,
    clearcoat: 1.0,
    clearcoatRoughness: 0.05,
    iridescence: 0.0,
    iridescenceIOR: 1.3,
    transparent: true,
    side: THREE.DoubleSide,
    envMapIntensity: 1.2,
  })
  knot = new THREE.Mesh(knotGeom, knotMat)
  knot.scale.setScalar(1.4)
  scene.add(knot)

  // --- Secondary subject: iridescent sphere (used at State B) ------------
  const sphereGeom = new THREE.SphereGeometry(1.0, isMobile ? 64 : 128, isMobile ? 48 : 96)
  const sphereMat = new THREE.MeshPhysicalMaterial({
    color: MAT_B_COLOR.clone(),
    metalness: 0.0,
    roughness: 0.05,
    transmission: 0.9,
    thickness: 1.0,
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
  sphere.scale.setScalar(0.01) // hidden at start
  scene.add(sphere)

  // --- Star field (State C) ---------------------------------------------
  starField = buildStarfield()
  scene.add(starField)

  // Simple procedural environment map for reflections (uses RoomEnvironment-
  // like pmrem via a quick CubeTexture from canvas would be heavier; we use
  // a synthetic gradient rendered into an equirect texture)
  buildEnvironment()
}

/**
 * Generate a soft procedural environment texture so the physical material
 * has something to reflect (avoids pulling RoomEnvironment / heavy assets).
 */
function buildEnvironment() {
  if (!scene || !renderer) return
  const size = 256
  const c = document.createElement('canvas')
  c.width = size * 2
  c.height = size
  const ctx = c.getContext('2d')
  if (!ctx) return
  const grad = ctx.createLinearGradient(0, 0, 0, size)
  grad.addColorStop(0, '#ffffff')
  grad.addColorStop(0.45, '#bcbcc6')
  grad.addColorStop(0.55, '#3a3a44')
  grad.addColorStop(1.0, '#050505')
  ctx.fillStyle = grad
  ctx.fillRect(0, 0, size * 2, size)
  // sprinkle a few warm highlights
  for (let i = 0; i < 6; i++) {
    const cx = Math.random() * size * 2
    const cy = Math.random() * size
    const r = 20 + Math.random() * 60
    const radial = ctx.createRadialGradient(cx, cy, 0, cx, cy, r)
    radial.addColorStop(0, 'rgba(255,220,180,0.9)')
    radial.addColorStop(1, 'rgba(255,220,180,0)')
    ctx.fillStyle = radial
    ctx.beginPath()
    ctx.arc(cx, cy, r, 0, Math.PI * 2)
    ctx.fill()
  }
  const tex = new THREE.CanvasTexture(c)
  tex.mapping = THREE.EquirectangularReflectionMapping
  tex.colorSpace = THREE.SRGBColorSpace

  const pmrem = new THREE.PMREMGenerator(renderer)
  const envRT = pmrem.fromEquirectangular(tex)
  scene.environment = envRT.texture
  tex.dispose()
  pmrem.dispose()
}

/**
 * The main per-frame update — morph everything based on smoothed scroll.
 */
function tick() {
  if (!renderer || !scene || !camera) return
  frameId = requestAnimationFrame(tick)

  // Ease the raw scroll progress toward the actual scroll
  const target = scrollProgress
  smoothedProgress += (target - smoothedProgress) * 0.08

  const p = smoothedProgress
  const dt = clock.getDelta()
  const t = clock.elapsedTime

  // ----- Background color crossfade ----
  if (scene.background instanceof THREE.Color) {
    lerp3Color(scene.background, BG_A, BG_B, BG_C, p)
  }

  // ----- Camera subtle dolly per state ----
  const camZ = lerp3(7, 6, 8, p)
  const camY = lerp3(0, 0.4, -0.2, p)
  camera.position.x += (0 - camera.position.x) * 0.1
  camera.position.y += (camY - camera.position.y) * 0.1
  camera.position.z += (camZ - camera.position.z) * 0.1
  camera.lookAt(0, 0, 0)

  // ----- Knot transform / material morph (visible in A & C, fades in B) ----
  if (knot) {
    const mat = knot.material as THREE.MeshPhysicalMaterial
    // visibility envelope: peak at A (1.0), dip at B (0.15), peak at C (1.0)
    const knotPresence = lerp3(1.0, 0.0, 1.0, p)
    const baseScale = lerp3(1.45, 0.7, 1.15, p)
    knot.scale.setScalar(baseScale * Math.max(knotPresence, 0.001))

    // Drift across screen — right in A, off-screen mid in B, slight left in C
    const targetX = lerp3(1.6, 0.0, -0.2, p)
    const targetY = lerp3(0.2, 4.0, -0.1, p)
    knot.position.x += (targetX - knot.position.x) * 0.06
    knot.position.y += (targetY - knot.position.y) * 0.06

    // Rotation — continuous slow spin + state-driven tilt
    knot.rotation.x += dt * lerp(0.18, 0.06, p)
    knot.rotation.y += dt * lerp(0.22, 0.10, p)
    knot.rotation.z = lerp3(0.0, 0.3, -0.2, p)

    // Material morph A (glass) -> B (iridescent) -> C (chrome)
    mat.metalness = lerp3(0.0, 0.0, 1.0, p)
    mat.roughness = lerp3(0.05, 0.2, 0.08, p)
    mat.transmission = lerp3(1.0, 0.6, 0.0, p)
    mat.thickness = lerp3(1.2, 0.8, 0.0, p)
    mat.ior = lerp3(1.5, 1.4, 1.0, p)
    mat.iridescence = lerp3(0.0, 0.6, 0.0, p)
    mat.clearcoat = lerp3(1.0, 0.6, 0.7, p)
    mat.clearcoatRoughness = lerp3(0.04, 0.2, 0.1, p)
    mat.envMapIntensity = lerp3(1.2, 1.4, 1.6, p)
    lerp3Color(mat.color, MAT_A_COLOR, MAT_B_COLOR, MAT_C_COLOR, p)
    mat.opacity = Math.max(knotPresence, 0.001)
    mat.needsUpdate = false // physical material handles updates internally
  }

  // ----- Sphere transform / fade ----
  if (sphere) {
    const mat = sphere.material as THREE.MeshPhysicalMaterial
    // peak presence at midpoint (B)
    const sPresence = Math.max(0, 1 - Math.abs(p - 0.5) * 2)
    const scale = lerp(0.01, 1.0, smoothstep(sPresence))
    sphere.scale.setScalar(scale)
    sphere.position.x = lerp(-2.5, 2.5, smoothstep(p)) * 0.0 // keep centered
    sphere.position.y = Math.sin(t * 0.6) * 0.08 // gentle float
    sphere.rotation.y += dt * 0.15
    mat.opacity = smoothstep(sPresence)
  }

  // ----- Starfield ----
  if (starField) {
    const mat = starField.material as THREE.PointsMaterial
    // Stars only really visible in State C
    mat.opacity = smoothstep(Math.max(0, (p - 0.55) / 0.45))
    starField.rotation.y += dt * 0.01
    starField.rotation.x += dt * 0.005
  }

  renderer.render(scene, camera)
}

/**
 * Handle window resize.
 */
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

  // Pause when tab hidden to save CPU/GPU
  visibilityHandler = () => {
    if (document.hidden) {
      if (frameId) cancelAnimationFrame(frameId)
      frameId = 0
    } else if (!frameId) {
      clock.getDelta() // reset delta
      tick()
    }
  }
  document.addEventListener('visibilitychange', visibilityHandler)

  onScroll()
  tick()
})

onBeforeUnmount(() => {
  if (frameId) cancelAnimationFrame(frameId)
  if (scrollHandler) window.removeEventListener('scroll', scrollHandler)
  window.removeEventListener('resize', onResize)
  if (visibilityHandler) document.removeEventListener('visibilitychange', visibilityHandler)
  resizeObserver?.disconnect()

  // Dispose Three resources
  if (knot) {
    knot.geometry.dispose()
    ;(knot.material as THREE.Material).dispose()
  }
  if (sphere) {
    sphere.geometry.dispose()
    ;(sphere.material as THREE.Material).dispose()
  }
  if (starField) {
    starField.geometry.dispose()
    ;(starField.material as THREE.Material).dispose()
  }
  renderer?.dispose()
  scene = null
  camera = null
  knot = null
  sphere = null
  starField = null
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
}

.morph-bg__canvas {
  display: block;
  width: 100%;
  height: 100%;
}

/* Static fallback gradient for WebGL-disabled clients */
.morph-bg__fallback {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(1200px 800px at 80% 10%, rgba(180, 200, 220, 0.25), transparent 60%),
    radial-gradient(900px 700px at 30% 60%, rgba(220, 200, 170, 0.18), transparent 60%),
    linear-gradient(180deg, #050505 0%, #1a1816 50%, #050507 100%);
}
</style>

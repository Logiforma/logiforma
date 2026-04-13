<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { ICON_POSITIONS } from '@/data/iconPositions'

const heroRef = ref<HTMLDivElement>()
const canvasRef = ref<HTMLCanvasElement>()
const showLogo = ref(false)
const showTagline = ref(false)

let ctx: CanvasRenderingContext2D | null = null
let animationId = 0
let startTime = 0
let glowSprite: HTMLCanvasElement
let dpr = 1
let cssWidth = 0
let cssHeight = 0
let logoTriggered = false

// Timing (seconds) — total ~3s
const HOLD_ICON = 0.5       // brief icon recognition
const SCATTER = 1.2         // explosive scatter outward
const COLLAPSE = 1.1        // gravitational collapse into center
const DOT_HOLD = 0.2        // brief pulse before logo

const AMBIENT_COUNT = 120   // persistent Brownian particles

interface Particle {
  // Initial icon position (normalized -1..1)
  ix: number
  iy: number
  // Current position in canvas space
  x: number
  y: number
  // Scatter velocity direction and speed
  vAngle: number
  vSpeed: number
  // Orbital drift (random circular motion while scattering)
  orbitSpeed: number
  orbitRadius: number
  orbitPhase: number
  // Visual
  size: number
  alpha: number
  rand: number
}

interface AmbientParticle {
  x: number
  y: number
  vx: number
  vy: number
  size: number
  alpha: number
}

let particles: Particle[] = []
let ambientParticles: AmbientParticle[] = []
let ambientInitialized = false

function initParticles() {
  particles = []
  const count = ICON_POSITIONS.length / 2
  for (let i = 0; i < count; i++) {
    const nx = ICON_POSITIONS[i * 2]!
    const ny = ICON_POSITIONS[i * 2 + 1]!
    // Scatter direction: roughly outward from center with randomness
    const outAngle = Math.atan2(ny, nx) + (Math.random() - 0.5) * 1.2
    particles.push({
      ix: nx,
      iy: ny,
      x: 0,
      y: 0,
      vAngle: outAngle,
      vSpeed: 0.3 + Math.random() * 0.7,
      orbitSpeed: 1.5 + Math.random() * 3,
      orbitRadius: 0.03 + Math.random() * 0.08,
      orbitPhase: Math.random() * Math.PI * 2,
      size: 1.2 + Math.random() * 2.5,
      alpha: 0.3 + Math.random() * 0.5,
      rand: Math.random(),
    })
  }
}

function setupCanvas() {
  if (!canvasRef.value || !heroRef.value) return
  dpr = Math.min(window.devicePixelRatio, 2)
  cssWidth = heroRef.value.clientWidth
  cssHeight = heroRef.value.clientHeight
  canvasRef.value.width = cssWidth * dpr
  canvasRef.value.height = cssHeight * dpr
  canvasRef.value.style.width = cssWidth + 'px'
  canvasRef.value.style.height = cssHeight + 'px'
  ctx = canvasRef.value.getContext('2d')!
  ctx.scale(dpr, dpr)
}

function createGlowSprite() {
  const SIZE = 256
  glowSprite = document.createElement('canvas')
  glowSprite.width = SIZE
  glowSprite.height = SIZE
  const g = glowSprite.getContext('2d')!
  const grad = g.createRadialGradient(SIZE / 2, SIZE / 2, 0, SIZE / 2, SIZE / 2, SIZE / 2)
  grad.addColorStop(0, 'rgba(214, 66, 56, 1)')
  grad.addColorStop(0.15, 'rgba(214, 66, 56, 0.6)')
  grad.addColorStop(0.4, 'rgba(214, 66, 56, 0.12)')
  grad.addColorStop(1, 'rgba(214, 66, 56, 0)')
  g.fillStyle = grad
  g.fillRect(0, 0, SIZE, SIZE)
}

function easeInOutCubic(t: number): number {
  return t < 0.5 ? 4 * t * t * t : 1 - (-2 * t + 2) ** 3 / 2
}

// Explosive start, gradual stop — feels like a burst
function easeOutCubic(t: number): number {
  return 1 - (1 - t) ** 3
}

// Slow start, snaps into place — feels like gravity
function easeInQuart(t: number): number {
  return t * t * t * t
}

function animate() {
  animationId = requestAnimationFrame(animate)
  if (!ctx) return

  const elapsed = performance.now() / 1000 - startTime
  ctx.clearRect(0, 0, cssWidth, cssHeight)

  const centerX = cssWidth / 2
  const centerY = cssHeight / 2
  const iconScale = Math.min(cssWidth, cssHeight) * 0.3
  const responsiveSize = cssWidth < 600 ? 0.65 : 1

  // Phase boundaries
  const t1 = HOLD_ICON
  const t2 = t1 + SCATTER
  const t3 = t2 + COLLAPSE
  const t4 = t3 + DOT_HOLD

  // Fade in over first 0.3s
  const fadeIn = Math.min(1, elapsed / 0.3)

  for (const p of particles) {
    let px: number
    let py: number
    let pAlpha: number
    let pSize: number

    // Base icon position in canvas coords
    const iconX = centerX + p.ix * iconScale
    const iconY = centerY - p.iy * iconScale

    if (elapsed <= t1) {
      // Phase 1: Particles sit in icon shape, gentle breathing
      const breath = Math.sin(elapsed * 3 + p.rand * 6.28) * 0.008 * iconScale
      px = iconX + Math.cos(p.orbitPhase) * breath
      py = iconY + Math.sin(p.orbitPhase) * breath
      pAlpha = fadeIn * p.alpha
      pSize = p.size * responsiveSize

    } else if (elapsed <= t2) {
      // Phase 2: Explosive scatter (ease-out — fast start, gradual slow)
      const u = (elapsed - t1) / SCATTER
      const accel = easeOutCubic(u)

      // Outward drift — stronger initial burst
      const drift = accel * p.vSpeed * iconScale * 2.2
      const driftX = Math.cos(p.vAngle) * drift
      const driftY = Math.sin(p.vAngle) * drift

      // Circular orbit wobble
      const orbitT = elapsed * p.orbitSpeed * 1.5 + p.orbitPhase
      const orbX = Math.cos(orbitT) * p.orbitRadius * iconScale * (0.5 + u)
      const orbY = Math.sin(orbitT) * p.orbitRadius * iconScale * (0.5 + u)

      px = iconX + driftX + orbX
      py = iconY - driftY + orbY

      // Particles fade as they spread
      pAlpha = p.alpha * (1 - u * 0.4)
      pSize = p.size * responsiveSize * (1 + u * 0.3)

      // Store current scattered position for collapse phase
      p.x = px
      p.y = py

    } else if (elapsed <= t3) {
      // Phase 3: Gravitational collapse (ease-in — slow start, snaps to point)
      const u = (elapsed - t2) / COLLAPSE

      // Stagger: outer particles converge slightly later
      const distFromCenter = Math.sqrt(p.ix * p.ix + p.iy * p.iy)
      const delay = distFromCenter * 0.1
      const su = Math.min(1, Math.max(0, (u - delay) / (1 - delay)))
      const eased = easeInQuart(su)

      // Tighter spiral — 1.5 turns max
      const spiralAngle = (1 - eased) * Math.PI * 3 * (0.3 + distFromCenter * 0.3)

      const dx = p.x - centerX
      const dy = p.y - centerY

      // Rotate the offset by spiral angle and shrink toward center
      const cosA = Math.cos(spiralAngle)
      const sinA = Math.sin(spiralAngle)
      const remaining = 1 - eased

      px = centerX + (dx * cosA - dy * sinA) * remaining
      py = centerY + (dx * sinA + dy * cosA) * remaining

      // Grow brighter and smaller as they converge
      pAlpha = p.alpha * (0.7 + eased * 0.3)
      pSize = p.size * responsiveSize * (1.3 - eased * 0.9)

    } else if (elapsed <= t4) {
      // Phase 4: Pulsing dot at center
      const pulse = 0.5 + 0.5 * Math.sin(elapsed * 8)
      const spread = (1 - ((elapsed - t3) / DOT_HOLD)) * 3
      px = centerX + Math.cos(p.rand * 6.28) * spread * pulse
      py = centerY + Math.sin(p.rand * 6.28) * spread * pulse
      pAlpha = 0.6 + pulse * 0.3
      pSize = p.size * responsiveSize * 0.3

    } else {
      // Done - particles fade out
      const fadeOut = Math.max(0, 1 - (elapsed - t4) / 0.8)
      if (fadeOut <= 0) continue
      px = centerX
      py = centerY
      pAlpha = 0.5 * fadeOut
      pSize = p.size * responsiveSize * 0.2
    }

    // Draw particle using pre-rendered glow sprite
    const drawSize = pSize * 1.6
    ctx.globalCompositeOperation = 'lighter'
    ctx.globalAlpha = pAlpha
    ctx.drawImage(glowSprite, px - drawSize, py - drawSize, drawSize * 2, drawSize * 2)
  }

  // Trigger logo reveal
  if (elapsed > t3 + DOT_HOLD * 0.3 && !logoTriggered) {
    logoTriggered = true
    setTimeout(() => {
      showLogo.value = true
      setTimeout(() => { showTagline.value = true }, 600)
    }, 200)
  }

  // Initialize ambient Brownian particles once animation ends
  if (elapsed > t4 && !ambientInitialized) {
    ambientInitialized = true
    ambientParticles = []
    for (let i = 0; i < AMBIENT_COUNT; i++) {
      ambientParticles.push({
        x: Math.random() * cssWidth,
        y: Math.random() * cssHeight,
        vx: (Math.random() - 0.5) * 0.8,
        vy: (Math.random() - 0.5) * 0.8,
        size: 3 + Math.random() * 6,
        alpha: 0.4 + Math.random() * 0.4,
      })
    }
  }

  // Draw ambient Brownian particles (always after init)
  if (ambientInitialized) {
    // Fade in ambient particles
    const ambientFade = Math.min(1, (elapsed - t4) / 1.5)

    for (const ap of ambientParticles) {
      // Brownian motion: random nudge each frame
      ap.vx += (Math.random() - 0.5) * 0.15
      ap.vy += (Math.random() - 0.5) * 0.15
      // Dampen velocity
      ap.vx *= 0.98
      ap.vy *= 0.98
      // Update position
      ap.x += ap.vx
      ap.y += ap.vy

      // Wrap around edges
      if (ap.x < -20) ap.x = cssWidth + 20
      if (ap.x > cssWidth + 20) ap.x = -20
      if (ap.y < -20) ap.y = cssHeight + 20
      if (ap.y > cssHeight + 20) ap.y = -20

      const drawSize = ap.size * 2.5
      ctx.globalCompositeOperation = 'lighter'
      ctx.globalAlpha = ap.alpha * ambientFade
      ctx.drawImage(glowSprite, ap.x - drawSize, ap.y - drawSize, drawSize * 2, drawSize * 2)
    }
  }
}

function onResize() {
  setupCanvas()
}

onMounted(() => {
  createGlowSprite()
  initParticles()
  setupCanvas()
  startTime = performance.now() / 1000
  animate()
  window.addEventListener('resize', onResize, { passive: true })
})

onUnmounted(() => {
  cancelAnimationFrame(animationId)
  window.removeEventListener('resize', onResize)
})
</script>

<template>
  <div ref="heroRef" class="hero-animation">
    <canvas ref="canvasRef"></canvas>
    <div class="logo-container" :class="{ visible: showLogo }">
      <img src="/svgs/final.svg" alt="Logiforma" class="logo-image" />
      <p class="tagline" :class="{ visible: showTagline }">Transforming Noise to <span class="accent">Vision</span></p>
    </div>
    <h1 class="sr-only">Logiforma</h1>
  </div>
</template>

<style scoped>
.hero-animation {
  position: relative;
  width: 100%;
  height: 100dvh;
  min-height: 600px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--color-bg);
}

canvas {
  position: absolute;
  inset: 0;
  z-index: 1;
}

.logo-container {
  position: relative;
  z-index: 2;
  text-align: center;
  opacity: 0;
  transform: scale(0.95);
  transition:
    opacity 1.2s cubic-bezier(0.4, 0, 0.2, 1),
    transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
  pointer-events: none;
}

.logo-container.visible {
  opacity: 1;
  transform: scale(1);
}

.logo-image {
  width: clamp(280px, 50vw, 600px);
  height: auto;
}

.tagline {
  margin-top: 16px;
  font-size: clamp(1rem, 2vw, 1.375rem);
  color: var(--color-text-muted);
  font-weight: 400;
  letter-spacing: 0.02em;
  opacity: 0;
  transition: opacity 1s ease;
}

.tagline.visible {
  opacity: 1;
}

.tagline .accent {
  color: #d64238;
  font-weight: 600;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
</style>

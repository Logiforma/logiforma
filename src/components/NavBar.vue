<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { RouterLink, useRoute } from 'vue-router'

const route = useRoute()
const scrolled = ref(false)
const mobileOpen = ref(false)

const navLinks = [
  { name: 'Home', path: '/' },
  { name: 'About', path: '/about' },
  { name: 'Services', path: '/services' },
  { name: 'Pricing', path: '/pricing' },
  { name: 'Contact', path: '/contact' },
]

function onScroll() {
  scrolled.value = window.scrollY > 20
}

function closeMobile() {
  mobileOpen.value = false
}

onMounted(() => {
  window.addEventListener('scroll', onScroll, { passive: true })
  onScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', onScroll)
})
</script>

<template>
  <nav class="navbar" :class="{ scrolled }">
    <div class="container nav-inner">
      <RouterLink to="/" class="nav-logo" @click="closeMobile">
        <img src="/logo-transparent/Logo%20-%20Text%20-%20Dark.png" alt="Logiforma" class="logo-img" />
      </RouterLink>

      <button
        class="mobile-toggle"
        :class="{ active: mobileOpen }"
        @click="mobileOpen = !mobileOpen"
        aria-label="Toggle navigation"
      >
        <span></span>
        <span></span>
        <span></span>
      </button>

      <div class="nav-links desktop-links">
        <RouterLink
          v-for="link in navLinks"
          :key="link.path"
          :to="link.path"
          class="nav-link"
          :class="{ active: route.path === link.path }"
        >
          {{ link.name }}
        </RouterLink>
        <RouterLink to="/contact" class="btn btn-primary nav-cta">
          Get Started
        </RouterLink>
      </div>
    </div>
  </nav>

  <!-- Mobile full-screen overlay -->
  <Transition name="overlay">
    <div v-if="mobileOpen" class="mobile-overlay" @click.self="closeMobile">
      <div class="overlay-panel">
        <button class="overlay-close" @click="closeMobile" aria-label="Close menu">✕</button>
        <RouterLink
          v-for="link in navLinks"
          :key="link.path"
          :to="link.path"
          class="overlay-link"
          :class="{ active: route.path === link.path }"
          @click="closeMobile"
        >
          {{ link.name }}
        </RouterLink>
        <RouterLink to="/contact" class="overlay-cta" @click="closeMobile">
          Get Started
        </RouterLink>
      </div>
    </div>
  </Transition>
</template>

<style scoped>
.navbar {
  position: fixed;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
  height: 56px;
  width: min(880px, calc(100% - 32px));
  transition: top var(--transition), box-shadow var(--transition);
  background: rgba(15, 15, 18, 0.55);
  backdrop-filter: blur(24px) saturate(160%);
  -webkit-backdrop-filter: blur(24px) saturate(160%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 999px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.35);
}

.navbar.scrolled {
  background: rgba(15, 15, 18, 0.7);
  box-shadow: 0 12px 50px rgba(0, 0, 0, 0.5);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  padding: 0 12px 0 24px;
  max-width: none;
}

.nav-logo {
  display: flex;
  align-items: center;
  font-weight: 700;
  font-size: 1.0625rem;
  letter-spacing: -0.01em;
  color: var(--color-text);
}

.logo-img {
  height: 22px;
  width: auto;
}

.desktop-links {
  display: flex;
  align-items: center;
  gap: 4px;
}

.nav-link {
  padding: 8px 14px;
  font-size: 0.875rem;
  font-weight: 500;
  color: rgba(240, 236, 232, 0.85);
  border-radius: 999px;
  transition: all var(--transition);
}

.nav-link:hover,
.nav-link.active {
  color: var(--color-white);
  background: rgba(255, 255, 255, 0.08);
}

.nav-cta {
  margin-left: 8px;
  padding: 9px 18px;
  font-size: 0.8125rem;
  background: var(--color-white);
  color: #0a0a0a;
  border-radius: 999px;
}

.nav-cta:hover {
  background: #f0ece8;
  box-shadow: 0 0 24px rgba(255, 255, 255, 0.25);
  transform: none;
}

/* Hamburger */
.mobile-toggle {
  display: none;
  flex-direction: column;
  gap: 5px;
  padding: 8px;
  z-index: 1001;
}

.mobile-toggle span {
  display: block;
  width: 22px;
  height: 2px;
  background: var(--color-text);
  transition: all var(--transition);
  border-radius: 1px;
}

.mobile-toggle.active span:nth-child(1) {
  transform: rotate(45deg) translate(5px, 5px);
}

.mobile-toggle.active span:nth-child(2) {
  opacity: 0;
}

.mobile-toggle.active span:nth-child(3) {
  transform: rotate(-45deg) translate(5px, -5px);
}

/* ── Mobile full-screen overlay ── */
.mobile-overlay {
  position: fixed;
  inset: 0;
  z-index: 999;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: stretch;
  justify-content: center;
}

.overlay-panel {
  width: 100%;
  background: rgba(10, 10, 13, 0.96);
  backdrop-filter: blur(32px) saturate(160%);
  -webkit-backdrop-filter: blur(32px) saturate(160%);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 48px 32px 64px;
}

.overlay-close {
  position: absolute;
  top: 28px;
  right: 28px;
  width: 40px;
  height: 40px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  color: var(--color-white);
  font-size: 1.1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--transition);
}

.overlay-close:hover {
  background: rgba(255, 255, 255, 0.15);
}

.overlay-link {
  font-size: 1.75rem;
  font-weight: 700;
  color: rgba(240, 236, 232, 0.7);
  letter-spacing: -0.02em;
  padding: 10px 24px;
  border-radius: 12px;
  transition: color var(--transition), background var(--transition);
  width: 100%;
  text-align: center;
}

.overlay-link:hover,
.overlay-link.active {
  color: var(--color-white);
  background: rgba(255, 255, 255, 0.06);
}

.overlay-cta {
  margin-top: 24px;
  padding: 16px 48px;
  font-size: 1rem;
  font-weight: 700;
  background: var(--color-white);
  color: #0a0a0a;
  border-radius: 999px;
  transition: background var(--transition), transform var(--transition);
}

.overlay-cta:hover {
  background: #f0ece8;
  transform: scale(1.02);
}

/* Overlay enter/leave transition */
.overlay-enter-active,
.overlay-leave-active {
  transition: opacity 0.25s ease;
}

.overlay-enter-from,
.overlay-leave-to {
  opacity: 0;
}

.overlay-enter-active .overlay-panel,
.overlay-leave-active .overlay-panel {
  transition: transform 0.28s cubic-bezier(0.4, 0, 0.2, 1);
}

.overlay-enter-from .overlay-panel,
.overlay-leave-to .overlay-panel {
  transform: translateY(16px);
}

@media (max-width: 768px) {
  .navbar {
    border-radius: 28px;
    height: 52px;
  }

  .mobile-toggle {
    display: flex;
  }

  .desktop-links {
    display: none;
  }
}
</style>

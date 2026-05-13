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

      <div class="nav-links" :class="{ open: mobileOpen }">
        <RouterLink
          v-for="link in navLinks"
          :key="link.path"
          :to="link.path"
          class="nav-link"
          :class="{ active: route.path === link.path }"
          @click="closeMobile"
        >
          {{ link.name }}
        </RouterLink>
        <RouterLink to="/contact" class="btn btn-primary nav-cta" @click="closeMobile">
          Get Started
        </RouterLink>
      </div>
    </div>
  </nav>
</template>

<style scoped>
/*
 * Stitch-inspired "glass pill" navigation.
 * The bar is a centered, rounded-full container with a translucent dark
 * surface and backdrop blur — visible against both the dark hero and the
 * light editorial mid-section thanks to the strong blur + subtle border.
 */
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

.nav-links {
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

@media (max-width: 768px) {
  .navbar {
    border-radius: 28px;
    height: 52px;
  }

  .mobile-toggle {
    display: flex;
  }

  .nav-links {
    position: fixed;
    top: 0;
    right: 0;
    width: 280px;
    height: 100vh;
    background: rgba(15, 15, 18, 0.92);
    backdrop-filter: blur(24px);
    flex-direction: column;
    align-items: flex-start;
    padding: 100px 32px 32px;
    gap: 4px;
    transform: translateX(100%);
    visibility: hidden;
    transition: transform var(--transition), visibility var(--transition);
    border-left: 1px solid var(--color-border);
    border-radius: 0;
  }

  .nav-links.open {
    transform: translateX(0);
    visibility: visible;
  }

  .nav-link {
    width: 100%;
    padding: 12px 16px;
    font-size: 1rem;
  }

  .nav-cta {
    margin-left: 0;
    margin-top: 16px;
    width: 100%;
    text-align: center;
  }
}
</style>

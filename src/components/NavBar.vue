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
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: var(--nav-height);
  transition: all var(--transition);
  background: transparent;
}

.navbar.scrolled {
  background: rgba(10, 10, 10, 0.85);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid var(--color-border);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.nav-logo {
  display: flex;
  align-items: center;
}

.logo-img {
  height: 32px;
  width: auto;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 8px;
}

.nav-link {
  padding: 8px 16px;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--color-text-muted);
  border-radius: var(--radius-sm);
  transition: all var(--transition);
}

.nav-link:hover,
.nav-link.active {
  color: var(--color-text);
}

.nav-link.active {
  background: var(--color-bg-elevated);
}

.nav-cta {
  margin-left: 16px;
  padding: 10px 24px;
  font-size: 0.8125rem;
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
  .mobile-toggle {
    display: flex;
  }

  .nav-links {
    position: fixed;
    top: 0;
    right: 0;
    width: 280px;
    height: 100vh;
    background: var(--color-bg-elevated);
    flex-direction: column;
    align-items: flex-start;
    padding: 100px 32px 32px;
    gap: 4px;
    transform: translateX(100%);
    transition: transform var(--transition);
    border-left: 1px solid var(--color-border);
  }

  .nav-links.open {
    transform: translateX(0);
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

<script setup lang="ts">
import { RouterView } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import FooterSection from '@/components/FooterSection.vue'
import MorphingBackground from '@/components/MorphingBackground.vue'
</script>

<template>
  <!-- Persistent scroll-driven 3D background that morphs through three states -->
  <MorphingBackground />
  <NavBar />
  <main>
    <RouterView />
  </main>
  <FooterSection />
</template>

<style scoped>
main {
  min-height: 100vh;
  position: relative;
  z-index: 1;
}
</style>

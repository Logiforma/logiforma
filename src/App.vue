<script setup lang="ts">
import { RouterView } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import FooterSection from '@/components/FooterSection.vue'
</script>

<template>
  <NavBar />
  <main>
    <RouterView />
  </main>
  <FooterSection />
</template>

<style scoped>
main {
  min-height: 100vh;
}
</style>

<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import HeroAnimation from '@/components/HeroAnimation.vue'

const stats = [
  { value: '$8K+', label: 'Monthly savings per client' },
  { value: '90%', label: 'Reduction in labor hours' },
  { value: '20x', label: 'Seasonal demand handling' },
  { value: '100%', label: 'ERP bottlenecks eliminated' },
]

const pillars = [
  {
    icon: '⟁',
    title: 'Connected Applications',
    desc: 'Ensure every tool in your enterprise ecosystem communicates seamlessly — no brittle middleware, no custom glue code.',
  },
  {
    icon: '⚡',
    title: 'Intelligent Automation',
    desc: 'Streamline repetitive tasks and optimize your workforce with AI-driven workflow automation.',
  },
  {
    icon: '◈',
    title: 'Data Pipelines',
    desc: 'Create clean, reliable flows of information across your entire supply chain from a single unified platform.',
  },
]

const services = [
  {
    title: 'Custom Digital Solutions',
    desc: 'Tailored platforms aligned with your unique business processes.',
  },
  {
    title: 'ERP & CRM Integration',
    desc: 'Seamless integration with logistics and delivery partners.',
  },
  {
    title: 'Marketplace Management',
    desc: 'End-to-end solutions for multi-channel marketplace operations.',
  },
  {
    title: 'Data Pipelines & Automation',
    desc: 'Consolidated data from multiple sources into a unified platform.',
  },
  {
    title: 'Analytics & Reporting',
    desc: 'AI-powered dashboards for real-time decision making.',
  },
  {
    title: 'Mobile Applications',
    desc: 'All solutions available on Android and iOS platforms.',
  },
]

function setupScrollAnimations() {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible')
        }
      })
    },
    { threshold: 0.1 }
  )

  document.querySelectorAll('.fade-in').forEach((el) => observer.observe(el))
}

onMounted(() => {
  setupScrollAnimations()
})
</script>

<template>
  <div class="home-page">
    <!-- Hero — full-viewport overlay on MorphingBackground -->
    <section class="hero-section">
      <div class="hero-content container">
        <h1 class="hero-title">
          Transform your ERP ecosystem<br />
          through intelligent automation.
        </h1>
        <p class="hero-desc">
          Seamless integrations and data-driven insights
          for the modern enterprise.
        </p>
        <div class="hero-buttons">
          <RouterLink to="/contact" class="btn btn-pill-light">
            <span>Get Started</span>
            <span class="btn-arrow" aria-hidden="true">→</span>
          </RouterLink>
          <RouterLink to="/services" class="btn btn-pill-ghost">Explore Platform</RouterLink>
        </div>
      </div>
    </section>

    <!-- Stats -->
    <section class="stats-section">
      <div class="container">
        <div class="stats-grid fade-in">
          <div v-for="stat in stats" :key="stat.label" class="stat-item">
            <span class="stat-value">{{ stat.value }}</span>
            <span class="stat-label">{{ stat.label }}</span>
          </div>
        </div>
      </div>
    </section>

    <!-- Pillars -->
    <section class="pillars-section section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">Core Platform</span>
          <h2 class="section-title">Three pillars of<br />operational excellence</h2>
          <p class="section-subtitle">
            Logiforma is engineered for reliability and high performance,
            built on three foundational pillars.
          </p>
        </div>
        <div class="pillars-grid">
          <div v-for="(pillar, idx) in pillars" :key="pillar.title" class="pillar-card fade-in" :style="{ transitionDelay: `${idx * 0.1}s` }">
            <span class="pillar-icon">{{ pillar.icon }}</span>
            <h3 class="pillar-title">{{ pillar.title }}</h3>
            <p class="pillar-desc">{{ pillar.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Services Overview -->
    <section class="services-section section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">Solutions</span>
          <h2 class="section-title">Everything your enterprise needs</h2>
          <p class="section-subtitle">
            A comprehensive suite of PaaS and SaaS solutions designed to enhance your ERP ecosystem.
          </p>
        </div>
        <div class="services-grid">
          <div v-for="(service, idx) in services" :key="service.title" class="service-card fade-in" :style="{ transitionDelay: `${idx * 0.08}s` }">
            <div class="service-number">{{ String(idx + 1).padStart(2, '0') }}</div>
            <h3 class="service-title">{{ service.title }}</h3>
            <p class="service-desc">{{ service.desc }}</p>
          </div>
        </div>
        <div class="text-center fade-in" style="margin-top: 48px">
          <RouterLink to="/services" class="btn btn-outline">View All Services →</RouterLink>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="cta-section section">
      <div class="container">
        <div class="cta-card fade-in">
          <h2 class="cta-title">Ready to transform your<br />enterprise operations?</h2>
          <p class="cta-desc">
            Join industry leaders who are redefining their ERP ecosystems with Logiforma.
          </p>
          <div class="cta-buttons">
            <RouterLink to="/contact" class="btn btn-primary">Start Your Journey</RouterLink>
            <RouterLink to="/pricing" class="btn btn-outline">View Pricing</RouterLink>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
/* Hero — left-aligned editorial layout from Stitch design 1 */
.hero-section {
  position: relative;
  min-height: 100dvh;
  display: flex;
  align-items: center;
  /* transparent so morphing 3D background shows */
  background: transparent;
}

.hero-content {
  position: relative;
  z-index: 3;
  max-width: 720px;
  padding: 120px 24px 80px;
  text-align: left;
}

.hero-title {
  font-size: clamp(2.5rem, 6.5vw, 5.5rem);
  font-weight: 700;
  line-height: 1.02;
  letter-spacing: -0.035em;
  color: var(--color-white);
  margin-bottom: 28px;
  text-shadow: 0 4px 40px rgba(0, 0, 0, 0.5);
}

.hero-desc {
  font-size: clamp(1rem, 1.6vw, 1.25rem);
  color: rgba(240, 236, 232, 0.78);
  max-width: 480px;
  margin: 0 0 40px;
  line-height: 1.6;
  text-shadow: 0 2px 20px rgba(0, 0, 0, 0.4);
}

.hero-buttons {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}

/* White pill CTA — Stitch design language */
.btn-pill-light {
  display: inline-flex;
  align-items: center;
  gap: 14px;
  padding: 10px 12px 10px 28px;
  font-size: 0.9375rem;
  font-weight: 600;
  background: var(--color-white);
  color: #0a0a0a;
  border-radius: 999px;
  transition: all var(--transition);
}

.btn-pill-light:hover {
  background: #f5efe7;
  transform: translateY(-1px);
  box-shadow: 0 12px 40px rgba(255, 255, 255, 0.2);
}

.btn-pill-light .btn-arrow {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  border-radius: 999px;
  background: #0a0a0a;
  color: var(--color-white);
  font-size: 0.875rem;
}

.btn-pill-ghost {
  display: inline-flex;
  align-items: center;
  padding: 12px 26px;
  font-size: 0.9375rem;
  font-weight: 500;
  color: var(--color-white);
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 999px;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  transition: all var(--transition);
}

.btn-pill-ghost:hover {
  background: rgba(255, 255, 255, 0.14);
  border-color: rgba(255, 255, 255, 0.3);
}

/* Stats */
.stats-section {
  padding: 80px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  background: rgba(8, 8, 10, 0.80);
  backdrop-filter: blur(24px) saturate(150%);
  -webkit-backdrop-filter: blur(24px) saturate(150%);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 32px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: clamp(2rem, 4vw, 3rem);
  font-weight: 800;
  color: var(--color-text);
  letter-spacing: -0.02em;
}

.stat-label {
  display: block;
  font-size: 0.875rem;
  color: var(--color-text-muted);
  margin-top: 8px;
}

/* Pillars */
.section-header {
  margin-bottom: 64px;
}

.pillars-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}

.pillar-card {
  background: rgba(10, 10, 12, 0.80);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--radius);
  padding: 40px 32px;
  transition: all var(--transition);
}

.pillar-card:hover {
  background: rgba(18, 18, 22, 0.88);
  border-color: rgba(255, 255, 255, 0.18);
  transform: translateY(-4px);
}

.pillar-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  border-radius: var(--radius-sm);
  background: rgba(214, 66, 56, 0.1);
  color: var(--color-accent);
  font-size: 1.25rem;
  margin-bottom: 24px;
}

.pillar-title {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 12px;
}

.pillar-desc {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.7;
}

/* Services */
.services-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.service-card {
  background: rgba(10, 10, 12, 0.80);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--radius);
  padding: 32px;
  transition: all var(--transition);
}

.service-card:hover {
  background: rgba(18, 18, 22, 0.88);
  border-color: rgba(255, 255, 255, 0.18);
}

.service-number {
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--color-accent);
  margin-bottom: 16px;
  font-family: monospace;
}

.service-title {
  font-size: 1.125rem;
  font-weight: 700;
  margin-bottom: 8px;
}

.service-desc {
  font-size: 0.875rem;
  color: var(--color-text-muted);
  line-height: 1.6;
}

.text-center {
  text-align: center;
}

/* CTA */
.cta-section {
  padding-bottom: 120px;
}

.cta-card {
  text-align: center;
  padding: 80px 40px;
  background: rgba(10, 10, 12, 0.80);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  position: relative;
  overflow: hidden;
}

.cta-card::before {
  content: '';
  position: absolute;
  top: -200px;
  left: 50%;
  transform: translateX(-50%);
  width: 600px;
  height: 400px;
  background: radial-gradient(ellipse, var(--color-accent-glow), transparent 70%);
  opacity: 0.4;
  pointer-events: none;
}

.cta-title {
  font-size: clamp(1.75rem, 3vw, 2.5rem);
  font-weight: 800;
  margin-bottom: 16px;
  letter-spacing: -0.02em;
  position: relative;
}

.cta-desc {
  font-size: 1.125rem;
  color: var(--color-text-muted);
  margin-bottom: 32px;
  position: relative;
}

.cta-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
  position: relative;
}

/* Responsive */
@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .pillars-grid,
  .services-grid {
    grid-template-columns: 1fr;
  }

  .hero-content {
    padding: 24px 20px 32px;
    bottom: env(safe-area-inset-bottom, 0px);
  }
}
</style>

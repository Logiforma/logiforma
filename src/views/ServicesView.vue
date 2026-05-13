<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterLink } from 'vue-router'

const services = [
  {
    title: 'Custom Digital Solutions',
    desc: 'Tailored platforms that align with unique business processes, eliminating inefficiencies caused by rigid, template-based systems. We build solutions around your actual workflows, not the other way around.',
    features: ['Process-aligned architecture', 'Custom workflow engines', 'Domain-specific logic', 'Iterative development'],
  },
  {
    title: 'ERP & CRM Integration',
    desc: 'Seamless integration of enterprise systems with logistics and delivery partners, ensuring consistent and reliable data exchange. No more brittle middleware or fragile point-to-point connections.',
    features: ['Native ERP connectors', 'Bi-directional sync', 'Real-time data exchange', 'Partner ecosystem management'],
  },
  {
    title: 'Marketplace Management',
    desc: 'End-to-end solutions for managing marketplace operations, enabling better visibility and control across channels. Centralize your multi-channel presence from a single pane of glass.',
    features: ['Multi-channel orchestration', 'Inventory synchronization', 'Order lifecycle management', 'Channel analytics'],
  },
  {
    title: 'Master Data Management',
    desc: 'A single source of truth for enterprise data. Consolidate information from disparate sources into one unified platform managing inventory funnels — from total and allocated stock to reserved and released units — with absolute precision.',
    features: ['Data consolidation', 'Inventory funnel tracking', 'Cross-system harmonization', 'Audit trails'],
  },
  {
    title: 'Data Pipelines & Automation',
    desc: 'Robust data pipelines that consolidate information from multiple sources into a single, unified platform. Automate the tedious data wrangling so your team focuses on insights, not extraction.',
    features: ['ETL/ELT pipelines', 'Event-driven architectures', 'Scheduling & orchestration', 'Error handling & recovery'],
  },
  {
    title: 'Analytics & Reporting',
    desc: 'Advanced dashboards powered by AI insights, enabling businesses to make informed decisions based on real-time data. See what matters, when it matters.',
    features: ['Real-time dashboards', 'Predictive analytics', 'Custom KPI tracking', 'Automated report generation'],
  },
  {
    title: 'Mobile Applications',
    desc: 'All solutions are available on Android and iOS platforms. Your team stays connected and productive whether they are on the warehouse floor, in the field, or at headquarters.',
    features: ['Native Android & iOS', 'Offline-first capability', 'Push notifications', 'Biometric security'],
  },
]

const industries = [
  {
    name: 'Fashion & Retail',
    desc: 'Complex supply chains, seasonal demand spikes, multi-channel inventory management and marketplace integrations.',
  },
  {
    name: 'HVAC',
    desc: 'Service scheduling, parts inventory, field operations management and dealer network coordination.',
  },
  {
    name: 'EdTech',
    desc: 'User management, content delivery, analytics tracking and institutional integrations.',
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

onMounted(() => setupScrollAnimations())
</script>

<template>
  <div class="services-page">
    <section class="page-hero">
      <div class="container">
        <span class="section-label fade-in">Platform & Solutions</span>
        <h1 class="page-hero-title fade-in">PaaS infrastructure.<br />SaaS solutions. One platform.</h1>
        <p class="page-hero-desc fade-in">
          A comprehensive suite of solutions designed to enhance your ERP ecosystem,
          available as managed platform services or turnkey SaaS products.
        </p>
      </div>
    </section>

    <!-- Services List -->
    <section class="section">
      <div class="container">
        <div class="services-list">
          <div v-for="(service, idx) in services" :key="service.title" class="service-row fade-in" :style="{ transitionDelay: `${idx * 0.05}s` }">
            <div class="service-header">
              <span class="service-num">{{ String(idx + 1).padStart(2, '0') }}</span>
              <h3 class="service-title">{{ service.title }}</h3>
            </div>
            <p class="service-desc">{{ service.desc }}</p>
            <div class="service-features">
              <span v-for="feature in service.features" :key="feature" class="feature-tag">
                {{ feature }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Industries -->
    <section class="section industries-section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">Industries</span>
          <h2 class="section-title">Built for complex operations</h2>
          <p class="section-subtitle">
            Particularly suited for organizations dealing with complex supply chains,
            high transaction volumes and multi-system integrations.
          </p>
        </div>
        <div class="industries-grid">
          <div v-for="(industry, idx) in industries" :key="industry.name" class="industry-card fade-in" :style="{ transitionDelay: `${idx * 0.1}s` }">
            <h3>{{ industry.name }}</h3>
            <p>{{ industry.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="section">
      <div class="container">
        <div class="inline-cta fade-in">
          <div>
            <h3>Need a tailored solution?</h3>
            <p>Let's discuss how Logiforma can address your specific operational challenges.</p>
          </div>
          <RouterLink to="/contact" class="btn btn-primary">Talk to Us</RouterLink>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.page-hero {
  padding: 160px 0 80px;
}

.page-hero-title {
  font-size: clamp(2.5rem, 5vw, 3.5rem);
  font-weight: 800;
  line-height: 1.15;
  letter-spacing: -0.02em;
  margin-bottom: 20px;
  color: var(--color-white);
  text-shadow: 0 4px 32px rgba(0, 0, 0, 0.5);
}

.page-hero-desc {
  font-size: 1.125rem;
  color: rgba(240, 236, 232, 0.75);
  max-width: 640px;
  line-height: 1.7;
}

/* Services — card grid instead of divider rows */
.services-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.service-row {
  padding: 36px 32px;
  background: rgba(10, 10, 12, 0.80);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--radius);
  transition: border-color var(--transition), transform var(--transition);
}

.service-row:hover {
  border-color: rgba(255, 255, 255, 0.16);
  transform: translateY(-2px);
}

.service-header {
  display: flex;
  align-items: baseline;
  gap: 12px;
  margin-bottom: 12px;
}

.service-num {
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--color-accent);
  font-family: monospace;
}

.service-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--color-white);
}

.service-desc {
  font-size: 0.9375rem;
  color: rgba(240, 236, 232, 0.70);
  line-height: 1.7;
  margin-bottom: 20px;
}

.service-features {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.feature-tag {
  padding: 5px 12px;
  font-size: 0.8rem;
  background: rgba(255, 255, 255, 0.07);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  color: rgba(240, 236, 232, 0.65);
}

/* Industries */
.industries-section {
  background: transparent;
}

.section-header {
  margin-bottom: 48px;
}

.industries-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.industry-card {
  padding: 40px 32px;
  background: rgba(10, 10, 12, 0.80);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--radius);
  transition: all var(--transition);
}

.industry-card:hover {
  border-color: rgba(255, 255, 255, 0.16);
  transform: translateY(-2px);
}

.industry-card h3 {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 12px;
  color: var(--color-white);
}

.industry-card p {
  font-size: 0.9375rem;
  color: rgba(240, 236, 232, 0.70);
  line-height: 1.7;
}

/* Inline CTA */
.inline-cta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 48px;
  background: rgba(10, 10, 12, 0.80);
  backdrop-filter: blur(20px) saturate(150%);
  -webkit-backdrop-filter: blur(20px) saturate(150%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--radius);
  gap: 32px;
}

.inline-cta h3 {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 8px;
  color: var(--color-white);
}

.inline-cta p {
  font-size: 0.9375rem;
  color: rgba(240, 236, 232, 0.70);
}

@media (max-width: 900px) {
  .services-list {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .industries-grid {
    grid-template-columns: 1fr;
  }

  .inline-cta {
    flex-direction: column;
    text-align: center;
  }
}
</style>

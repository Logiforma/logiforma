<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterLink } from 'vue-router'

const features = [
  {
    category: 'Platform',
    items: [
      'Custom digital solutions',
      'ERP & CRM integration',
      'Marketplace management',
      'Master data management',
      'Data pipelines & automation',
      'AI-powered analytics & reporting',
    ],
  },
  {
    category: 'Infrastructure',
    items: [
      'Dedicated infrastructure',
      'SLA-backed uptime',
      'On-premise deployment option',
      'Unlimited users',
      'Mobile app (Android & iOS)',
      'API access',
    ],
  },
  {
    category: 'Support',
    items: [
      'Dedicated account manager',
      'Custom implementation services',
      'Ongoing optimization',
      '24/7 priority support',
      'GDPR & DPDP compliance',
      'Security audits',
    ],
  },
]

const process = [
  {
    step: '01',
    title: 'Discovery',
    desc: 'We map your existing workflows, identify bottlenecks, and understand your operational landscape.',
  },
  {
    step: '02',
    title: 'Proposal',
    desc: 'We design a tailored solution architecture and present a transparent, scope-based pricing proposal.',
  },
  {
    step: '03',
    title: 'Implementation',
    desc: 'Our team builds and deploys your customized platform, integrating with your existing systems.',
  },
  {
    step: '04',
    title: 'Growth',
    desc: 'Ongoing optimization, support, and scaling as your business demands evolve.',
  },
]

const faqs = [
  {
    q: 'How is pricing determined?',
    a: 'Pricing is based on your specific requirements — the complexity of integrations, data volume, number of users, and the scope of customization needed. We provide a detailed, transparent proposal after our discovery phase.',
  },
  {
    q: 'What is the difference between PaaS and SaaS offerings?',
    a: 'Our SaaS solutions are ready-to-use applications you can start with quickly. Our PaaS offerings provide the underlying platform and infrastructure for building custom solutions tailored to your specific processes. Most enterprise engagements leverage both.',
  },
  {
    q: 'Do you offer a pilot or proof of concept?',
    a: 'Yes. We can scope a focused pilot to demonstrate value within a specific workflow or integration before committing to a full platform deployment.',
  },
  {
    q: 'How do you handle data security?',
    a: 'We maintain GDPR and DPDP-compliant infrastructure. All data is encrypted at rest and in transit, with regular security audits and penetration testing.',
  },
  {
    q: 'What does ongoing support look like?',
    a: 'Every engagement includes a dedicated account manager, 24/7 support, proactive monitoring, and continuous optimization to ensure your platform evolves with your business.',
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
  <div class="pricing-page">
    <section class="page-hero">
      <div class="container">
        <span class="section-label fade-in">Pricing</span>
        <h1 class="page-hero-title fade-in">Enterprise solutions,<br />tailored to your scale</h1>
        <p class="page-hero-desc fade-in">
          Every enterprise is different. We design and price solutions around your actual
          operational requirements — no generic tiers, no unnecessary features.
        </p>
      </div>
    </section>

    <!-- Single Plan CTA -->
    <section class="section">
      <div class="container">
        <div class="pricing-hero-card fade-in">
          <div class="pricing-hero-left">
            <span class="plan-tag">Enterprise Platform</span>
            <h2 class="pricing-hero-title">Full-stack PaaS + SaaS</h2>
            <p class="pricing-hero-desc">
              A unified, scalable platform tailored to your business — connecting your ERP,
              automating workflows, and delivering real-time intelligence. Custom-scoped and
              priced for your exact needs.
            </p>
            <div class="pricing-hero-highlights">
              <div class="highlight-item">
                <span class="highlight-value">~$8K</span>
                <span class="highlight-label">Avg. monthly savings</span>
              </div>
              <div class="highlight-item">
                <span class="highlight-value">90%</span>
                <span class="highlight-label">Labor hours reduced</span>
              </div>
              <div class="highlight-item">
                <span class="highlight-value">20x</span>
                <span class="highlight-label">Demand spike handling</span>
              </div>
            </div>
            <RouterLink to="/contact" class="btn btn-primary">Contact Us</RouterLink>
          </div>
          <div class="pricing-hero-right">
            <div v-for="group in features" :key="group.category" class="feature-group">
              <h4 class="feature-group-title">{{ group.category }}</h4>
              <ul>
                <li v-for="item in group.items" :key="item">
                  <span class="check">✓</span>
                  {{ item }}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Process -->
    <section class="section process-section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">How It Works</span>
          <h2 class="section-title">From conversation to production</h2>
          <p class="section-subtitle">
            A structured, transparent process designed to deliver results quickly.
          </p>
        </div>
        <div class="process-grid">
          <div v-for="(item, idx) in process" :key="item.step" class="process-card fade-in" :style="{ transitionDelay: `${idx * 0.1}s` }">
            <span class="process-step">{{ item.step }}</span>
            <h3 class="process-title">{{ item.title }}</h3>
            <p class="process-desc">{{ item.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- FAQ -->
    <section class="section faq-section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">FAQ</span>
          <h2 class="section-title">Common questions</h2>
        </div>
        <div class="faq-list">
          <div v-for="(faq, idx) in faqs" :key="idx" class="faq-item fade-in" :style="{ transitionDelay: `${idx * 0.05}s` }">
            <h4 class="faq-question">{{ faq.q }}</h4>
            <p class="faq-answer">{{ faq.a }}</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.page-hero {
  padding: 160px 0 80px;
  border-bottom: 1px solid var(--color-border);
}

.page-hero-title {
  font-size: clamp(2.5rem, 5vw, 3.5rem);
  font-weight: 800;
  line-height: 1.15;
  letter-spacing: -0.02em;
  margin-bottom: 20px;
}

.page-hero-desc {
  font-size: 1.125rem;
  color: var(--color-text-muted);
  max-width: 640px;
  line-height: 1.7;
}

/* Pricing hero card */
.pricing-hero-card {
  display: grid;
  grid-template-columns: 1fr 1fr;
  background: var(--color-bg-card);
  border: 1px solid var(--color-accent);
  border-radius: 20px;
  overflow: hidden;
}

.pricing-hero-left {
  padding: 56px 48px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.plan-tag {
  font-size: 0.6875rem;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 20px;
  background: rgba(214, 66, 56, 0.12);
  color: var(--color-accent);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 20px;
}

.pricing-hero-title {
  font-size: 2rem;
  font-weight: 800;
  margin-bottom: 16px;
  letter-spacing: -0.01em;
}

.pricing-hero-desc {
  font-size: 1rem;
  color: var(--color-text-muted);
  line-height: 1.7;
  margin-bottom: 32px;
}

.pricing-hero-highlights {
  display: flex;
  gap: 32px;
  margin-bottom: 36px;
}

.highlight-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.highlight-value {
  font-size: 1.5rem;
  font-weight: 800;
  color: var(--color-text);
}

.highlight-label {
  font-size: 0.75rem;
  color: var(--color-text-muted);
}

.pricing-hero-right {
  padding: 56px 48px;
  background: var(--color-bg-elevated);
  border-left: 1px solid var(--color-border);
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.feature-group-title {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--color-accent);
  margin-bottom: 12px;
}

.feature-group ul {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.feature-group li {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.8125rem;
  color: var(--color-text-muted);
}

.check {
  color: var(--color-accent);
  font-weight: 700;
  font-size: 0.75rem;
  flex-shrink: 0;
}

/* Process */
.process-section {
  background: var(--color-bg-elevated);
}

.section-header {
  margin-bottom: 48px;
}

.process-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.process-card {
  padding: 32px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  transition: all var(--transition);
}

.process-card:hover {
  border-color: var(--color-border-light);
  transform: translateY(-2px);
}

.process-step {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--color-accent);
  font-family: monospace;
  margin-bottom: 16px;
}

.process-title {
  font-size: 1.125rem;
  font-weight: 700;
  margin-bottom: 8px;
}

.process-desc {
  font-size: 0.875rem;
  color: var(--color-text-muted);
  line-height: 1.6;
}

/* FAQ */
.faq-section {
  background: var(--color-bg);
}

.faq-list {
  max-width: 720px;
  display: flex;
  flex-direction: column;
}

.faq-item {
  padding: 32px 0;
  border-bottom: 1px solid var(--color-border);
}

.faq-item:first-child {
  border-top: 1px solid var(--color-border);
}

.faq-question {
  font-size: 1.0625rem;
  font-weight: 600;
  margin-bottom: 10px;
}

.faq-answer {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.7;
}

@media (max-width: 768px) {
  .pricing-hero-card {
    grid-template-columns: 1fr;
  }

  .pricing-hero-right {
    border-left: none;
    border-top: 1px solid var(--color-border);
  }

  .pricing-hero-left,
  .pricing-hero-right {
    padding: 40px 28px;
  }

  .pricing-hero-highlights {
    flex-direction: column;
    gap: 16px;
  }

  .feature-group ul {
    grid-template-columns: 1fr;
  }

  .process-grid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 480px) {
  .process-grid {
    grid-template-columns: 1fr;
  }
}
</style>

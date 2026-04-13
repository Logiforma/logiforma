<script setup lang="ts">
import { onMounted } from 'vue'

const values = [
  {
    title: 'Innovation',
    desc: 'Leveraging AI and advanced technologies to drive transformation.',
  },
  {
    title: 'Customer-Centricity',
    desc: 'Designing solutions aligned with real business workflows.',
  },
  {
    title: 'Integrity & Security',
    desc: 'Ensuring compliance with global data protection standards (GDPR, DPDP).',
  },
  {
    title: 'Scalability',
    desc: 'Building systems that grow with business demands.',
  },
  {
    title: 'Efficiency',
    desc: 'Delivering measurable cost savings and productivity improvements.',
  },
]

const approach = [
  'Mapping existing business workflows',
  'Identifying inefficiencies and bottlenecks',
  'Designing optimized workflows aligned with real operations',
  'Delivering customized dashboards focused on critical KPIs',
]

const goals = [
  'Expanding AI-driven analytics and predictive intelligence',
  'Strengthening integration capabilities across emerging technologies',
  'Scaling presence across additional industries and global markets',
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
  <div class="about-page">
    <!-- Hero -->
    <section class="page-hero">
      <div class="container">
        <span class="section-label fade-in">About Us</span>
        <h1 class="page-hero-title fade-in">Redefining how enterprises<br />interact with their ERP systems</h1>
        <p class="page-hero-desc fade-in">
          Logiforma is a next-generation digital platform provider focused on transforming
          enterprise ERP ecosystems through intelligent automation, seamless integrations
          and data-driven insights.
        </p>
      </div>
    </section>

    <!-- Story -->
    <section class="section">
      <div class="container">
        <div class="two-col">
          <div class="col-content fade-in">
            <span class="section-label">Our Story</span>
            <h2 class="section-title">Built to solve<br />real complexity</h2>
            <p class="body-text">
              Logiforma was established with the vision of addressing the growing complexity in
              enterprise ERP landscapes. As organizations increasingly rely on multiple systems,
              integrations and data sources, traditional ERP implementations often struggle to
              deliver real-time insights and operational agility.
            </p>
            <p class="body-text">
              Recognizing this gap, we developed a platform that acts as a centralized digital
              layer — integrating data, automating workflows and enabling intelligent reporting —
              thus redefining how enterprises manage their operations.
            </p>
          </div>
          <div class="col-visual fade-in">
            <div class="vision-card">
              <h3>Vision</h3>
              <p>
                To become the digital backbone for enterprise operations by redefining how
                organizations interact with their ERP systems through intelligent, connected
                and scalable solutions.
              </p>
            </div>
            <div class="vision-card">
              <h3>Mission</h3>
              <p>
                To empower enterprises with unified platforms that transform complex data into
                actionable insights, enabling faster decision-making, operational excellence
                and sustainable growth.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Values -->
    <section class="section values-section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">Core Values</span>
          <h2 class="section-title">What drives us</h2>
        </div>
        <div class="values-grid">
          <div v-for="(value, idx) in values" :key="value.title" class="value-card fade-in" :style="{ transitionDelay: `${idx * 0.08}s` }">
            <div class="value-num">{{ String(idx + 1).padStart(2, '0') }}</div>
            <h3 class="value-title">{{ value.title }}</h3>
            <p class="value-desc">{{ value.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Approach -->
    <section class="section">
      <div class="container">
        <div class="two-col">
          <div class="col-content fade-in">
            <span class="section-label">Our Approach</span>
            <h2 class="section-title">Process-first<br />methodology</h2>
            <p class="body-text">
              We emphasize understanding your business before writing a single line of code.
              Our solutions are not only technically robust but also practically effective.
            </p>
          </div>
          <div class="col-content fade-in">
            <ul class="approach-list">
              <li v-for="(step, idx) in approach" :key="idx" class="approach-item">
                <span class="approach-num">{{ idx + 1 }}</span>
                <span>{{ step }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <!-- Future -->
    <section class="section future-section">
      <div class="container">
        <div class="section-header fade-in">
          <span class="section-label">Looking Ahead</span>
          <h2 class="section-title">Strategic direction</h2>
          <p class="section-subtitle">
            We're continuously enhancing our platform capabilities to stay ahead
            of the evolving enterprise landscape.
          </p>
        </div>
        <div class="goals-grid">
          <div v-for="(goal, idx) in goals" :key="idx" class="goal-card fade-in" :style="{ transitionDelay: `${idx * 0.1}s` }">
            <span class="goal-arrow">→</span>
            <p>{{ goal }}</p>
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

.two-col {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 64px;
  align-items: start;
}

.body-text {
  font-size: 1rem;
  color: var(--color-text-muted);
  line-height: 1.8;
  margin-bottom: 16px;
}

.vision-card {
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 32px;
  margin-bottom: 16px;
}

.vision-card h3 {
  font-size: 1rem;
  font-weight: 700;
  margin-bottom: 12px;
  color: var(--color-accent);
}

.vision-card p {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.7;
}

.values-section {
  background: var(--color-bg-elevated);
}

.values-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 20px;
}

.value-card {
  padding: 32px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  transition: all var(--transition);
}

.value-card:hover {
  border-color: var(--color-border-light);
  transform: translateY(-2px);
}

.value-num {
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--color-accent);
  font-family: monospace;
  margin-bottom: 16px;
}

.value-title {
  font-size: 1.125rem;
  font-weight: 700;
  margin-bottom: 8px;
}

.value-desc {
  font-size: 0.875rem;
  color: var(--color-text-muted);
  line-height: 1.6;
}

.approach-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.approach-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 24px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  font-size: 0.9375rem;
  color: var(--color-text-muted);
}

.approach-num {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(214, 66, 56, 0.15);
  color: var(--color-accent);
  font-size: 0.8125rem;
  font-weight: 700;
  flex-shrink: 0;
}

.goals-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.goal-card {
  padding: 32px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  transition: all var(--transition);
}

.goal-card:hover {
  border-color: var(--color-border-light);
}

.goal-arrow {
  display: block;
  color: var(--color-accent);
  font-size: 1.25rem;
  margin-bottom: 12px;
}

.goal-card p {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.6;
}

@media (max-width: 768px) {
  .two-col {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .goals-grid {
    grid-template-columns: 1fr;
  }
}
</style>

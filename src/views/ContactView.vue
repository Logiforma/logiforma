<script setup lang="ts">
import { ref, onMounted } from 'vue'

const form = ref({
  name: '',
  email: '',
  company: '',
  subject: '',
  message: '',
})

const submitted = ref(false)

function handleSubmit() {
  // In production, this would send to an API
  submitted.value = true
}

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
  <div class="contact-page">
    <section class="page-hero">
      <div class="container">
        <span class="section-label fade-in">Contact</span>
        <h1 class="page-hero-title fade-in">Let's build something<br />remarkable together</h1>
        <p class="page-hero-desc fade-in">
          Whether you're exploring platform options or ready to transform your
          enterprise operations — we're here to help.
        </p>
      </div>
    </section>

    <section class="section">
      <div class="container">
        <div class="contact-grid">
          <div class="contact-info fade-in">
            <div class="info-card">
              <h3>Start a conversation</h3>
              <p>
                Tell us about your business challenges and we'll show you how
                Logiforma can help you streamline operations, reduce costs, and
                scale with confidence.
              </p>
            </div>

            <div class="info-items">
              <div class="info-item">
                <span class="info-label">Response time</span>
                <span class="info-value">Within 24 hours</span>
              </div>
              <div class="info-item">
                <span class="info-label">Consultation</span>
                <span class="info-value">Free initial assessment</span>
              </div>
              <div class="info-item">
                <span class="info-label">Compliance</span>
                <span class="info-value">GDPR & DPDP compliant</span>
              </div>
            </div>
          </div>

          <div class="contact-form-wrapper fade-in">
            <div v-if="submitted" class="success-message">
              <div class="success-icon">✓</div>
              <h3>Message sent</h3>
              <p>Thanks for reaching out. We'll get back to you within 24 hours.</p>
            </div>

            <form v-else class="contact-form" @submit.prevent="handleSubmit">
              <div class="form-row">
                <div class="form-group">
                  <label for="name">Name</label>
                  <input
                    id="name"
                    v-model="form.name"
                    type="text"
                    placeholder="Your name"
                    required
                    autocomplete="name"
                  />
                </div>
                <div class="form-group">
                  <label for="email">Email</label>
                  <input
                    id="email"
                    v-model="form.email"
                    type="email"
                    placeholder="you@company.com"
                    required
                    autocomplete="email"
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label for="company">Company</label>
                  <input
                    id="company"
                    v-model="form.company"
                    type="text"
                    placeholder="Your company"
                    autocomplete="organization"
                  />
                </div>
                <div class="form-group">
                  <label for="subject">Subject</label>
                  <select id="subject" v-model="form.subject" required>
                    <option value="" disabled>Select a topic</option>
                    <option value="paas">PaaS Platform</option>
                    <option value="saas">SaaS Solutions</option>
                    <option value="integration">ERP Integration</option>
                    <option value="consulting">Consulting</option>
                    <option value="other">Other</option>
                  </select>
                </div>
              </div>

              <div class="form-group">
                <label for="message">Message</label>
                <textarea
                  id="message"
                  v-model="form.message"
                  placeholder="Tell us about your project or challenge..."
                  rows="5"
                  required
                ></textarea>
              </div>

              <button type="submit" class="btn btn-primary submit-btn">
                Send Message
              </button>
            </form>
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

.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 64px;
  align-items: start;
}

.info-card {
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 32px;
  margin-bottom: 24px;
}

.info-card h3 {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 12px;
}

.info-card p {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.7;
}

.info-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
}

.info-label {
  font-size: 0.8125rem;
  color: var(--color-text-muted);
}

.info-value {
  font-size: 0.875rem;
  font-weight: 600;
}

.contact-form-wrapper {
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 40px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 16px;
}

.form-row .form-group {
  margin-bottom: 0;
}

label {
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--color-text-muted);
}

input,
select,
textarea {
  width: 100%;
  padding: 12px 16px;
  font-size: 0.9375rem;
  font-family: inherit;
  color: var(--color-text);
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  transition: border-color var(--transition);
  outline: none;
}

input::placeholder,
textarea::placeholder {
  color: var(--color-text-dim);
}

input:focus,
select:focus,
textarea:focus {
  border-color: var(--color-accent);
}

select {
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23999' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 16px center;
  padding-right: 40px;
}

select option {
  background: var(--color-bg);
  color: var(--color-text);
}

textarea {
  resize: vertical;
  min-height: 120px;
}

.submit-btn {
  width: 100%;
  margin-top: 8px;
}

.success-message {
  text-align: center;
  padding: 60px 20px;
}

.success-icon {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: rgba(214, 66, 56, 0.15);
  color: var(--color-accent);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0 auto 20px;
}

.success-message h3 {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 8px;
}

.success-message p {
  color: var(--color-text-muted);
}

@media (max-width: 768px) {
  .contact-grid {
    grid-template-columns: 1fr;
    gap: 32px;
  }

  .form-row {
    grid-template-columns: 1fr;
  }
}
</style>

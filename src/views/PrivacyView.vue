<script setup lang="ts">
import { onMounted } from 'vue'

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
  <div class="legal-page">
    <section class="page-hero">
      <div class="container">
        <h1 class="page-hero-title fade-in">Privacy Policy</h1>
        <p class="page-hero-desc fade-in">Last updated: April 2026</p>
      </div>
    </section>

    <section class="section">
      <div class="container">
        <div class="legal-content fade-in">
          <h2>1. Introduction</h2>
          <p>
            Logiforma ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy
            explains how we collect, use, disclose, and safeguard your information when you visit our
            website or use our platform services. We comply with the General Data Protection Regulation
            (GDPR) and India's Digital Personal Data Protection Act (DPDP).
          </p>

          <h2>2. Information We Collect</h2>
          <h3>Personal Information</h3>
          <p>When you interact with our services, we may collect:</p>
          <ul>
            <li>Name and contact details (email address, phone number)</li>
            <li>Company name and job title</li>
            <li>Billing and payment information</li>
            <li>Account credentials</li>
            <li>Communication records (support tickets, emails)</li>
          </ul>

          <h3>Automatically Collected Information</h3>
          <p>We automatically collect certain information when you access our platform:</p>
          <ul>
            <li>IP address and device identifiers</li>
            <li>Browser type and operating system</li>
            <li>Pages visited and time spent</li>
            <li>Referring website addresses</li>
            <li>Usage patterns and feature interactions</li>
          </ul>

          <h2>3. How We Use Your Information</h2>
          <p>We use the collected information for the following purposes:</p>
          <ul>
            <li>Providing, operating, and maintaining our platform and services</li>
            <li>Processing transactions and managing subscriptions</li>
            <li>Communicating with you about service updates, support, and promotional materials</li>
            <li>Improving our platform through analytics and usage data</li>
            <li>Complying with legal obligations and regulatory requirements</li>
            <li>Detecting and preventing fraud or security incidents</li>
          </ul>

          <h2>4. Data Sharing & Disclosure</h2>
          <p>We do not sell your personal data. We may share information with:</p>
          <ul>
            <li><strong>Service providers:</strong> Third parties that assist in operating our platform (hosting, analytics, payment processing)</li>
            <li><strong>Legal obligations:</strong> When required by law, court order, or government request</li>
            <li><strong>Business transfers:</strong> In connection with a merger, acquisition, or sale of assets</li>
            <li><strong>With your consent:</strong> When you explicitly authorize sharing</li>
          </ul>

          <h2>5. Data Security</h2>
          <p>
            We implement industry-standard security measures to protect your data, including encryption
            at rest and in transit, regular security audits, access controls, and penetration testing.
            However, no method of electronic transmission or storage is completely secure.
          </p>

          <h2>6. Data Retention</h2>
          <p>
            We retain your personal data only as long as necessary to fulfill the purposes outlined in
            this policy, comply with legal obligations, resolve disputes, and enforce our agreements.
            When data is no longer needed, it is securely deleted or anonymized.
          </p>

          <h2>7. Your Rights</h2>
          <p>Depending on your jurisdiction, you may have the following rights:</p>
          <ul>
            <li>Access, correct, or delete your personal data</li>
            <li>Object to or restrict processing of your data</li>
            <li>Data portability — receive your data in a structured format</li>
            <li>Withdraw consent at any time</li>
            <li>Lodge a complaint with a supervisory authority</li>
          </ul>

          <h2>8. Cookies</h2>
          <p>
            Our website uses essential cookies to ensure proper functionality. We may also use
            analytics cookies to understand usage patterns. You can manage cookie preferences
            through your browser settings.
          </p>

          <h2>9. International Data Transfers</h2>
          <p>
            Your data may be processed in jurisdictions outside your country of residence. We ensure
            appropriate safeguards are in place, including standard contractual clauses, to protect
            your data in accordance with applicable laws.
          </p>

          <h2>10. Changes to This Policy</h2>
          <p>
            We may update this Privacy Policy from time to time. We will notify you of any material
            changes by posting the updated policy on our website with a revised "Last updated" date.
          </p>

          <h2>11. Contact Us</h2>
          <p>
            If you have questions about this Privacy Policy or wish to exercise your rights, contact us at:
          </p>
          <address>
            Logiforma<br />
            WeWork - Manyata Redwood,<br />
            9th Floor, Block D3, Manyata Tech Park,<br />
            Bangalore - 560064, Karnataka, India
          </address>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.page-hero {
  padding: 160px 0 60px;
  border-bottom: 1px solid var(--color-border);
}

.page-hero-title {
  font-size: clamp(2.5rem, 5vw, 3.5rem);
  font-weight: 800;
  line-height: 1.15;
  letter-spacing: -0.02em;
  margin-bottom: 12px;
}

.page-hero-desc {
  font-size: 1rem;
  color: var(--color-text-muted);
}

.legal-content {
  max-width: 720px;
}

.legal-content h2 {
  font-size: 1.375rem;
  font-weight: 700;
  margin-top: 48px;
  margin-bottom: 16px;
}

.legal-content h2:first-child {
  margin-top: 0;
}

.legal-content h3 {
  font-size: 1.0625rem;
  font-weight: 600;
  margin-top: 24px;
  margin-bottom: 12px;
}

.legal-content p {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.8;
  margin-bottom: 16px;
}

.legal-content ul {
  list-style: none;
  padding: 0;
  margin-bottom: 16px;
}

.legal-content ul li {
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.8;
  padding-left: 20px;
  position: relative;
}

.legal-content ul li::before {
  content: '•';
  position: absolute;
  left: 0;
  color: var(--color-accent);
}

.legal-content address {
  font-style: normal;
  font-size: 0.9375rem;
  color: var(--color-text-muted);
  line-height: 1.8;
  padding: 20px 24px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  margin-top: 8px;
}
</style>

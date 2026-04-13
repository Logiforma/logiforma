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
        <h1 class="page-hero-title fade-in">Terms of Service</h1>
        <p class="page-hero-desc fade-in">Last updated: April 2026</p>
      </div>
    </section>

    <section class="section">
      <div class="container">
        <div class="legal-content fade-in">
          <h2>1. Acceptance of Terms</h2>
          <p>
            By accessing or using Logiforma's website, platform, or services ("Services"), you agree
            to be bound by these Terms of Service ("Terms"). If you are using the Services on behalf
            of an organization, you represent that you have authority to bind that organization to
            these Terms.
          </p>

          <h2>2. Description of Services</h2>
          <p>
            Logiforma provides a Platform-as-a-Service (PaaS) and Software-as-a-Service (SaaS)
            platform designed for enterprise ERP ecosystem transformation, including custom digital
            solutions, ERP & CRM integrations, data pipelines, analytics, marketplace management,
            and related services.
          </p>

          <h2>3. Account Registration</h2>
          <p>
            To access certain features, you may be required to create an account. You agree to
            provide accurate, complete information and to keep your account credentials confidential.
            You are responsible for all activities that occur under your account.
          </p>

          <h2>4. Use of Services</h2>
          <p>You agree to use the Services only for lawful purposes and in accordance with these Terms. You shall not:</p>
          <ul>
            <li>Use the Services in violation of any applicable laws or regulations</li>
            <li>Attempt to gain unauthorized access to any part of the Services or related systems</li>
            <li>Transmit any malware, viruses, or harmful code</li>
            <li>Interfere with or disrupt the integrity or performance of the Services</li>
            <li>Reverse engineer, decompile, or disassemble any aspect of the Services</li>
            <li>Use the Services to develop a competing product or service</li>
          </ul>

          <h2>5. Intellectual Property</h2>
          <p>
            All content, features, and functionality of the Services — including software, text,
            graphics, logos, and trademarks — are owned by Logiforma or its licensors and are
            protected by intellectual property laws. You are granted a limited, non-exclusive,
            non-transferable license to use the Services as permitted under these Terms.
          </p>

          <h2>6. Data Ownership</h2>
          <p>
            You retain all rights to the data you upload or process through our platform ("Your Data").
            You grant Logiforma a limited license to use Your Data solely for the purpose of providing
            and improving the Services. We do not sell or share Your Data with third parties except
            as described in our Privacy Policy.
          </p>

          <h2>7. Service Level & Availability</h2>
          <p>
            Logiforma strives to maintain high availability of the Services. Specific uptime
            commitments and support terms may be outlined in a separate Service Level Agreement
            (SLA) for enterprise customers. Scheduled maintenance will be communicated in advance.
          </p>

          <h2>8. Payment & Billing</h2>
          <p>
            Fees for the Services are determined based on your specific engagement scope and are
            outlined in your service agreement. All fees are exclusive of applicable taxes unless
            stated otherwise. Late payments may incur interest charges as specified in your agreement.
          </p>

          <h2>9. Confidentiality</h2>
          <p>
            Both parties agree to maintain the confidentiality of any proprietary or confidential
            information disclosed during the course of the engagement. This obligation survives
            termination of these Terms.
          </p>

          <h2>10. Limitation of Liability</h2>
          <p>
            To the maximum extent permitted by law, Logiforma shall not be liable for any indirect,
            incidental, special, consequential, or punitive damages, including but not limited to
            loss of profits, data, or business opportunities, arising out of or related to your
            use of the Services.
          </p>

          <h2>11. Indemnification</h2>
          <p>
            You agree to indemnify and hold Logiforma harmless from any claims, damages, or expenses
            arising from your use of the Services, your violation of these Terms, or your infringement
            of any third-party rights.
          </p>

          <h2>12. Termination</h2>
          <p>
            Either party may terminate the service engagement as specified in the applicable service
            agreement. Upon termination, Logiforma will provide reasonable assistance in migrating
            your data. Access to the Services will cease upon termination.
          </p>

          <h2>13. Governing Law</h2>
          <p>
            These Terms shall be governed by and construed in accordance with the laws of India.
            Any disputes arising under these Terms shall be subject to the exclusive jurisdiction
            of the courts in Bangalore, Karnataka, India.
          </p>

          <h2>14. Changes to Terms</h2>
          <p>
            We reserve the right to modify these Terms at any time. We will provide notice of
            material changes via email or through the platform. Continued use of the Services
            after changes constitute acceptance of the modified Terms.
          </p>

          <h2>15. Contact</h2>
          <p>
            For questions regarding these Terms of Service, please contact us at:
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

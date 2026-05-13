<script setup lang="ts">
import { RouterLink } from 'vue-router'

const currentYear = new Date().getFullYear()

const links = {
  platform: [
    { name: 'Custom Digital Solutions', path: '/services' },
    { name: 'ERP & CRM Integration', path: '/services' },
    { name: 'Data Pipelines', path: '/services' },
    { name: 'Analytics & Reporting', path: '/services' },
  ],
  company: [
    { name: 'About Us', path: '/about' },
    { name: 'Pricing', path: '/pricing' },
    { name: 'Contact', path: '/contact' },
    { name: 'Privacy Policy', path: '/privacy' },
    { name: 'Terms of Service', path: '/terms' },
  ],
  industries: [
    { name: 'Fashion & Retail' },
    { name: 'HVAC' },
    { name: 'EdTech' },
  ],
}
</script>

<template>
  <footer class="footer">
    <div class="container">
      <!-- Top: Logo + Tagline + Address -->
      <div class="footer-top">
        <div class="footer-brand">
          <img src="/logo-transparent/Logo%20-%20Dark.png" alt="Logiforma" class="footer-logo" />
          <p class="footer-desc">
            The digital backbone for enterprise operations. Transforming ERP ecosystems through
            intelligent automation and seamless integrations.
          </p>
        </div>
        <div class="footer-address">
          <p class="address-label">Registered Office</p>
          <address>
            WeWork - Manyata Redwood,<br />
            9th Floor, Block D3, Manyata Tech Park,<br />
            Bangalore - 560045, Karnataka, India
          </address>
        </div>
      </div>

      <!-- Links row -->
      <div class="footer-links-row">
        <div class="footer-col">
          <h4 class="footer-heading">Platform</h4>
          <ul>
            <li v-for="link in links.platform" :key="link.name">
              <RouterLink :to="link.path" class="footer-link">{{ link.name }}</RouterLink>
            </li>
          </ul>
        </div>

        <div class="footer-col">
          <h4 class="footer-heading">Company</h4>
          <ul>
            <li v-for="link in links.company" :key="link.name">
              <RouterLink :to="link.path" class="footer-link">{{ link.name }}</RouterLink>
            </li>
          </ul>
        </div>

        <div class="footer-col">
          <h4 class="footer-heading">Industries</h4>
          <ul>
            <li v-for="item in links.industries" :key="item.name">
              <span class="footer-link">{{ item.name }}</span>
            </li>
          </ul>
        </div>
      </div>

      <div class="footer-bottom">
        <p>&copy; {{ currentYear }} Logiforma. All rights reserved.</p>
        <div class="footer-bottom-links">
          <RouterLink to="/privacy" class="footer-bottom-link">Privacy Policy</RouterLink>
          <RouterLink to="/terms" class="footer-bottom-link">Terms of Service</RouterLink>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  padding: 80px 0 40px;
  background: rgba(8, 8, 10, 0.7);
  backdrop-filter: blur(20px) saturate(140%);
  -webkit-backdrop-filter: blur(20px) saturate(140%);
  position: relative;
  z-index: 1;
}

/* Top section: brand + address side by side */
.footer-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 48px;
  padding-bottom: 48px;
  margin-bottom: 48px;
  border-bottom: 1px solid var(--color-border);
}

.footer-brand {
  display: flex;
  align-items: flex-start;
  gap: 32px;
}

.footer-logo {
  height: 120px;
  width: auto;
  flex-shrink: 0;
}

.footer-desc {
  font-size: 0.875rem;
  color: var(--color-text-muted);
  line-height: 1.7;
  max-width: 320px;
  padding-top: 12px;
}

.footer-address {
  text-align: right;
  flex-shrink: 0;
}

.address-label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--color-text-dim);
  margin-bottom: 8px;
}

address {
  font-style: normal;
  font-size: 0.8125rem;
  color: var(--color-text-muted);
  line-height: 1.7;
}

/* Links row */
.footer-links-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 48px;
  margin-bottom: 48px;
}

.footer-heading {
  font-size: 0.8125rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--color-text);
  margin-bottom: 20px;
}

.footer-col ul {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.footer-link {
  font-size: 0.875rem;
  color: var(--color-text-muted);
  transition: color var(--transition);
}

a.footer-link:hover {
  color: var(--color-text);
}

.footer-bottom-link {
  color: var(--color-text-dim);
  transition: color var(--transition);
}

.footer-bottom-link:hover {
  color: var(--color-text);
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 32px;
  border-top: 1px solid var(--color-border);
  font-size: 0.8125rem;
  color: var(--color-text-dim);
}

.footer-bottom-links {
  display: flex;
  gap: 24px;
}

@media (max-width: 768px) {
  .footer-top {
    flex-direction: column;
    gap: 32px;
  }

  .footer-brand {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
  }

  .footer-address {
    text-align: left;
  }

  .footer-links-row {
    grid-template-columns: 1fr 1fr;
    gap: 32px;
  }

  .footer-bottom {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }
}

@media (max-width: 480px) {
  .footer-links-row {
    grid-template-columns: 1fr;
  }
}
</style>

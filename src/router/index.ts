import { createRouter, createWebHistory } from 'vue-router'

const SITE = 'https://logiforma.com'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/views/HomeView.vue'),
      meta: {
        title: 'Logiforma — Digital Backbone for Enterprise Operations',
        description:
          'Transform your enterprise ERP ecosystem with intelligent automation, seamless integrations and data-driven insights. PaaS & SaaS solutions.',
      },
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('@/views/AboutView.vue'),
      meta: {
        title: 'About Logiforma — Our Story, Vision & Mission',
        description:
          'Learn how Logiforma is redefining enterprise ERP operations through innovation, customer-centricity and scalable digital solutions.',
      },
    },
    {
      path: '/services',
      name: 'services',
      component: () => import('@/views/ServicesView.vue'),
      meta: {
        title: 'Services — PaaS & SaaS Enterprise Solutions | Logiforma',
        description:
          'Custom digital solutions, ERP & CRM integration, marketplace management, data pipelines, analytics and mobile applications for enterprise operations.',
      },
    },
    {
      path: '/pricing',
      name: 'pricing',
      component: () => import('@/views/PricingView.vue'),
      meta: {
        title: 'Pricing — Enterprise Solutions Tailored to Your Scale | Logiforma',
        description:
          'Enterprise-grade PaaS & SaaS platform with custom scoping, dedicated infrastructure, and guaranteed SLA. Get a tailored proposal.',
      },
    },
    {
      path: '/contact',
      name: 'contact',
      component: () => import('@/views/ContactView.vue'),
      meta: {
        title: 'Contact Us — Get a Free Assessment | Logiforma',
        description:
          'Reach out for a free initial assessment. We respond within 24 hours. GDPR & DPDP compliant enterprise solutions.',
      },
    },
    {
      path: '/privacy',
      name: 'privacy',
      component: () => import('@/views/PrivacyView.vue'),
      meta: {
        title: 'Privacy Policy | Logiforma',
        description:
          'Logiforma privacy policy. GDPR and DPDP compliant data protection practices for enterprise platform users.',
      },
    },
    {
      path: '/terms',
      name: 'terms',
      component: () => import('@/views/TermsView.vue'),
      meta: {
        title: 'Terms of Service | Logiforma',
        description:
          'Terms of service governing the use of Logiforma PaaS and SaaS enterprise platform.',
      },
    },
  ],
  scrollBehavior(_to, _from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    }
    return { top: 0 }
  },
})

router.beforeEach((to) => {
  const title = (to.meta.title as string) || 'Logiforma — Digital Backbone for Enterprise Operations'
  const description =
    (to.meta.description as string) ||
    'Transform your enterprise ERP ecosystem with intelligent automation, seamless integrations and data-driven insights.'

  document.title = title

  const setMeta = (attr: string, key: string, value: string) => {
    let el = document.querySelector(`meta[${attr}="${key}"]`) as HTMLMetaElement | null
    if (!el) {
      el = document.createElement('meta')
      el.setAttribute(attr, key)
      document.head.appendChild(el)
    }
    el.setAttribute('content', value)
  }

  setMeta('name', 'description', description)
  setMeta('property', 'og:title', title)
  setMeta('property', 'og:description', description)
  setMeta('property', 'og:url', `${SITE}${to.path}`)
  setMeta('name', 'twitter:title', title)
  setMeta('name', 'twitter:description', description)

  let canonical = document.querySelector('link[rel="canonical"]') as HTMLLinkElement | null
  if (!canonical) {
    canonical = document.createElement('link')
    canonical.setAttribute('rel', 'canonical')
    document.head.appendChild(canonical)
  }
  canonical.setAttribute('href', `${SITE}${to.path}`)
})

export default router

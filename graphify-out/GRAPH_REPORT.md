# Graph Report - .  (2026-05-14)

## Corpus Check
- Large corpus: 47 files · ~654,881 words. Semantic extraction will be expensive (many Claude tokens). Consider running on a subfolder, or use --no-semantic to run AST-only.

## Summary
- 111 nodes · 120 edges · 25 communities (17 shown, 8 thin omitted)
- Extraction: 82% EXTRACTED · 18% INFERRED · 0% AMBIGUOUS · INFERRED: 21 edges (avg confidence: 0.5)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 24|Community 24]]

## God Nodes (most connected - your core abstractions)
1. `tick()` - 5 edges
2. `lerp()` - 4 edges
3. `smoothstep()` - 4 edges
4. `lerp3()` - 4 edges
5. `lerp3Color()` - 4 edges
6. `initScene()` - 3 edges
7. `computeScrollProgress()` - 2 edges
8. `buildStarfield()` - 2 edges
9. `buildEnvironment()` - 2 edges
10. `onScroll()` - 2 edges

## Surprising Connections (you probably didn't know these)
- `Transforming Noise to Vision` --describes_value_proposition_of--> `Logiforma`  [INFERRED]
   →   _Bridges community 1 → community 3_
- `main.ts` --installs router from--> `router/index.ts`  [EXTRACTED]
   →   _Bridges community 2 → community 4_
- `main.ts` --creates Vue app using--> `Vue 3`  [EXTRACTED]
   →   _Bridges community 4 → community 7_
- `Favicon Collection` --belongs_to--> `Logiforma`  [EXTRACTED]
   →   _Bridges community 1 → community 6_

## Hyperedges (group relationships)
- **layout_system** —  [INFERRED]
- **view_routes** —  [INFERRED]
- **build_config** —  [INFERRED]
- **animation_system** —  [INFERRED]
- **company_content** —  [INFERRED]
- **Complete Branding System** —  [INFERRED]
- **Website Design Screens** —  [INFERRED]

## Communities (25 total, 8 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.0
Nodes (16): BG_A, BG_B, BG_C, buildEnvironment(), buildStarfield(), computeScrollProgress(), initScene(), lerp() (+8 more)

### Community 1 - "Community 1"
Cohesion: 0.0
Nodes (14): final.svg (Logo), Icon - Dark.png (Opaque), Icon - Light.png (Opaque), Icon - Dark.png (Transparent), Icon - Light.png (Transparent), initial.svg (Logo Variant), Logiforma, Logo Opaque Collection (+6 more)

### Community 2 - "Community 2"
Cohesion: 0.0
Nodes (13): AboutView.vue, company.txt, ContactView.vue, generate-sitemap.ts, HeroAnimation.vue, HomeView.vue, iconPositions.ts, Logiforma (+5 more)

### Community 3 - "Community 3"
Cohesion: 0.0
Nodes (11): Effortless (Approach), Global (Approach), Research-based (Approach), Navigation Items (Platform, Solutions, About, Contact), robots.txt, Screen 1 Design (Hero Page), Screen 2 Design (Platform Page), Screen 3 Design (+3 more)

### Community 4 - "Community 4"
Cohesion: 0.0
Nodes (10): App.vue, counter.ts, FooterSection.vue, index.html, main.ts, MorphingBackground.vue, NavBar.vue, Pinia (+2 more)

### Community 5 - "Community 5"
Cohesion: 0.0
Nodes (3): canonical, router, app

### Community 6 - "Community 6"
Cohesion: 0.0
Nodes (6): android-chrome-192x192.png, android-chrome-512x512.png, apple-touch-icon.png, favicon-16x16.png, favicon-32x32.png, Favicon Collection

### Community 7 - "Community 7"
Cohesion: 0.0
Nodes (5): env.d.ts, eslint.config.ts, README.md, vite.config.ts, Vue 3

## Knowledge Gaps
- **17 isolated node(s):** `__dirname`, `pages`, `app`, `useCounterStore`, `BG_A` (+12 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.
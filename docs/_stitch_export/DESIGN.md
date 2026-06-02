---
name: Midnight Matcha
colors:
  surface: '#f4fafd'
  surface-dim: '#d4dbdd'
  surface-bright: '#f4fafd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eef5f7'
  surface-container: '#e8eff1'
  surface-container-high: '#e2e9ec'
  surface-container-highest: '#dde4e6'
  on-surface: '#161d1f'
  on-surface-variant: '#414844'
  inverse-surface: '#2b3234'
  inverse-on-surface: '#ebf2f4'
  outline: '#717973'
  outline-variant: '#c1c8c2'
  surface-tint: '#3f6653'
  primary: '#012d1d'
  on-primary: '#ffffff'
  primary-container: '#1b4332'
  on-primary-container: '#86af99'
  inverse-primary: '#a5d0b9'
  secondary: '#4b6454'
  on-secondary: '#ffffff'
  secondary-container: '#cbe7d2'
  on-secondary-container: '#4f6858'
  tertiary: '#1f2825'
  on-tertiary: '#ffffff'
  tertiary-container: '#353e3a'
  on-tertiary-container: '#9fa9a3'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c1ecd4'
  primary-fixed-dim: '#a5d0b9'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#274e3d'
  secondary-fixed: '#cde9d5'
  secondary-fixed-dim: '#b2cdb9'
  on-secondary-fixed: '#082013'
  on-secondary-fixed-variant: '#344c3d'
  tertiary-fixed: '#dbe5df'
  tertiary-fixed-dim: '#bfc9c3'
  on-tertiary-fixed: '#151d1a'
  on-tertiary-fixed-variant: '#3f4945'
  background: '#f4fafd'
  on-background: '#161d1f'
  surface-variant: '#dde4e6'
typography:
  headline-xl:
    fontFamily: Be Vietnam Pro
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Be Vietnam Pro
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Be Vietnam Pro
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style

The design system is built upon an ethos of **Organic Minimalism**. It targets an audience that values serenity, intentionality, and high-end utility. By combining the approachable geometry of contemporary sans-serif typography with a palette inspired by botanical depths and soft morning light, the UI evokes a sense of calm authority.

The visual style is a blend of **Corporate Modern** and **Tactile Softness**. It avoids the sterility of pure white interfaces by using tinted neutrals, ensuring the experience feels premium and "lived-in." The emotional response should be one of quiet confidence—where the interface recedes to let the content breathe, yet feels physically substantial when interacted with.

## Colors

The "Midnight Matcha" palette is rooted in high-contrast organic tones. 

- **Primary (#1B4332):** A deep, forest-inspired green used for core branding, primary actions, and heavy-weighted headings.
- **Secondary (#748E7C):** A muted sage that acts as a bridge between the dark primary and light backgrounds, ideal for secondary buttons and accents.
- **Background (#F0F4F1):** A soft, desaturated sage-white that reduces eye strain and provides a premium, paper-like foundation.
- **Neutral (#2D3436):** A deep charcoal for body text and icons, ensuring maximum legibility without the harshness of pure black.

Use subtle tints of the primary green (5-10% opacity) for hover states on light surfaces to maintain the monochromatic harmony.

## Typography

This design system utilizes **Be Vietnam Pro** across all levels to maintain a friendly yet professional appearance. The typeface's contemporary curves complement the "large roundness" of the UI elements.

- **Headlines:** Use tight letter-spacing and heavy weights (600-700) in the Primary color to anchor the page.
- **Body Text:** Set in Charcoal with generous line heights (1.5x minimum) to enhance readability and the feeling of "calm."
- **Labels:** Use Medium or Semi-Bold weights with slight tracking (letter-spacing) for micro-copy and navigation items to ensure clarity at small scales.

## Layout & Spacing

The layout follows a **Fluid Grid** philosophy with significant emphasis on "white space" (or in this case, "sage space"). 

- **Grid:** Use a 12-column grid for desktop and a 4-column grid for mobile.
- **Rhythm:** An 8px base unit governs all dimensions.
- **Desktop:** Margins are expansive (64px) to push content toward the center, creating a focused, editorial feel.
- **Mobile:** Margins shrink to 16px, but vertical spacing between sections remains generous (48px+) to prevent the interface from feeling cramped.
- **Gutters:** Standardized at 24px to ensure distinct separation of content blocks.

## Elevation & Depth

Depth is conveyed through **Tonal Layers** rather than heavy shadows. This maintains the organic, flat-premium aesthetic.

- **Surface Levels:** The base background is the Soft Sage (#F0F4F1). Elevated cards or containers should use pure white (#FFFFFF) to pop forward, or a slightly darker tint of sage to recede.
- **Shadows:** When necessary for functional depth (e.g., floating action buttons or dropdowns), use "Ambient Shadows." These are ultra-diffused, using the Primary color at a very low opacity (5-8%) instead of pure black, creating a soft, glow-like lift that feels integrated into the environment.
- **Outlines:** Use subtle, 1px borders in a Tertiary sage tone for low-elevation containers to provide structure without adding visual weight.

## Shapes

The design system adopts a **Pill-shaped** (Level 3) visual language. This extreme roundedness is the primary driver of the "approachable" and "organic" feel.

- **Small Components:** Buttons, tags, and input fields should utilize full pill-style capping (corners maxed out).
- **Containers:** Large cards and modals should use a radius of 2rem to 3rem, ensuring they feel like smooth stones rather than boxes.
- **Consistency:** Never mix sharp corners with rounded ones; even "inner" elements within a card must respect the rounded hierarchy to maintain the fluid visual flow.

## Components

- **Buttons:** Primary buttons are pill-shaped, filled with Midnight Matcha (#1B4332), and use white text. Secondary buttons use an outline or a soft sage fill.
- **Inputs:** Text fields feature a soft-tinted background and a 1px border. On focus, the border thickens or shifts to the Primary green, with a soft ambient glow.
- **Cards:** Cards should be treated as "vessels"—generous internal padding (32px), large corner radii (rounded-xl), and subtle shadows to separate them from the background.
- **Chips/Tags:** Small, pill-shaped elements with Medium-weight labels. Use these for categorization, utilizing secondary green tints for the background.
- **Lists:** Use ample vertical padding between list items. Separate items with a subtle 1px divider in a Tertiary green tint, stopping short of the container edges to maintain a floating feel.
- **Progress Indicators:** Use the Primary green against a Tertiary green track to maintain the monochromatic, organic theme.
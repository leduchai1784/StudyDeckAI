---
name: StudyDeck Intelligence System
colors:
  surface: '#fcf8ff'
  surface-dim: '#dad6ff'
  surface-bright: '#fcf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f2ff'
  surface-container: '#efebff'
  surface-container-high: '#e9e5ff'
  surface-container-highest: '#e3dfff'
  on-surface: '#181445'
  on-surface-variant: '#464555'
  inverse-surface: '#2d2a5b'
  inverse-on-surface: '#f3eeff'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4d44e3'
  primary: '#3525cd'
  on-primary: '#ffffff'
  primary-container: '#4f46e5'
  on-primary-container: '#dad7ff'
  inverse-primary: '#c3c0ff'
  secondary: '#525d83'
  on-secondary: '#ffffff'
  secondary-container: '#c8d3ff'
  on-secondary-container: '#4f5a80'
  tertiary: '#684000'
  on-tertiary: '#ffffff'
  tertiary-container: '#885500'
  on-tertiary-container: '#ffd4a4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#3323cc'
  secondary-fixed: '#dbe1ff'
  secondary-fixed-dim: '#bac5f0'
  on-secondary-fixed: '#0d1a3c'
  on-secondary-fixed-variant: '#3a456a'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#fcf8ff'
  on-background: '#181445'
  surface-variant: '#e3dfff'
typography:
  display-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
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
    fontWeight: '700'
    lineHeight: 32px
  title-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
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
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
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
  margin-desktop: 40px
---

## Brand & Style

This design system is built to balance academic rigor with the frictionless experience of modern AI. The brand personality is **Encouraging, Methodical, and Intelligent**. It aims to evoke a sense of focused calm and reliable progress for students, while maintaining a structured, data-driven professional environment for administrators.

The visual style is **Modern Corporate with Tactile accents**. It leverages a "Deck" metaphor—using layered surfaces and significant roundedness to mimic physical flashcards—while maintaining high-contrast clarity. The "AI Sparkle" motif is used sparingly as a functional signifier of machine-augmented intelligence rather than a decorative element.

- **Minimalism:** High use of whitespace to prevent cognitive overload during study sessions.
- **Modern Professional:** Systematic grid alignment and clear hierarchy for the admin dashboard.
- **Friendly Geometry:** Large radii and soft colors to reduce the anxiety often associated with testing and learning.

## Colors

The palette is anchored by **Indigo**, representing the intersection of traditional academic "Navy" and modern digital "Violet." 

- **Primary (Indigo):** Used for primary brand moments, active states, and navigation headers.
- **Secondary (Pale Indigo):** Primarily used for surface-level containers (cards), hover states, and subtle background segmentation.
- **Accent (Amber):** Reserved strictly for high-impact actions (CTA), achievement streaks, and "AI-generated" badges. It provides a warm contrast to the cooler indigo tones.
- **Functional:** Success Green and Error Red follow standard semantic patterns but are slightly desaturated to maintain the professional aesthetic.
- **Neutral:** A deep Navy (#1E1B4B) replaces pure black for text to ensure high legibility without harshness. The background is a clean, cool gray to provide maximum contrast for white cards.

## Typography

The design system utilizes **Be Vietnam Pro** for its contemporary feel and exceptional legibility in both English and Vietnamese. 

- **Weight Strategy:** Use **Bold (700)** for all headlines and display text to establish a strong hierarchical anchor. **SemiBold (600)** is reserved for interactive labels (buttons, chips) and section titles. **Regular (400)** is used for all body copy to ensure a comfortable reading experience during long study sessions.
- **Scale:** High contrast between headline and body sizes is encouraged to facilitate quick scanning of educational content.
- **Alignment:** Headlines should generally be left-aligned in admin dashboards but can be center-aligned for mobile "Flashcard" states.

## Layout & Spacing

This design system follows a **flexible grid model** with a base 8px rhythmic unit.

- **Web Admin Dashboard:** Employs a 12-column fluid grid. The sidebar is fixed at 280px. Content is contained within a max-width of 1440px to prevent excessive line lengths. Gutters are fixed at 24px to maintain professional breathing room.
- **Mobile App:** Utilizes a single-column layout with 16px side margins. Flashcard components should have dynamic vertical padding (24px-32px) to focus the eye on the central content.
- **Deck Metaphor:** When stacking cards, use a -8px or -12px negative margin offset to create the visual effect of a physical deck as seen in the brand mark.

## Elevation & Depth

Visual hierarchy is achieved through a combination of **Tonal Layering** and **Soft Ambient Shadows**.

1.  **Level 0 (Background):** #F9FAFB. The canvas.
2.  **Level 1 (Cards/Containers):** White (#FFFFFF). These use a soft, 15% opacity shadow with a large blur (20px) and a subtle 4px vertical offset. This creates the "float" necessary for the deck metaphor.
3.  **Level 2 (Active/Hover):** When a card is hovered or active, the shadow intensity increases to 25% opacity, and the Y-offset moves to 8px, simulating a lift toward the user.
4.  **Admin Surfaces:** Use Low-contrast outlines (1px solid #E5E7EB) instead of shadows for data tables and secondary panels to maintain a clean, professional "utility" feel.

## Shapes

The shape language is defined by **pronounced, friendly curves** that mirror the card-deck logo.

- **Base Components:** Buttons and Input fields use `rounded-md` (8px / 0.5rem).
- **Core Card Elements:** Main study cards and dashboard containers use `rounded-xl` (24px / 1.5rem) to emphasize the "Deck" identity.
- **Interactive Signifiers:** AI Badges and Chips use `pill` (999px) shapes to distinguish them from structural content.

## Components

### Buttons
- **Primary:** Solid Indigo (#4F46E5) with White text. Bold weight.
- **CTA/Special:** Solid Amber (#F59E0B) with Navy text. Used for "Start Quiz" or "Upgrade."
- **Secondary:** Outline Indigo with a light Indigo background tint on hover.

### Study Cards
- These are the hero components. They must feature `rounded-xl` corners and the Level 1 shadow. 
- **AI-Enhanced State:** Features a subtle 1px Amber border and a small sparkle icon in the top right corner.

### Inputs & Selects
- Use a light gray border (#D1D5DB) that shifts to Primary Indigo on focus. 
- Labels must always be visible above the input field in Navy (#1E1B4B).

### Chips & Badges
- **AI Badge:** Amber background with Navy text, pill-shaped.
- **Tag:** Light Indigo (#C7D2FE) background with Primary Indigo text.

### Progress Indicators
- Linear progress bars use a secondary indigo track with a primary indigo fill. 
- Streak indicators use Amber with a flame or sparkle icon.

### Admin Tables
- High-density layout. Row borders are #F3F4F6. Use `label-md` for headers to ensure clarity.
# 11 — Visual Language

Reference: `docs/_stitch_export/` screenshots and `DESIGN.md`.

This file is the pattern library and single source of truth for how Ngày Lương components look and behave. Use it together with `docs/06_DESIGN_SYSTEM.md`: `06` defines design tokens; this file defines component patterns, layout behavior, motion, and anti-patterns.

## Global visual tokens for Midnight Matcha

- **Base background:** `bg` / `background` = `#F4FAFD`; never default to pure Material gray or stark white as the screen base.
- **Primary:** `primary` = `#2F4A3F`; `primaryContainer` = `#DDEDE4`; `onPrimary` = `#F8FFFB`; `onPrimaryContainer` = `#163026`.
- **Secondary container:** `secondaryContainer` = `#E8F1EC`; `onSecondaryContainer` = `#29443A`; use for chips, placeholders, and decorative blobs.
- **Surface stack:** `surface` = `#FDFEFE`; `surfaceContainerLowest` = `#FFFFFF` only for card pop; `surfaceContainerLow` = `#EEF6F2`; `surfaceContainerHigh` = `#E4EEE9`.
- **Text:** `onSurface` = `#161D1F`; `onSurfaceVariant` = `#5F6F68`. Do not use pure black.
- **Shape:** round by default. Use `rounded-full` for chips/buttons/FAB; `rounded-xl` to `rounded-2xl` for bento/card containers. No sharp Material rectangles.
- **Typography:** Be Vietnam Pro via `GoogleFonts.beVietnamPro(...)`; hero number uses 64sp / w800 unless screen density requires 56-72sp.
- **Icons:** Material Symbols Outlined via `package:material_symbols_icons/symbols.dart`; new UI should prefer `Symbols.*` over `Icons.*`. Use `fill: 1` only for active/selected states.
- **Shadow:** `organicShadow = #0F161D1F` and `organicShadowPrimaryTint = #142F4A3F`; use soft sage/primary-tinted shadows, never default Material 3 elevation as-is.

---

## 1. Photography direction

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png`, `docs/_stitch_export/screenshots/wishlist_screen.png`, and `docs/_stitch_export/DESIGN.md`.

- **Brief:** product photography should feel calm, tactile, private, and editorial — like a quiet product still life on a desk, not like an e-commerce catalog cutout.
- **Lighting:** soft diffused window light, low contrast, gentle shadow falloff, no harsh flash, no glossy specular glare.
- **Undertones:** matcha/sage green, warm cream, oatmeal, stone, muted clay; avoid bank-blue, warning red, neon sale colors, or cold fintech gradients.
- **Surfaces:** matte ceramic, linen, paper, wood, soft acrylic, fabric, or warm stone; keep props minimal so the product remains the focal point.
- **Mood:** slow, thoughtful, slightly dreamy; the image should support the pause-before-buy loop rather than trigger urgency.
- **Crop:** mobile-first square or 4:5 source image; UI will crop into circle or `h-64` article image depending on component.
- **Prompt template from Stitch alt-text:** “A softly lit editorial product photograph of [product] on a warm off-white surface with sage/matcha undertones, subtle organic shadows, minimal props, calm private mood, Vietnamese lifestyle app aesthetic, no sale stickers, no harsh contrast.” Use this as the base prompt for future AI-generated product images.

---

## 2. Top App Bar

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png`.

- **Layout:** horizontal `avatar | wordmark | settings`.
  - Avatar: 36-40px circle, left aligned; use a soft sage placeholder/initial if no user image exists.
  - Wordmark: centered visually, Be Vietnam Pro 18-20sp / w700, `onSurface`.
  - Settings: 40px circular tap target on the right using `Symbols.settings`; icon color `onSurfaceVariant`.
- **Height:** 72px content height plus safe-area top inset.
- **Padding:** 20px horizontal screen padding; 8-12px vertical internal padding.
- **Backdrop:** `surface/90` with `backdrop-blur-xl` to `backdrop-blur-2xl`; 1px bottom border `outlineVariant/30` only if content scrolls underneath.
- **Sticky behavior:** sticky at top on scroll; do not collapse into a Material small/medium/large app bar.
- **Hover/pressed states:** icon/avatar circles get `surfaceContainerHigh` fill; transition 200ms ease-out; no ripple-heavy Material default.
- **Privacy:** do not show income, item price, or days-of-wage in the app bar.

---

## 3. Hero Product Image

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png`.

- **Image shape:** full circle, 256-320px diameter depending on viewport; center aligned above the hero number block.
- **Decorative layer:** behind the image, place a `bg-secondary-container` blur blob with `blur-3xl`, `scale-125`, `z-0`, and 70-90% opacity. Product image sits above at `z-10`.
- **Image behavior:** `object-cover`, clipped to circle. Use `CachedNetworkImage` for network images and local file rendering for private captured photos.
- **Hover/motion:** photo scales to `scale-105` over 700ms ease-in-out. On mobile, use the same transition for pressed/drag affordance only if it does not slow the 2-tap Quick Check flow.
- **No-image placeholder:** sage `secondaryContainer` circle with the days-of-wage number centered. Use Be Vietnam Pro 56-64sp / w800 and optional small unit line “ngày”.
- **Fallback privacy:** if image is hidden in a private context, keep the same circle size and show the placeholder rather than collapsing layout.

---

## 4. Hero Number Block

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png`.

- **Structure:** vertical stack, centered.
  1. Label: `THỜI GIAN QUY ĐỔI`.
  2. Primary number: `X,X ngày đi làm`.
  3. Descriptive sentence: short, non-judgmental copy explaining the conversion.
- **Label token:** Be Vietnam Pro 11-12sp / w700, uppercase, letter spacing 1.5-2.0, `onSurfaceVariant`.
- **Number token:** `headline-xl` / `heroNumber`, 56-72sp / w800, color `primary` or `onSurface` depending on surrounding fill; line-height 1.0-1.08 to keep the hero compact.
- **Description token:** `body-md`, 15-16sp / w400, line-height 1.35-1.45, `onSurfaceVariant`; max width 300-340px.
- **Hierarchy rule:** the days-of-wage number must be the largest and first meaningful metric on the result screen. Hours and percent are subordinate bento metrics.
- **Motion:** number count-up animation 400ms; do not animate label/description in a way that delays reading.

---

## 5. Bento Sub-Metrics

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png`.

- **Layout:** 2x2 grid on result-style screens; 12-16px gap; full-width within 20px screen padding.
- **Card token:** `surfaceContainerLowest` fill, rounded-xl (20px), padding 24px (`6` on a 4px scale), organic shadow.
- **Shadow:** soft ambient shadow: `0 14 40 organicShadow (#0F161D1F)` plus `0 4 16 organicShadowPrimaryTint (#142F4A3F)`.
- **Content stack:** icon → label → value, vertical, centered or left-aligned consistently within one grid.
- **Icon:** Material Symbols Outlined, 24-28px, color `primary` or `onSurfaceVariant`; use filled icon only if the card is selected/active.
- **Label:** Be Vietnam Pro 12-13sp / w600, uppercase optional, `onSurfaceVariant`.
- **Value:** Be Vietnam Pro 18-22sp / w700, `onSurface`.
- **Allowed metrics:** hours worked, percent of monthly income, reminder date, or decision state. Do not add cash-flow or “remaining money” metrics.

---

## 6. Days-of-Wage Chip

**Screenshot reference:** `docs/_stitch_export/screenshots/wishlist_screen.png`.

- **Use cases:** Crush feed cards, calendar list items, image placeholders, and any card that needs a compact days-of-wage badge.
- **Shape:** rounded-full pill; horizontal padding 12-14px, vertical padding 6-8px; min height 32px.
- **Fill:** `bg-secondary-container`; text/icon `text-on-secondary-container`.
- **Content:** `Symbols.schedule` icon + label `X,X ngày`; icon size 16-18px; gap 6px.
- **Typography:** Be Vietnam Pro 13-14sp / w600; use Vietnamese decimal comma.
- **Import:** `import 'package:material_symbols_icons/symbols.dart';`
- **Implementation note:** use `Icon(Symbols.schedule, fill: 0, weight: 400, opticalSize: 20)` unless the chip is selected/active.
- **Privacy:** do not show this chip in notifications/widgets by default.

---

## 7. Crush Feed Card

**Screenshot reference:** `docs/_stitch_export/screenshots/wishlist_screen.png`.

- **Container:** Pinterest-style article card; whole card is the tap target with at least 48px effective touch area.
- **Photo:** top image `h-64`, full card width, `object-cover`, rounded-2xl. Use `CachedNetworkImage` for remote sources; local private images stay local.
- **Glass heart:** top-right absolute pill/circle, 40-44px, `surface/60`, `backdrop-blur-md`, border `outlineVariant/20`; icon `Symbols.favorite`, outlined by default, `fill: 1` only when favorited/still crushing.
- **Text block:** title + optional description below image with 12-16px top spacing.
  - Title: Be Vietnam Pro 18sp / w700, `onSurface`, max 2 lines.
  - Description: Be Vietnam Pro 14sp / w400, `onSurfaceVariant`, max 2-3 lines.
- **Bottom row:** Days-of-Wage Chip anchored at bottom; optional status chip may sit beside it but must not overpower days-of-wage.
- **Motion:** card hover `-translate-y-1` over 300ms; image hover `scale-105` over 700ms; no aggressive bounce.
- **Empty image:** use sage placeholder with days-of-wage number or a subtle product icon, not a gray Material broken-image default.

---

## 8. Primary CTA Button

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png` and `docs/_stitch_export/screenshots/home_screen.png`.

- **Shape:** rounded-full pill; min height 56px; horizontal padding 20-24px; vertical padding `py-4`.
- **Fill:** `bg-primary-container`; text/icon `text-on-primary` with guaranteed contrast.
- **Typography:** Be Vietnam Pro 16sp / w700; letter spacing 0.
- **Content:** leading Material Symbol + text; icon 20-22px; gap 8-10px.
- **Shadow:** organic primary-tinted shadow using `organicShadowPrimaryTint (#142F4A3F)`; no Material elevation overlay.
- **States:** pressed scale 0.98; hover/pressed fill subtly deepens; disabled uses `surfaceContainerHigh` + `onSurfaceVariant/50`.
- **Usage:** one dominant primary action per screen. It must support the core loop without steering users into a guilt-based decision.

---

## 9. Secondary CTA Button

**Screenshot reference:** `docs/_stitch_export/screenshots/result_screen.png`.

- **Shape:** rounded-full pill; min height 52-56px; horizontal padding 20-24px.
- **Fill:** transparent by default.
- **Border:** 2px `border-primary-container`.
- **Text/icon:** `text-primary`; Be Vietnam Pro 15-16sp / w700; icon 20-22px.
- **Hover:** `bg-surface-container-high`; transition 200ms ease-out.
- **Pressed:** scale 0.98; border remains visible.
- **Usage:** secondary decisions must be visually calm and equal where product policy requires parity, especially in decision rows.

---

## 10. Floating Bottom Nav

**Screenshot reference:** `docs/_stitch_export/screenshots/home_screen.png`, `docs/_stitch_export/screenshots/result_screen.png`, and `docs/_stitch_export/screenshots/wishlist_screen.png`.

- **Position:** fixed `bottom-6`, centered, width 90% of viewport; respect safe-area bottom inset.
- **Container:** rounded-lg to rounded-2xl depending on platform density; `bg-surface/90`, `backdrop-blur-2xl`, border `outline-variant/30`, soft shadow.
- **Tabs:** 2 tabs for the M0/MVP shell: Tính toán and Crush. Settings is an entry point from the top app bar, not a bottom-nav tab.
- **Active tab:** `bg-primary-container` pill, icon with `fill: 1`, text `onPrimary`, Be Vietnam Pro 12-13sp / w700.
- **Inactive tab:** transparent fill, icon outlined `fill: 0`, text/icon `onSurfaceVariant`.
- **Sizing:** tab min height 44-48px; nav vertical padding 8px; horizontal padding 8-10px.
- **Motion:** tab switch cross-fade 200ms; active pill slides or fades subtly, never bounces.
- **Settings entry:** use the top app bar `Symbols.settings` action to open `/settings`; do not add a third settings tab.
- **Privacy:** nav labels should never expose item names, prices, income, or days-of-wage.

---

## 11. Input Fields

**Screenshot reference:** `docs/_stitch_export/screenshots/income_screen.png`.

- **Shape:** rounded-full pill; min height 56-64px; horizontal padding 18-22px.
- **Default fill:** `bg-surface-container-low`; no visible border by default.
- **Focus:** 2px `border-primary` plus soft ambient glow using primary at 5-8% opacity.
- **Text:** Be Vietnam Pro 18-28sp depending on field importance; price/currency input should be at least 28sp.
- **Placeholder:** `onSurfaceVariant/70`; never use low-contrast gray from Material defaults.
- **Currency suffix:** inline `đ` suffix, Be Vietnam Pro same baseline as value, `onSurfaceVariant`; keep formatting with Vietnamese thousand separator.
- **Validation:** show calm helper/error copy below the field; do not use bright red error surfaces unless required for accessibility.
- **Privacy:** income fields are sensitive; do not log raw values and do not echo them outside secure onboarding/settings contexts.

---

## 12. Live Preview Card (Income screen pattern)

**Screenshot reference:** `docs/_stitch_export/screenshots/income_screen.png`.

- **Use case:** live computed value preview while the user types income or work schedule; reinforces “time đi làm” without becoming a financial dashboard.
- **Container:** `bg-primary-container` fill, rounded-2xl, padding 24px, full-width inside 20px screen padding.
- **Label:** uppercase tracking-wider, Be Vietnam Pro 11-12sp / w700, `text-inverse-primary` or high-contrast muted label.
- **Number:** `headline-xl`, Be Vietnam Pro 40-56sp / w800, `text-on-primary`; line-height 1.0-1.1.
- **Description:** optional body-md below number, `text-on-primary/80`, max 2 lines.
- **Motion:** update value with 200ms cross-fade or 400ms count-up; never block typing.
- **Privacy:** preview may show derived rates but must not create a “remaining amount” or money-manager panel.

---

## 13. FAB

**Screenshot reference:** `docs/_stitch_export/screenshots/wishlist_screen.png`.

- **Position:** bottom-right above Floating Bottom Nav; respect safe-area and nav height; default offset 20px from right and 88-104px from bottom.
- **Shape:** rounded-full circle, 56-64px.
- **Fill:** `bg-primary-container`; icon `text-on-primary`.
- **Icon:** `Symbols.add`, 28px, `fill: 0` unless active.
- **Shadow:** organic primary-tinted shadow; do not use Material Design 3 FAB elevation shadow.
- **Motion:** pressed scale 0.96-0.98; hover/press fill deepens subtly; transition 200ms.
- **Usage:** create a new Crush Card or quick-add item. Do not overload with unrelated actions.

---

## 14. Filter Chips

**Screenshot reference:** NEW pattern; place above the card grid/list shown in `docs/_stitch_export/screenshots/wishlist_screen.png`.

- **Use case:** Crush feed filter row for Phương án D filters: “Đang mê”, “Sắp nhắc”, “Hết mê”, “Đã mua”, “Tất cả”.
- **Layout:** horizontal row with 8px gap; horizontal scroll if overflow; 20px screen side padding; no wrapping into multiple rows unless on tablet.
- **Shape:** rounded-full pills; min height 36-40px; horizontal padding 14-16px.
- **Inactive:** `bg-surface-container-high`, `text-on-surface-variant`, optional outlined Material Symbol `fill: 0`.
- **Active:** `bg-primary-container`, `text-on-primary`, icon `fill: 1` if present.
- **Typography:** Be Vietnam Pro 13-14sp / w600.
- **Motion:** selected state cross-fade/slide 200ms; do not animate the entire list on every filter tap.
- **Privacy:** filter labels describe card states only; they must not imply budgets, balances, or financial tracking.

---

## 15. Motion

**Screenshot reference:** all Stitch screens in `docs/_stitch_export/screenshots/`; primary examples are `result_screen.png` and `wishlist_screen.png`.

- **Photos:** hover/pressed scale to `scale-105`, 700ms, ease-in-out.
- **Cards:** hover `-translate-y-1`, 300ms, ease-out; shadow may deepen by 4-6% opacity.
- **Hero number:** count-up entrance 400ms; keep final value stable and readable.
- **Tab switch:** cross-fade 200ms; active pill movement should feel soft, not springy.
- **Buttons/chips:** pressed scale 0.98; state color transition 150-200ms.
- **Screen transitions:** fade/slide ≤ 250ms; never slow Quick Check price → result.
- **Reduced motion:** honor platform reduce-motion settings by disabling scale/count-up and keeping only opacity changes ≤ 150ms.
- **Do not do:** flashy confetti, guilt animations, shake warnings, or anything that makes the product feel like a bank alert.

---

## 16. Empty States

**Screenshot reference:** apply to list/feed surfaces derived from `docs/_stitch_export/screenshots/wishlist_screen.png`; no dedicated Stitch empty-state screenshot yet.

- **General treatment:** centered vertical stack inside the content area above the Floating Bottom Nav.
- **Visual:** subtle sage illustration placeholder, 120-160px, low detail; can be a soft rounded blob with a product/card outline Material Symbol.
- **Container:** optional `surfaceContainerLowest` card, rounded-2xl, padding 24px, soft organic shadow; avoid default gray empty panels.
- **Title:** Be Vietnam Pro 18-20sp / w700, `onSurface`.
- **Body:** Be Vietnam Pro 14-16sp / w400, `onSurfaceVariant`, max width 280-320px.
- **Primary action:** one rounded-full Primary CTA if the empty state has a clear next action.
- **Empty Crush feed copy:** “Chưa có món nào đang chờ bạn tỉnh ví.”
- **Calendar empty copy:** use copy from `docs/07_COPY_VI.md` when available; if new copy is needed, add it there before using it in UI.
- **Privacy:** empty states should never reveal income or past item details.

---

## 17. Anti-patterns (do NOT do)

**Screenshot reference:** use every Stitch screen in `docs/_stitch_export/screenshots/` as the positive reference; this section defines what must not appear when implementing those screens.

- NO Material Design 3 FAB shadow elevation.
- NO sharp corners anywhere except very small details.
- NO pure white surfaces as the app base; use `surface-container-lowest #FFFFFF` only as card pop, base `bg` is `#F4FAFD`.
- NO bright reds/greens for status — use sage tints.
- NO pure black text; use `#161D1F` for `on-surface`.
- NO “Ví tiền” / wallet / budget / money manager UI.
- NO bank-app aesthetic.
- NO default Material blue focus rings, gray cards, square list tiles, or heavy ripples.
- NO KPI dashboard layout where hours/% compete with the hero days-of-wage metric.
- NO notification/widget visuals that reveal item name, price, image, income, or days-of-wage by default.

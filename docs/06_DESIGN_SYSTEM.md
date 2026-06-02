# 06 — Design System (Phương án D — Midnight Matcha)

Visual language: **Midnight Matcha** — Organic Minimalism. Calm authority, botanical depth, sage-green
monochromatic. Premium nhưng gần gũi. **Không** giống app ngân hàng/fintech.
Hero metric luôn là phần tử lớn nhất — không gì to hơn con số "X ngày đi làm".

> Agent: hiện thực token trong `lib/core/theme/`
> (`app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_theme.dart`).
> Dùng token **tuyệt đối** — KHÔNG hardcode hex/size/radius trong widget.

---

## 1. Màu (Midnight Matcha token set)

### 1.1 Light

| Token (Dart) | Hex | Vai trò |
|---|---|---|
| `background` | `#f4fafd` | Nền chính (sage-white nhẹ, không trắng gắt) |
| `surface` | `#ffffff` | Card nổi lên trên nền (surfaceContainerLowest) |
| `surfaceLow` | `#eef5f7` | Input field, inset background |
| `surfaceContainer` | `#e8eff1` | Panel bên trong card |
| `surfaceHigh` | `#e2e9ec` | Hover states, dividers nổi |
| `surfaceHighest` | `#dde4e6` | Elevated container, surface-variant |
| `surfaceDim` | `#d4dbdd` | Overlay mờ |
| `onBackground` | `#161d1f` | Chữ chính trên nền |
| `onSurface` | `#161d1f` | Chữ trên surface |
| `onSurfaceVariant` | `#414844` | Chữ phụ, label, placeholder |
| `outline` | `#717973` | Border standard |
| `outlineVariant` | `#c1c8c2` | Border nhẹ, divider |
| `primary` | `#012d1d` | Deep forest — brand, heading text, icon chính |
| `onPrimary` | `#ffffff` | Chữ trên primary |
| `primaryContainer` | `#1b4332` | Dark forest — hero card bg, CTA bg |
| `onPrimaryContainer` | `#86af99` | Chữ/icon trên primaryContainer |
| `inversePrimary` | `#a5d0b9` | Light sage — accent trong dark mode |
| `primaryFixed` | `#c1ecd4` | Rất nhạt — focus ring, subtle highlight |
| `primaryFixedDim` | `#a5d0b9` | Dim variant của primaryFixed |
| `onPrimaryFixed` | `#002114` | Chữ trên primaryFixed |
| `onPrimaryFixedVariant` | `#274e3d` | Chữ thứ cấp trên primaryFixed |
| `secondary` | `#4b6454` | Muted sage — accent thứ cấp |
| `onSecondary` | `#ffffff` | Chữ trên secondary |
| `secondaryContainer` | `#cbe7d2` | Chip/tag bg, day-count badge, decision buttons |
| `onSecondaryContainer` | `#4f6858` | Chữ trên secondaryContainer |
| `tertiary` | `#1f2825` | Charcoal tối — element neutral tối |
| `onTertiary` | `#ffffff` | |
| `tertiaryContainer` | `#353e3a` | Dark neutral container |
| `onTertiaryContainer` | `#9fa9a3` | Chữ trên tertiaryContainer |
| `inverseSurface` | `#2b3234` | Dark surface — snackbar, tooltip bg |
| `inverseOnSurface` | `#ebf2f4` | Chữ trên inverseSurface |
| `surfaceTint` | `#3f6653` | M3 tint overlay |
| `error` | `#ba1a1a` | Lỗi |
| `onError` | `#ffffff` | |
| `errorContainer` | `#ffdad6` | |
| `onErrorContainer` | `#93000a` | |
| `warning` | `#d9a521` | "Chờ sale" — KHÔNG dùng đỏ cảnh báo gắt |

### 1.2 Dark

| Token (Dart) | Hex | Ghi chú |
|---|---|---|
| `backgroundDark` | `#0e1a13` | Very dark forest |
| `surfaceDark` | `#161d1f` | Dark base card |
| `surfaceLowDark` | `#1a2520` | |
| `surfaceContainerDark` | `#1e2b26` | |
| `surfaceHighDark` | `#253229` | |
| `surfaceHighestDark` | `#2d3b35` | |
| `surfaceDimDark` | `#0b1410` | |
| `onSurfaceDark` | `#e8f0eb` | |
| `onSurfaceVariantDark` | `#b5c2bb` | |
| `outlineDark` | `#8f9d96` | |
| `outlineVariantDark` | `#414844` | |
| `primaryDark` | `#a5d0b9` | = inversePrimary light |
| `onPrimaryDark` | `#002114` | |
| `primaryContainerDark` | `#274e3d` | |
| `onPrimaryContainerDark` | `#c1ecd4` | |
| `secondaryDark` | `#b2cdb9` | |
| `onSecondaryDark` | `#082013` | |
| `secondaryContainerDark` | `#344c3d` | |
| `onSecondaryContainerDark` | `#cde9d5` | |
| `errorDark` | `#ffb4ab` | |
| `onErrorDark` | `#690005` | |
| `inverseSurfaceDark` | `#dde4e6` | |
| `inverseOnSurfaceDark` | `#2b3234` | |
| `inversePrimaryDark` | `#012d1d` | = primary light |

> Dark mode seed: Material3 dark derivation từ seed `#1b4332`.

---

## 2. Typography — Be Vietnam Pro

Font duy nhất: **Be Vietnam Pro** (Google Fonts, hỗ trợ tiếng Việt đầy đủ dấu).
Import qua `google_fonts` package. Đảm bảo `lineHeight ≥ 1.3` để dấu tiếng Việt không chồng.

| Token | Size | Weight | lineHeight | letterSpacing | Dùng cho |
|---|---|---|---|---|---|
| `heroNumber` | **64sp** | **800** | 68sp | −0.03em | Con số ngày lương — phần tử **to nhất** màn |
| `heroUnit` | 20sp | 600 | 28sp | 0 | "ngày đi làm" kề bên hero |
| `displayLg` | 40sp | 700 | 48sp | −0.02em | Tiêu đề màn kết quả lớn |
| `headlineLg` | 32sp | 700 | 40sp | −0.01em | Tiêu đề section (desktop) |
| `headlineLgMobile` | 28sp | 700 | 36sp | 0 | Brand name trên AppBar |
| `headlineMd` | 24sp | 600 | 32sp | 0 | Tiêu đề card, tên màn |
| `bodyLg` | 18sp | 400 | 28sp | 0 | Input giá, sub-kết quả số |
| `bodyMd` | 16sp | 400 | 24sp | 0 | Nội dung chính, mô tả |
| `labelMd` | 14sp | 600 | 20sp | +0.02em | Button, tab label, input label |
| `labelSm` | 12sp | 500 | 16sp | +0.05em | Caption, privacy banner, chip nhỏ |
| `priceInput` | 32sp | 600 | 38sp | −0.01em | Text field nhập giá lớn |

> `heroNumber` (64sp) **KHÔNG có trong bộ Stitch** — đây là override bắt buộc để
> giữ Golden Rule #3. Hero metric LUÔN là phần tử lớn nhất trên màn hình.

---

## 3. Spacing & Shape

Base unit: **8px**. Mọi khoảng cách là bội số của 8.

### Spacing tokens

| Token | Value | Dùng cho |
|---|---|---|
| `xs` | 4px | Khoảng micro: icon↔label, badge padding |
| `base` | 8px | Base grid unit |
| `sm` | 12px | Chip padding, dense row |
| `md` | 24px | Section padding, card gutter |
| `lg` | 48px | Khoảng lớn giữa section |
| `xl` | 80px | Hero area, onboarding header |
| `gutter` | 24px | Column gutter |
| `marginMobile` | 16px | Screen edge mobile |
| `marginDesktop` | 64px | Screen edge desktop |

### Border radius tokens

| Token | Value | Dùng cho |
|---|---|---|
| `radiusSm` | 8px | Subtle rounding |
| `radiusDefault` | 16px | Input field, small card, list item |
| `radiusMd` | 24px | Bottom nav island, chip |
| `radiusLg` | 32px | Large card, bottom sheet |
| `radiusXl` | 48px | Hero card "vessel", modal |
| `radiusFull` | 9999px | Button pill, avatar, tag |

> Không bao giờ mix góc vuông với góc tròn trong cùng 1 màn.
> Mọi container, button, input đều là rounded. Level cao hơn = radius lớn hơn.

### Elevation (Tonal layers — không shadow đậm)

| Level | Màu | Dùng cho |
|---|---|---|
| 0 — nền | `background` | Scaffold/screen background |
| 1 — input | `surfaceLow` | Text field, inset widget |
| 2 — card | `surface` (#fff) | Card nổi trên nền |
| 3 — panel | `surfaceContainer` | Panel bên trong card |
| 4 — modal | `surfaceHigh` | Bottom sheet, dropdown |

Ambient shadow khi cần (FAB, primary CTA):
```
box-shadow: 0 8px 32px rgba(1, 45, 29, 0.08)   // tonal green, rất nhạt
FAB / CTA:  0 8px 20px rgba(27, 67, 50, 0.30)
```

---

## 4. Component Guideline

### HeroNumberView
- Con số: `heroNumber` (64sp/w800), màu `primary` trên nền light — HOẶC
  `inversePrimary` (#a5d0b9) nếu đặt trên card `primaryContainer`
- Đơn vị "ngày đi làm": `heroUnit` (20sp/w600), màu `onSurfaceVariant`
- Animation: `AnimatedCounter` count-up khi result xuất hiện (≤ 400ms, `Curves.easeOut`)
- **Không widget nào to hơn hero number — đây là quy tắc layout bất di bất dịch**

### Hero Result Card ("Vessel")
- Background: `primaryContainer` (#1b4332)
- Padding: 32px (= `md` + 8)
- Radius: `radiusXl` (48px)
- Shadow: `0 8px 32px rgba(1,45,29,0.15)`, border: `1px solid rgba(1,45,29,0.2)`
- Số ngày lương: `heroNumber`, màu `inversePrimary` (#a5d0b9) hoặc trắng
- Sub-metrics (giờ, %): chips `secondaryContainer`/`onSecondaryContainer`

### PrimaryButton (CTA)
- Style: pill (`radiusFull`), bg `primaryContainer` (#1b4332), text white
- Hover: bg `primary` (#012d1d), shadow tăng
- Min-height: 56px, padding ngang: 32px
- Full-width trên mobile
- Font: `labelMd` (14sp/w600)

### SecondaryButton
- Style: outlined pill, border `primaryContainer`, text `primary`
- Hover: bg `surfaceHigh`

### DecisionRow (Result screen)
4 nút **đồng cấp thị giác** — không nút nào to hơn hoặc nổi màu hơn (tránh phán xét):

| Nút | Icon | BG |
|---|---|---|
| Mua | `shopping_cart` | `secondaryContainer` |
| Để mai tính | `bedtime` | `secondaryContainer` |
| Bỏ qua | `close` | `surfaceHigh` |
| Lưu vào Crush Calendar | `bookmark_add` | `secondaryContainer` |

Layout: 2×2 grid mobile, hoặc 4 nút icon-on-top hàng ngang.

### PriceInput
- BG: `surface` (#fff), border `outlineVariant`, radius `radiusDefault`
- Focus: border `primary`, ring `primaryFixed` 30% opacity
- Font: `bodyLg` (18sp), prefix "₫" màu `primary`, weight w600
- Height: ≥ 64px
- Auto-format: `3.000.000` (dấu chấm nghìn vi_VN, `intl`)

### CrushCardTile
- Ảnh: radius `radiusLg` (32px), aspect 4:3, cover
- Tên: `headlineMd`, màu `onSurface`
- Day chip: `secondaryContainer`/`onSecondaryContainer`, `labelMd`, icon `schedule`
- Status chip màu theo trạng thái:
  - `crushing`/`sleepOnIt`: `secondaryContainer`
  - `bought`: `primaryContainer`/`onPrimaryContainer`
  - `overIt`: `surfaceHighest`/`onSurfaceVariant`
  - `waitingForSale`: warning color

### BottomNavBar — 2 tab
- Style: floating island, `fixed bottom: 24px`, width 90%, max 448px
- BG: `surface/90` + `backdropFilter blur(24px)`
- Border: `outlineVariant/30`, shadow lg, radius `radiusMd` (24px)
- Padding nội: 8px (`base`)

| Tab | Icon (active/inactive) | Label | Route |
|---|---|---|---|
| Tính toán | `calculate_filled` / `calculate` | "Tính toán" | `/` |
| Crush | `favorite_filled` / `favorite` | "Crush" | `/calendar` |

- Active: bg `primaryContainer`, text `onPrimaryContainer`, radius `radiusDefault` (16px)
- Inactive: text `onSurfaceVariant`, hover text `primary`
- Transition: `AnimatedContainer` ≤ 200ms
- **Không có tab "Ví tiền"** — vi phạm Golden Rule #1

### TopAppBar
- BG: `surface/80` + `backdropFilter blur(24px)`, sticky
- Leading: avatar tròn 40px, bg `secondaryContainer`, initials `onSecondaryContainer`
- Center: "Ngày Lương", `headlineLgMobile`, `primary`, font-black, tracking-tighter
- Trailing: `settings` icon, `primary`

### ChipTag
- Shape: `radiusFull` (pill)
- Default: bg `secondaryContainer`, text `onSecondaryContainer`
- Weight: `labelMd` hoặc `labelSm`
- Compact: padding 4×12 (xs×sm)

### PrivacyBanner
- BG: `primaryFixed` (#c1ecd4), border `onPrimaryFixed/20`
- Icon: `lock_filled`, màu `onPrimaryFixedVariant`
- Text: `labelSm`, màu `onPrimaryFixed`
- Radius: `radiusDefault` (16px)

---

## 5. Motion

| Element | Animation | Duration | Curve |
|---|---|---|---|
| Chuyển màn | `FadeTransition` + `SlideTransition` nhẹ (8px) | ≤ 250ms | `easeOut` |
| Hero count-up | `AnimatedCounter` (số đếm lên) | ≤ 400ms | `easeOut` |
| Bottom nav active | `AnimatedContainer` scale 0.95→1 + fade bg | ≤ 200ms | `easeInOut` |
| Card press | `AnimatedScale` 0.98 | 150ms | `easeInOut` |
| Input focus | Border + ring fade | 200ms | `easeOut` |

Tránh animation rườm rà làm chậm flow nhập giá (Golden Rule #8).

---

## 6. Delta so với thiết kế cũ (warm orange → Midnight Matcha)

| Thứ | Cũ (warm orange) | Mới (Midnight Matcha) |
|---|---|---|
| Nền chính | `#FBF8F3` warm off-white | `#f4fafd` sage-white |
| Primary/accent | `#E8643C` cam ấm | `#012d1d` / `#1b4332` deep forest green |
| Surface card | `#FFFFFF` | `#FFFFFF` (không đổi) |
| textSecondary | `#6B635A` | `#414844` |
| Positive | `#2E9E6B` | `#4b6454` secondary |
| Warning | `#D9A521` | `#D9A521` (không đổi) |
| heroNumber size | 56–72sp | **64sp** (chuẩn bội 8) |
| Font | Be Vietnam Pro | Be Vietnam Pro (không đổi) |
| Tab 2 | — | Mơ ước → **"Crush"** |
| Tab 3 | — | **Xóa** "Ví tiền" (vi phạm GR#1) |

---

## 7. Tham khảo (không commit vào code)

Source: `docs/_stitch_export/` — 4 screens + DESIGN.md từ Stitch "Midnight Matcha" theme.
Stitch bỏ qua: 4 income modes, "Còn mê không?" loop, decision row, FOMO reasons,
anti-haul, Save Card — tất cả được **giữ lại** trong sản phẩm theo spec `01_PRD.md`.

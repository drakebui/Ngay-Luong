# 06 — Design System

Định hướng: minimal, nhanh, card-based, typography lớn, hơi playful, calm/private.
**Không** giống app ngân hàng/fintech nghiêm túc. Hero number luôn nổi bật nhất.

> Agent: hiện thực các token này trong `lib/core/theme/` (`app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_theme.dart`). Dùng token, KHÔNG hardcode màu/size trong widget. Component behavior chi tiết nằm ở `docs/11_VISUAL_LANGUAGE.md`.

---

## 1. Màu — Midnight Matcha

Palette này thay thế direction cũ. Tinh thần: matcha/sage, riêng tư, editorial, không bank-app, không cảnh báo tài chính.

### Light
| Token | Hex | Dùng cho |
|---|---|---|
| `bg` / `background` | `#F4FAFD` | nền chính app |
| `surface` | `#FDFEFE` | app bar/glass surface |
| `surfaceContainerLowest` | `#FFFFFF` | card pop nổi trên nền |
| `surfaceContainerLow` / `surfaceAlt` | `#EEF6F2` | input, card phụ |
| `surfaceContainerHigh` | `#E4EEE9` | hover/pressed, chip inactive |
| `onSurface` / `textPrimary` | `#161D1F` | chữ chính, không dùng pure black |
| `onSurfaceVariant` / `textSecondary` | `#5F6F68` | chữ phụ |
| `primary` / `accent` | `#2F4A3F` | hero number, icon active, emphasis |
| `primaryContainer` / `accentSoft` | `#DDEDE4` | CTA primary fill, active tab/chip |
| `onPrimary` | `#F8FFFB` | chữ/icon trên primary đậm |
| `onPrimaryContainer` | `#163026` | chữ/icon trên primaryContainer |
| `secondaryContainer` | `#E8F1EC` | placeholder ảnh, days chip, decorative blur |
| `onSecondaryContainer` | `#29443A` | text/icon trên secondaryContainer |
| `outlineVariant` / `neutral` | `#C7D5CE` | divider, border nhẹ |
| `positive` | `#5F8F75` | trạng thái tích cực dạng sage |
| `warning` | `#B99A5B` | chờ sale, muted amber không gắt |
| `organicShadow` | `#0F161D1F` | màu shadow chính = onSurface 6% alpha |
| `organicShadowPrimaryTint` | `#142F4A3F` | shadow tint primary = primary 8% alpha |

### Dark
| Token | Hex |
|---|---|
| `bg` / `background` | `#101715` |
| `surface` | `#18211E` |
| `surfaceContainerLowest` | `#1D2824` |
| `surfaceContainerLow` / `surfaceAlt` | `#22312B` |
| `surfaceContainerHigh` | `#2B3B34` |
| `onSurface` / `textPrimary` | `#EEF7F2` |
| `onSurfaceVariant` / `textSecondary` | `#B8C8C0` |
| `primary` / `accent` | `#A8D5BD` |
| `primaryContainer` / `accentSoft` | `#29443A` |
| `onPrimary` | `#102017` |
| `onPrimaryContainer` | `#DDF2E6` |
| `secondaryContainer` | `#24362F` |
| `onSecondaryContainer` | `#D6E7DE` |
| `outlineVariant` / `neutral` | `#40534B` |
| `positive` | `#8BC8A4` |
| `warning` | `#D0B374` |
| `organicShadow` | `#33000000` |
| `organicShadowPrimaryTint` | `#1FA8D5BD` |

> Tránh đỏ cảnh báo tài chính và xanh dương ngân hàng. Dùng sage/matcha tints cho trạng thái; không dùng pure black text.

---

## 2. Typography

Font UI: **Be Vietnam Pro** qua `GoogleFonts.beVietnamPro(...)` để hỗ trợ tiếng Việt tốt. Không bundle `.ttf` trong repo.

| Token | Size | Weight | Dùng cho |
|---|---|---|---|
| `heroNumber` | 56–72 | 800 | con số ngày lương |
| `heroUnit` | 20 | 600 | chữ “ngày đi làm” |
| `title` | 24 | 700 | tiêu đề màn |
| `body` | 16 | 400 | nội dung |
| `label` | 14 | 500 | nhãn, chips |
| `caption` | 12 | 400 | phụ chú, privacy |

Tiếng Việt cần đủ dấu — đảm bảo font có dấu đầy đủ và line-height đủ rộng (1.3–1.4) để không cụng dấu.

---

## 3. Spacing, shape & shadow

- Base unit: **4**. Scale: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40.
- Padding màn: 20 ngang.
- Card radius: **20**. Button radius: **16**. Chip radius: **full (pill)**.
- Input giá: cao ≥ 64, radius 20, chữ to (≥ 28).
- Shadow token chính: `organicShadow = #0F161D1F`.
- Shadow tint: `organicShadowPrimaryTint = #142F4A3F`.
- Công thức shadow mặc định cho cards/bento: `0 14 40 organicShadow` + `0 4 16 organicShadowPrimaryTint`.
- Tránh đổ bóng Material elevation mặc định; shadow phải mềm, organic, và nhẹ.

---

## 4. Component guideline

- **HeroNumberView:** số + đơn vị, primary color, căn giữa, là tâm điểm. Có animation đếm lên nhẹ (optional, < 400ms).
- **PrimaryButton:** `primaryContainer`, chữ/icon `onPrimaryContainer`, full-width hoặc lớn; secondary là outline `outlineVariant`.
- **DecisionRow:** 4 quyết định Mua / Để mai tính / Bỏ qua / Lưu vẫn tồn tại trong flow card/detail; đồng cấp thị giác, KHÔNG nhấn “không mua” hơn “mua”.
- **CrushCardTile:** ảnh (nếu có) + tên + Days-of-Wage Chip + chip status sage tint.
- **PriceInput:** keypad số, auto-format nghìn, suffix inline `đ`.
- **PrivacyBanner:** nền `secondaryContainer` hoặc `primaryContainer`, icon khóa, chữ caption.

---

## 5. Motion

- Chuyển màn: slide nhẹ / fade, ≤ 250ms.
- Hero: đếm số lên nhẹ khi ra kết quả, 400ms.
- Photo/card hover: xem `docs/11_VISUAL_LANGUAGE.md` §15.
- Mascot (Phase 2): phản ứng nhỏ, không chặn thao tác, tắt được.
- Tránh animation rườm rà làm chậm flow nhập giá.

# 06 — Design System

Định hướng: minimal, nhanh, card-based, typography lớn, hơi playful, calm/private.
**Không** giống app ngân hàng/fintech nghiêm túc. Hero number luôn nổi bật nhất.

> Agent: hiện thực các token này trong `lib/core/theme/` (`app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_theme.dart`). Dùng token, KHÔNG hardcode màu/size trong widget.

---

## 1. Màu (đề xuất — có thể tinh chỉnh, giữ tinh thần calm + 1 accent ấm)

### Light
| Token | Hex | Dùng cho |
|---|---|---|
| `bg` | `#FBF8F3` | nền chính (warm off-white, không trắng gắt) |
| `surface` | `#FFFFFF` | card |
| `surfaceAlt` | `#F2EEE6` | card phụ / input |
| `textPrimary` | `#1F1B16` | chữ chính |
| `textSecondary` | `#6B635A` | chữ phụ |
| `accent` | `#E8643C` | hero number, CTA chính (cam ấm — "đau ví" nhẹ nhàng) |
| `accentSoft` | `#FBE3DA` | nền nhấn nhẹ |
| `positive` | `#2E9E6B` | trạng thái "đáng mua", anti-haul tích cực |
| `neutral` | `#B8AFA3` | viền, divider |
| `warning` | `#D9A521` | "chờ sale" (không dùng đỏ cảnh báo gắt) |

### Dark
| Token | Hex |
|---|---|
| `bg` | `#161311` |
| `surface` | `#211C18` |
| `surfaceAlt` | `#2B2520` |
| `textPrimary` | `#F4EFE8` |
| `textSecondary` | `#A89F94` |
| `accent` | `#FF7A52` |
| `accentSoft` | `#3A241C` |
| `positive` | `#56C28C` |

> Tránh đỏ "cảnh báo tài chính" và xanh dương "ngân hàng". Palette ấm để app cảm giác như cuốn sổ riêng, không phải bảng số liệu.

---

## 2. Typography

Font đề xuất: một sans tròn, thân thiện (vd **Be Vietnam Pro** — hỗ trợ tiếng Việt tốt) cho UI; có thể dùng cùng font cho hero ở weight cao.

| Token | Size | Weight | Dùng cho |
|---|---|---|---|
| `heroNumber` | 56–72 | 800 | con số ngày lương |
| `heroUnit` | 20 | 600 | chữ "ngày đi làm" |
| `title` | 24 | 700 | tiêu đề màn |
| `body` | 16 | 400 | nội dung |
| `label` | 14 | 500 | nhãn, chips |
| `caption` | 12 | 400 | phụ chú, privacy |

Tiếng Việt cần đủ dấu — đảm bảo font có dấu đầy đủ và line-height đủ rộng (1.3–1.4) để không cụng dấu.

---

## 3. Spacing & shape

- Base unit: **4**. Scale: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40.
- Padding màn: 20 ngang.
- Card radius: **20**. Button radius: **16**. Chip radius: **full (pill)**.
- Input giá: cao ≥ 64, radius 20, chữ to (≥ 28).
- Shadow: rất nhẹ (calm), tránh đổ bóng đậm kiểu material mạnh.

---

## 4. Component guideline

- **HeroNumberView:** số + đơn vị, accent color, căn giữa, là tâm điểm. Có animation đếm lên nhẹ (optional, < 400ms).
- **PrimaryButton:** accent, chữ trắng, full-width hoặc lớn; secondary là outline neutral.
- **DecisionRow:** 4 nút bằng nhau (Mua / Để mai tính / Bỏ qua / Lưu) — đồng cấp thị giác, KHÔNG nhấn "không mua" hơn "mua" (tránh phán xét).
- **CrushCardTile:** ảnh (nếu có) + tên + chip ngày lương + chip status màu theo trạng thái.
- **PriceInput:** keypad số, auto-format nghìn, hậu tố "đ".
- **PrivacyBanner:** nền `accentSoft`, icon khóa, chữ caption.

---

## 5. Motion

- Chuyển màn: slide nhẹ / fade, ≤ 250ms.
- Hero: đếm số lên nhẹ khi ra kết quả.
- Mascot (Phase 2): phản ứng nhỏ, không chặn thao tác, tắt được.
- Tránh animation rườm rà làm chậm flow nhập giá.

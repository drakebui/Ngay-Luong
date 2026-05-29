# Ngày Lương

[![CI](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/ci.yml)

> Quy đổi giá món đồ → số ngày đi làm trước khi mua.
> Local-first · No login · Hero metric luôn là "X ngày đi làm"

---

## Dev setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze   # phải sạch (0 error)
flutter test      # phải pass
flutter run
```

## Tài liệu

Đọc theo thứ tự:

| File | Nội dung |
|---|---|
| `AGENTS.md` | Entry point — Golden Rules, tech stack, kiến trúc |
| `docs/01_PRD.md` | Sản phẩm, scope MVP |
| `docs/09_BUILD_PLAN.md` | Lộ trình milestone |
| `SESSION_NOTES.md` | Trạng thái hiện tại của dự án |

## Trạng thái

| Milestone | Trạng thái |
|---|---|
| M0 — Project setup | ✅ Done |
| M1 — Calc engine + tests | ✅ Done |
| M2 — Income onboarding + storage | 🚧 In progress |
| M3 → M8 | ⏳ Planned |

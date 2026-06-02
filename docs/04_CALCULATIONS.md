# 04 — Calculations (single source of truth)

> Toàn bộ logic này đã được hiện thực trong `lib/core/calc/wage_calculator.dart`.
> File doc này là đặc tả + bộ test case. Code và doc phải khớp nhau tuyệt đối.
> Mọi quy đổi tiền↔thời gian PHẢI gọi `WageCalculator`, không tính rải rác.

---

## 1. Giá trị nền tảng từ IncomeProfile

### 1.1 Lương ngày (`dailyWage`) — luôn tính được

```
mode = monthly: dailyWage = monthlyNetIncome / workDaysPerMonth
mode = daily:   dailyWage = dailyIncome
mode = hourly:  dailyWage = hourlyIncome * workHoursPerDay
mode = project: dailyWage = projectIncome / projectTotalDays
                (nếu chỉ có projectTotalHours: 
                 dailyWage = (projectIncome / projectTotalHours) * workHoursPerDay)
```

### 1.2 Lương giờ (`hourlyWage`)

```
mode = monthly: hourlyWage = monthlyNetIncome / (workDaysPerMonth * workHoursPerDay)
mode = daily:   hourlyWage = dailyIncome / workHoursPerDay
mode = hourly:  hourlyWage = hourlyIncome
mode = project: hourlyWage = projectIncome / projectTotalHours
                (nếu chỉ có projectTotalDays:
                 hourlyWage = (projectIncome / projectTotalDays) / workHoursPerDay)
```

### 1.3 Thu nhập tháng ước tính (`monthlyIncomeEstimate`) — cho % tháng

```
mode = monthly: = monthlyNetIncome
mode = daily:   = dailyIncome * workDaysPerMonth
mode = hourly:  = hourlyIncome * workHoursPerDay * workDaysPerMonth
mode = project: = dailyWage * workDaysPerMonth   (ước tính, dùng default 22)
```

> Với mode hourly/daily/project, % tháng là con số **ước tính** dùng default `workDaysPerMonth`.
> Nếu thiếu dữ liệu để ước tính hợp lý → trả `null`, UI ẩn dòng % (không hiện 0).

---

## 2. Quy đổi một mức giá `price`

```
daysOfWage        = price / dailyWage
hoursOfWork       = price / hourlyWage
pctOfMonthlyIncome= (monthlyIncomeEstimate == null || == 0)
                      ? null
                      : price / monthlyIncomeEstimate * 100
```

### Cost-per-use (Phase 3)
```
costPerUse        = price / expectedUses          (expectedUses >= 1)
usesToWorthIt     = price / acceptablePricePerUse (nếu user đặt ngưỡng)
```

---

## 3. Quy tắc làm tròn & hiển thị

> Tính toán giữ `double` đầy đủ. Chỉ làm tròn ở bước HIỂN THỊ (trong `formatters.dart`).

| Đại lượng | Quy tắc hiển thị | Ví dụ |
|---|---|---|
| `daysOfWage` (hero) | 1 chữ số thập phân, dấu phẩy. Nếu < 0,1 → "<0,1 ngày". Nếu ≥ 100 → làm tròn 0 thập phân | `4,4 ngày` · `0,7 ngày` · `12 ngày` |
| `hoursOfWork` | 1 chữ số thập phân | `35,2 giờ` |
| `pctOfMonthlyIncome` | 0 thập phân nếu ≥ 10; 1 thập phân nếu < 10 | `20%` · `3,4%` |
| Tiền (VND) | Tách nghìn bằng ".", hậu tố "đ" | `3.000.000đ` |
| `costPerUse` | Làm tròn hàng trăm gần nhất | `~11.500đ/lần` |

Đơn vị "ngày"/"giờ" số ít/nhiều trong tiếng Việt **không đổi** (không có "days"), nên không cần pluralize.

---

## 4. Edge cases (bắt buộc test)

1. `dailyWage <= 0` hoặc `IncomeProfile == null` → ném/return `CalcError.noIncome`; UI điều hướng về onboarding, KHÔNG hiển thị NaN/Infinity.
2. `price <= 0` → `CalcError.invalidPrice`; nút Check disabled khi price rỗng/≤0.
3. `price` rất lớn (vài tỷ) → vẫn tính, hero làm tròn 0 thập phân.
4. `hourlyWage` không tính được (thiếu giờ) → `hoursOfWork = null`, UI ẩn dòng giờ.
5. `monthlyIncomeEstimate == null` → ẩn dòng %.
6. project mode có cả hours và days → ưu tiên dùng **days** cho dailyWage, **hours** cho hourlyWage; nếu chỉ 1 trong 2 → derive như §1.
7. Số thập phân: dùng `,` cho thập phân và `.` cho phân tách nghìn (locale vi_VN). Input giá cũng parse được khi user gõ "3.000.000" hoặc "3000000".

---

## 5. Worked examples (dùng làm test vector)

### Ví dụ A — monthly
Input: `monthlyNetIncome=15.000.000`, `workDaysPerMonth=22`, `workHoursPerDay=8`, `price=3.000.000`
```
dailyWage = 15.000.000 / 22 = 681.818,18
hourlyWage = 15.000.000 / (22*8) = 85.227,27
daysOfWage = 3.000.000 / 681.818,18 = 4,4   → "4,4 ngày"
hoursOfWork = 3.000.000 / 85.227,27 = 35,2  → "35,2 giờ"
pct = 3.000.000 / 15.000.000 * 100 = 20      → "20%"
```

### Ví dụ B — hourly
Input: `hourlyIncome=100.000`, `workHoursPerDay=8`, `workDaysPerMonth=22 (default)`, `price=499.000`
```
dailyWage = 100.000 * 8 = 800.000
daysOfWage = 499.000 / 800.000 = 0,62 → "0,6 ngày"
hoursOfWork = 499.000 / 100.000 = 4,99 → "5,0 giờ"
monthlyEstimate = 100.000*8*22 = 17.600.000
pct = 499.000 / 17.600.000 *100 = 2,83 → "2,8%"
```

### Ví dụ C — daily, không có workDaysPerMonth riêng (dùng default 22)
Input: `dailyIncome=700.000`, `workHoursPerDay=8`, `price=1.200.000`
```
dailyWage = 700.000
daysOfWage = 1,71 → "1,7 ngày"
hourlyWage = 700.000/8 = 87.500
hoursOfWork = 13,7
monthlyEstimate = 700.000*22 = 15.400.000
pct = 7,8 → "7,8%"
```

### Ví dụ D — project (chỉ có total hours)
Input: `projectIncome=20.000.000`, `projectTotalHours=160`, `workHoursPerDay=8`, `price=2.000.000`
```
hourlyWage = 20.000.000/160 = 125.000
dailyWage = 125.000*8 = 1.000.000
daysOfWage = 2,0 → "2,0 ngày"
hoursOfWork = 16,0 → "16,0 giờ"
```

### Ví dụ E — cost-per-use (Phase 3)
Input: `price=1.200.000`, `expectedUses=104` (2 lần/tuần * 52 tuần)
```
costPerUse = 1.200.000/104 = 11.538 → "~11.500đ/lần"
```

> Test phải kiểm tra giá trị số (sai số ±0,05 cho ngày/giờ; ±0,1 cho %) và chuỗi hiển thị cuối cùng.

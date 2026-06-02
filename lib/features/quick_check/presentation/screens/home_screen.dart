import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ngay_luong/core/router/routes.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/features/quick_check/presentation/providers/quick_check_provider.dart';
import 'package:ngay_luong/features/quick_check/presentation/widgets/salary_day_banner.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String raw) {
    // Giữ lại vị trí cursor và chỉ update nếu text thay đổi.
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      ref.read(priceInputProvider.notifier).state = '';
      if (_controller.text.isNotEmpty) {
        _controller.value = const TextEditingValue(text: '');
      }
      return;
    }

    final number = int.tryParse(digits) ?? 0;
    final formatted = NumberFormat('#,##0', 'vi_VN').format(number);

    ref.read(priceInputProvider.notifier).state = formatted;

    if (_controller.text != formatted) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _onCheckPressed() {
    final rawText = ref.read(priceInputProvider);
    final price = AppFormatters.parsePrice(rawText);

    if (price == null) return;

    final profileAsync = ref.read(incomeProfileNotifierProvider);
    final profile = profileAsync.valueOrNull;

    if (profile == null || !profile.isUsable) {
      context.push(Routes.onboarding);
      return;
    }

    context.push(Routes.result, extra: price);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rawText = ref.watch(priceInputProvider);
    final canCheck = AppFormatters.parsePrice(rawText) != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    tooltip: l10n.homeShortcutCalendar,
                    onPressed: () => context.push(Routes.calendar),
                  ),
                  const Spacer(),
                  Text(
                    'Ngày Lương',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: l10n.settingsTitle,
                    onPressed: () => context.push(Routes.settings),
                  ),
                ],
              ),
            ),
            const SalaryDayBanner(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.homePriceHint,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Container(
                      height: 88,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.surfaceAltDark
                            : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: _onTextChanged,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: false,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.base,
                                  vertical: AppSpacing.md,
                                ),
                                hintText: '0',
                                hintStyle: GoogleFonts.beVietnamPro(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.35),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.base,
                            ),
                            child: Text(
                              'đ',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.base,
              ),
              child: FilledButton(
                onPressed: canCheck ? _onCheckPressed : null,
                child: Text(l10n.homeCheck),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

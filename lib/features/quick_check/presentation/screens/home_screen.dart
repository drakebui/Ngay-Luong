import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:ngay_luong/features/quick_check/presentation/screens/result_screen.dart';
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
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = ref.read(itemNameProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
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

    final name = ref.read(itemNameProvider).trim();
    context.push(
      Routes.result,
      extra: ResultScreenArgs(
        price: price,
        itemName: name.isEmpty ? null : name,
      ),
    );
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
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryContainer,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: AppColors.onSurface,
                    ),
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
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: l10n.settingsTitle,
                    onPressed: () => context.push(Routes.settings),
                  ),
                ],
              ),
            ),
            const SalaryDayBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.base),
                    const _HeroCard(),
                    const SizedBox(height: AppSpacing.xl),
                    _FieldLabel(text: l10n.homeItemNameLabel),
                    const SizedBox(height: AppSpacing.sm),
                    _buildNameInputField(l10n),
                    const SizedBox(height: AppSpacing.base),
                    _FieldLabel(text: l10n.homePriceValueLabel),
                    const SizedBox(height: AppSpacing.sm),
                    _buildPriceInputField(),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: canCheck ? _onCheckPressed : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(l10n.homeCheck),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.base,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInputField(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              onChanged: (value) =>
                  ref.read(itemNameProvider.notifier).state = value,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.base,
                ),
                hintText: l10n.homeItemNameHint,
                hintStyle: const TextStyle(
                  color: AppColors.outlineVariant,
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: AppSpacing.base),
            child: Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.base),
            child: Text(
              '₫',
              style: GoogleFonts.beVietnamPro(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
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
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.base,
                ),
                hintText: '0',
                hintStyle: GoogleFonts.beVietnamPro(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: AppColors.outlineVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  static const _imageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCFKQ0wDaQs7EZm6cMkB3SEtHfaqGvwzXdyIdf1Yqmbj6mtn_mG-EjP7aZGYeBlLBSmEGvVXSptrgKozcdHpT70ZzG_f8qwatJrPftEJPDvYSAcTDBnjsqcImU18NM9arQiGF9mWUXo4-3enP6KFb1Qm5nR0ECdrUHl6XFI1uem8Rihi1vpwBgk4mVeHQuO9ZeosWQ8sjm4VqU9GAP5MScpFdGAJrJdSsqqRfbNhm39lFtXImUJkLRcfjfNelbABP4zoHjAaX-YJPf7';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 216,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentSoft,
                      AppColors.accent.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.accent.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.screenPadding,
              bottom: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          l10n.homeHeroChip,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.homeHeroTitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.35,
      ),
    );
  }
}

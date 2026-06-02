import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/core/widgets/hero_number_view.dart';
import 'package:ngay_luong/features/crush/domain/crush_models.dart';
import 'package:ngay_luong/features/crush/domain/crush_mood.dart';
import 'package:ngay_luong/features/crush/domain/remind_at_calculator.dart';
import 'package:ngay_luong/features/crush/presentation/providers/crush_providers.dart';
import 'package:ngay_luong/features/income/presentation/providers/income_provider.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class CrushEditorArgs {
  const CrushEditorArgs({
    required this.price,
    required this.daysOfWage,
    required this.hoursOfWork,
    required this.pctOfMonthlyIncome,
    required this.initialStatus,
    this.editingCardId,
  });

  const CrushEditorArgs.forEdit({required String cardId})
      : price = 0,
        daysOfWage = 0,
        hoursOfWork = 0,
        pctOfMonthlyIncome = null,
        initialStatus = CrushStatus.crushing,
        editingCardId = cardId;

  final double price;
  final double daysOfWage;
  final double hoursOfWork;
  final double? pctOfMonthlyIncome;
  final CrushStatus initialStatus;
  final String? editingCardId;

  bool get isEditing => editingCardId != null;
}

class CrushEditorScreen extends ConsumerStatefulWidget {
  const CrushEditorScreen({super.key, this.args});

  final CrushEditorArgs? args;

  @override
  ConsumerState<CrushEditorScreen> createState() => _CrushEditorScreenState();
}

class _CrushEditorScreenState extends ConsumerState<CrushEditorScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePicker = ImagePicker();

  CrushCard? _loadedCard;
  CrushReason? _selectedReason;
  CrushMood? _selectedMood;
  ReminderPreset _selectedPreset = ReminderPreset.after24h;
  DateTime? _customRemindAt;
  XFile? _pickedImage;
  String? _existingImagePath;
  bool _removeExistingImage = false;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    final args = widget.args;
    if (args == null) {
      _loadFailed = true;
      return;
    }

    if (args.isEditing) {
      _isLoading = true;
      _loadCard(args.editingCardId!);
    } else {
      _priceController.text =
          AppFormatters.formatMoney(args.price).replaceAll('đ', '');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadCard(String id) async {
    final card = await ref.read(crushRepositoryProvider).getById(id);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (card == null) {
        _loadFailed = true;
        return;
      }
      _loadedCard = card;
      _existingImagePath = card.imagePath;
      _selectedReason = card.reason;
      _selectedMood = crushMoodFromName(card.mood);
      _nameController.text = card.name ?? '';
      _priceController.text =
          AppFormatters.formatMoney(card.price).replaceAll('đ', '');
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image == null || !mounted) return;
    setState(() {
      _pickedImage = image;
      _removeExistingImage = false;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
      _removeExistingImage = true;
    });
  }

  Future<DateTime?> _ensureCustomRemindAt() async {
    if (_selectedPreset != ReminderPreset.custom) return _customRemindAt;
    if (_customRemindAt != null) return _customRemindAt;

    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );
    if (time == null) return null;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => _customRemindAt = selected);
    return selected;
  }

  Future<void> _save() async {
    final args = widget.args;
    if (args == null || _isSaving) return;

    final customRemindAt = await _ensureCustomRemindAt();
    if (_selectedPreset == ReminderPreset.custom && customRemindAt == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(crushRepositoryProvider);
      final imageStorage = ref.read(imageStorageProvider);
      final now = DateTime.now();
      final isEditing = args.isEditing;
      final existing = _loadedCard;
      final cardId = existing?.id ?? const Uuid().v4();
      final oldImagePath = _existingImagePath;

      var imagePath = _removeExistingImage ? null : oldImagePath;
      if (_pickedImage != null) {
        imagePath = await imageStorage.saveCrushImage(cardId, _pickedImage!);
      }

      final paydayDay =
          ref.read(sharedPreferencesProvider).getInt('payday_day') ?? 5;
      final remindAt = RemindAtCalculator.calculate(
        preset: _selectedPreset,
        now: now,
        paydayDay: paydayDay,
        customDateTime: customRemindAt,
      );

      final parsedPrice = AppFormatters.parsePrice(_priceController.text);
      final name = _nameController.text.trim();
      final card = CrushCard(
        id: cardId,
        name: name.isEmpty ? null : name,
        price: isEditing ? (parsedPrice ?? existing!.price) : args.price,
        category: existing?.category,
        imagePath: imagePath,
        daysOfWageSnapshot:
            isEditing ? existing!.daysOfWageSnapshot : args.daysOfWage,
        hoursOfWorkSnapshot:
            isEditing ? existing!.hoursOfWorkSnapshot : args.hoursOfWork,
        pctOfMonthlyIncomeSnapshot: isEditing
            ? existing!.pctOfMonthlyIncomeSnapshot
            : args.pctOfMonthlyIncome,
        reason: _selectedReason,
        mood: _selectedMood?.name,
        note: existing?.note,
        status: isEditing ? existing!.status : args.initialStatus,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        remindAt: remindAt,
        remindCount: existing?.remindCount ?? 0,
      );

      if (isEditing) {
        await repository.updateCard(card);
      } else {
        await repository.insertCard(card);
      }

      if ((oldImagePath != null && oldImagePath != imagePath) ||
          (_removeExistingImage && oldImagePath != null)) {
        await imageStorage.deleteImage(oldImagePath);
      }

      ref.invalidate(crushCardsProvider);
      ref.invalidate(crushPendingProvider);
      ref.invalidate(crushSavedDaysProvider);

      if (mounted) {
        context.pop();
      }
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.crushEditorSaveError)),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final args = widget.args;
    final isEditing = args?.isEditing ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.crushEditorEditTitle : l10n.crushEditorNewTitle,
        ),
        actions: [
          TextButton(
            onPressed: _isSaving || _isLoading || _loadFailed ? null : _save,
            child: Text(l10n.crushEditorSave),
          ),
        ],
      ),
      body: _buildBody(context, l10n, args),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    CrushEditorArgs? args,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadFailed || args == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            args == null
                ? l10n.crushEditorMissingArgs
                : l10n.crushEditorLoadError,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final snapshot = _loadedCard == null
        ? _Snapshot(
            days: args.daysOfWage,
            hours: args.hoursOfWork,
            pct: args.pctOfMonthlyIncome,
          )
        : _Snapshot(
            days: _loadedCard!.daysOfWageSnapshot,
            hours: _loadedCard!.hoursOfWorkSnapshot,
            pct: _loadedCard!.pctOfMonthlyIncomeSnapshot,
          );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xl,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Ảnh ──────────────────────────────────
          _SectionLabel(l10n.crushEditorImageLabel),
          const SizedBox(height: AppSpacing.sm),
          _ImagePickerBlock(
            galleryLabel: l10n.crushEditorPickGallery,
            cameraLabel: l10n.crushEditorPickCamera,
            removeLabel: l10n.crushEditorRemoveImage,
            imagePath: _currentImagePath,
            onPickGallery: () => _pickImage(ImageSource.gallery),
            onPickCamera: () => _pickImage(ImageSource.camera),
            onRemove: _currentImagePath == null ? null : _removeImage,
          ),
          const SizedBox(height: AppSpacing.xxl),
          // ── Chi tiết ─────────────────────────────
          const _SectionLabel('Chi tiết'),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l10n.crushEditorNameLabel),
          ),
          const SizedBox(height: AppSpacing.base),
          TextField(
            controller: _priceController,
            enabled: args.isEditing,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.crushEditorPriceLabel,
              suffixText: l10n.onboardingCurrencySuffix,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          // ── Kết quả nhanh ────────────────────────
          _SnapshotBlock(snapshot: snapshot),
          const SizedBox(height: AppSpacing.xxl),
          // ── Lý do ────────────────────────────────
          _ReasonChips(
            title: l10n.fomoQuestion,
            selectedReason: _selectedReason,
            onSelected: (reason) => setState(() => _selectedReason = reason),
          ),
          const SizedBox(height: AppSpacing.base),
          _MoodChips(
            title: l10n.crushEditorMoodLabel,
            selectedMood: _selectedMood,
            onSelected: (mood) => setState(() => _selectedMood = mood),
          ),
          const SizedBox(height: AppSpacing.xxl),
          // ── Mốc nhắc ─────────────────────────────
          _ReminderChips(
            title: l10n.crushEditorReminderLabel,
            selectedPreset: _selectedPreset,
            onSelected: (preset) async {
              setState(() => _selectedPreset = preset);
              if (preset == ReminderPreset.custom) {
                await _ensureCustomRemindAt();
              }
            },
          ),
          const SizedBox(height: AppSpacing.xxxl),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.crushEditorSave),
          ),
        ],
      ),
    );
  }

  String? get _currentImagePath {
    if (_pickedImage != null) return _pickedImage!.path;
    if (_removeExistingImage) return null;
    return _existingImagePath;
  }
}

class _Snapshot {
  const _Snapshot({
    required this.days,
    required this.hours,
    required this.pct,
  });

  final double days;
  final double hours;
  final double? pct;
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
    );
  }
}

class _ImagePickerBlock extends StatelessWidget {
  const _ImagePickerBlock({
    required this.galleryLabel,
    required this.cameraLabel,
    required this.removeLabel,
    required this.imagePath,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemove,
  });

  final String galleryLabel;
  final String cameraLabel;
  final String removeLabel;
  final String? imagePath;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final surfaceAlt = Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceAltDark
        : AppColors.surfaceAlt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: surfaceAlt,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: imagePath == null
                ? const Center(
                    child: Icon(Icons.image_outlined, size: 44),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    child: Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image_outlined, size: 44),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: onPickGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(galleryLabel),
            ),
            OutlinedButton.icon(
              onPressed: onPickCamera,
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(cameraLabel),
            ),
            if (onRemove != null)
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: Text(removeLabel),
              ),
          ],
        ),
      ],
    );
  }
}

class _SnapshotBlock extends StatelessWidget {
  const _SnapshotBlock({required this.snapshot});

  final _Snapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surfaceAlt = Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceAltDark
        : AppColors.surfaceAlt;
    final subMetrics = <String>[];
    if (snapshot.hours > 0) {
      subMetrics
          .add(l10n.resultSubHours(AppFormatters.formatHours(snapshot.hours)));
    }
    if (snapshot.pct != null) {
      subMetrics.add(l10n.resultSubPct(AppFormatters.formatPct(snapshot.pct!)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Kết quả nhanh'),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
      decoration: BoxDecoration(
        color: surfaceAlt,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          children: [
            HeroNumberView(
              numberText: AppFormatters.formatDays(snapshot.days)
                  .replaceAll(' ngày', ''),
              unitText: l10n.resultHeroUnit,
            ),
            if (subMetrics.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subMetrics.join(' · '),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    ),
      ],
    );
  }
}

class _ReasonChips extends StatelessWidget {
  const _ReasonChips({
    required this.title,
    required this.selectedReason,
    required this.onSelected,
  });

  final String title;
  final CrushReason? selectedReason;
  final ValueChanged<CrushReason> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: CrushReason.values
              .map(
                (reason) => ChoiceChip(
                  label: Text(reason.label),
                  selected: selectedReason == reason,
                  onSelected: (_) => onSelected(reason),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MoodChips extends StatelessWidget {
  const _MoodChips({
    required this.title,
    required this.selectedMood,
    required this.onSelected,
  });

  final String title;
  final CrushMood? selectedMood;
  final ValueChanged<CrushMood> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: CrushMood.values
              .map(
                (mood) => ChoiceChip(
                  label: Text('${mood.icon} ${mood.label}'),
                  selected: selectedMood == mood,
                  onSelected: (_) => onSelected(mood),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ReminderChips extends StatelessWidget {
  const _ReminderChips({
    required this.title,
    required this.selectedPreset,
    required this.onSelected,
  });

  final String title;
  final ReminderPreset selectedPreset;
  final ValueChanged<ReminderPreset> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: ReminderPreset.values
              .map(
                (preset) => ChoiceChip(
                  label: Text(_labelFor(l10n, preset)),
                  selected: selectedPreset == preset,
                  onSelected: (_) => onSelected(preset),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  String _labelFor(AppLocalizations l10n, ReminderPreset preset) {
    switch (preset) {
      case ReminderPreset.tonight:
        return l10n.remindTonight;
      case ReminderPreset.after24h:
        return l10n.remindAfter24h;
      case ReminderPreset.after3Days:
        return l10n.remindAfter3Days;
      case ReminderPreset.after7Days:
        return l10n.remindAfter7Days;
      case ReminderPreset.untilPayday:
        return l10n.remindUntilPayday;
      case ReminderPreset.custom:
        return l10n.remindCustom;
    }
  }
}

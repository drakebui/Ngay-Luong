import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ngay_luong/core/theme/app_colors.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';
import 'package:ngay_luong/features/save_card/data/card_renderer.dart';
import 'package:ngay_luong/features/save_card/domain/save_card_template.dart';
import 'package:ngay_luong/l10n/app_localizations.dart';

class SaveCardScreen extends StatefulWidget {
  const SaveCardScreen({super.key, required this.input});

  final SaveCardInput input;

  @override
  State<SaveCardScreen> createState() => _SaveCardScreenState();
}

class _SaveCardScreenState extends State<SaveCardScreen> {
  late SaveCardTemplate _template = widget.input.defaultTemplate();
  final _boundaryKey = GlobalKey();
  final _renderer = const CardRenderer();
  bool _saving = false;

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject();
      if (boundary is! RenderRepaintBoundary) return;
      final bytes = await _renderer.capturePng(boundary);
      if (bytes == null) return;
      final path = await _renderer.writePng(bytes);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saveCardSaved(path))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.saveCardTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: RepaintBoundary(
                      key: _boundaryKey,
                      child: _CardCanvas(
                        template: _template,
                        input: widget.input,
                        l10n: l10n,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _TemplatePicker(
              available: widget.input.availableTemplates(),
              current: _template,
              onPick: (t) => setState(() => _template = t),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: _saving ? null : _save,
                  label: Text(l10n.cardSave),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
          ],
        ),
      ),
    );
  }
}

class _TemplatePicker extends StatelessWidget {
  const _TemplatePicker({
    required this.available,
    required this.current,
    required this.onPick,
  });

  final List<SaveCardTemplate> available;
  final SaveCardTemplate current;
  final ValueChanged<SaveCardTemplate> onPick;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        children: available
            .map(
              (t) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(_label(context, t)),
                  selected: current == t,
                  onSelected: (_) => onPick(t),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _label(BuildContext context, SaveCardTemplate t) {
    final l10n = AppLocalizations.of(context)!;
    switch (t) {
      case SaveCardTemplate.sleepOnIt:
        return l10n.saveCardTemplateSleepOnIt;
      case SaveCardTemplate.onSale:
        return l10n.saveCardTemplateOnSale;
      case SaveCardTemplate.skipped:
        return l10n.saveCardTemplateSkipped;
    }
  }
}

class _CardCanvas extends StatelessWidget {
  const _CardCanvas({
    required this.template,
    required this.input,
    required this.l10n,
  });

  final SaveCardTemplate template;
  final SaveCardInput input;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final daysText = AppFormatters.formatDays(input.days).replaceAll(' ngày', '');
    final body = _bodyText(daysText);
    final bg = _backgroundColor(template);
    final fg = _foregroundColor(template);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NGÀY LƯƠNG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: fg.withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          Text(
            daysText,
            style: TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w800,
              height: 1.0,
              color: fg,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ngày đi làm',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: fg.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            body,
            style: TextStyle(
              fontSize: 18,
              height: 1.4,
              color: fg,
            ),
          ),
          const Spacer(),
          Text(
            'ngayluong.app',
            style: TextStyle(
              fontSize: 11,
              color: fg.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  String _bodyText(String daysText) {
    switch (template) {
      case SaveCardTemplate.sleepOnIt:
        return l10n.cardSleepOnIt(daysText);
      case SaveCardTemplate.onSale:
        final pct = input.percentOff ?? 50;
        final pctText = pct >= 10
            ? pct.round().toString()
            : pct.toStringAsFixed(1).replaceAll('.', ',');
        return l10n.cardOnSale(pctText, daysText);
      case SaveCardTemplate.skipped:
        return l10n.cardSkipped(daysText);
    }
  }

  Color _backgroundColor(SaveCardTemplate t) {
    switch (t) {
      case SaveCardTemplate.sleepOnIt:
        return AppColors.accent;
      case SaveCardTemplate.onSale:
        return AppColors.surfaceAltDark;
      case SaveCardTemplate.skipped:
        return AppColors.positive;
    }
  }

  Color _foregroundColor(SaveCardTemplate t) {
    switch (t) {
      case SaveCardTemplate.sleepOnIt:
      case SaveCardTemplate.onSale:
      case SaveCardTemplate.skipped:
        return Colors.white;
    }
  }
}

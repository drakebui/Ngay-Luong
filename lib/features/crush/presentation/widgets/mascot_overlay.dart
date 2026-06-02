import 'package:flutter/material.dart';
import 'package:ngay_luong/core/theme/app_spacing.dart';
import 'package:ngay_luong/core/utils/formatters.dart';

String mascotOverlayCopy({required double days, required bool isSurvived}) {
  if (isSurvived) return 'Tôi sống rồi.';
  final dayText = AppFormatters.formatDays(days).replaceAll(' ngày', '');
  return 'Tôi vừa thấy $dayText ngày lương bay qua cửa sổ.';
}

void showMascotOverlay(
  BuildContext context, {
  required double days,
  required bool isSurvived,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2500),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Text('🪙', style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              mascotOverlayCopy(days: days, isSurvived: isSurvived),
            ),
          ),
        ],
      ),
    ),
  );
}

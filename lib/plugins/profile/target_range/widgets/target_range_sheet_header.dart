import 'package:flutter/material.dart';

import '../../../../../foundation/theme/app_colors.dart';
import '../../application/i18n/profile_l10n.dart';

class TargetRangeSheetHeader extends StatelessWidget {
  final VoidCallback onReset;

  const TargetRangeSheetHeader({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.targetRangeSheetTitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.targetRangeSheetSubtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
        _ResetButton(label: l10n.targetRangeReset, onTap: onReset),
      ],
    );
  }
}

class _ResetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ResetButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.bgCard2,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.refresh_rounded,
              size: 13,
              color: AppColors.textSoft,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

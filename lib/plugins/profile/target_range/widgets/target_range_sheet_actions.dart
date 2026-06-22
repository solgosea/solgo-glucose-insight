import 'package:flutter/material.dart';

import '../../../../../foundation/theme/app_colors.dart';
import '../../application/i18n/profile_l10n.dart';

class TargetRangeSheetActions extends StatelessWidget {
  final bool canSave;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const TargetRangeSheetActions({
    super.key,
    required this.canSave,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    return Row(
      children: [
        Expanded(
          child: _SheetButton(
            label: l10n.targetRangeCancel,
            onTap: onCancel,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SheetButton(
            label: l10n.targetRangeSaveRange,
            primary: true,
            enabled: canSave,
            onTap: onSave,
          ),
        ),
      ],
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  final bool enabled;

  const _SheetButton({
    required this.label,
    required this.onTap,
    this.primary = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: primary
              ? (enabled ? AppColors.green : AppColors.green.withOpacity(0.35))
              : AppColors.bgCard2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: primary ? Colors.transparent : AppColors.borderMid,
          ),
          boxShadow: primary && enabled
              ? [
                  BoxShadow(
                    color: AppColors.green.withOpacity(0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: primary ? AppColors.bg : AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}

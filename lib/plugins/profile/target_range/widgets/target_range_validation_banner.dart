import 'package:flutter/material.dart';

import '../../../../../foundation/theme/app_colors.dart';
import '../../application/i18n/profile_l10n.dart';
import '../editing/target_range_validation_result.dart';

class TargetRangeValidationBanner extends StatelessWidget {
  final TargetRangeValidationResult validation;

  const TargetRangeValidationBanner({
    super.key,
    required this.validation,
  });

  @override
  Widget build(BuildContext context) {
    if (validation.isValid) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.rose.withOpacity(0.08),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.rose.withOpacity(0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: AppColors.rose,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _message(context),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                height: 1.45,
                color: AppColors.rose,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _message(BuildContext context) {
    final reason = validation.reason;
    final l10n = context.profileL10n;
    return switch (reason) {
      TargetRangeValidationReason.lowTooCloseToHigh =>
        l10n.targetRangeLowHighGapMessage(
          validation.gapLabel,
          validation.unitLabel,
        ),
      TargetRangeValidationReason.highTooCloseToVeryHigh =>
        l10n.targetRangeHighVeryHighGapMessage(
          validation.gapLabel,
          validation.unitLabel,
        ),
      null => validation.message,
    };
  }
}

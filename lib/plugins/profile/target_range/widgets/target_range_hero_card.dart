import 'package:flutter/material.dart';

import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../../application/i18n/profile_l10n.dart';
import '../target_range_value_policy.dart';

class TargetRangeHeroCard extends StatelessWidget {
  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final GlucoseUnitFormatService formatter;

  const TargetRangeHeroCard({
    super.key,
    required this.draft,
    required this.unit,
    this.formatter = const GlucoseUnitFormatService(),
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    final range = formatter.range(draft.lowMmol, draft.highMmol, unit);
    final spread = formatter.value(draft.highMmol - draft.lowMmol, unit);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.green.withOpacity(0.06),
            AppColors.green.withOpacity(0.13),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.green.withOpacity(0.30),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.targetRangeInRangeTarget,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ValueText(range.lowLabel),
                      Container(
                        width: 12,
                        height: 1.5,
                        margin: const EdgeInsets.fromLTRB(6, 0, 6, 12),
                        color: AppColors.textSoft,
                      ),
                      _ValueText(range.highLabel),
                      const SizedBox(width: 7),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          range.unitLabel,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.green.withOpacity(0.40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  spread.valueLabel,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.targetRangeSpread,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green.withOpacity(0.75),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  final String value;

  const _ValueText(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1,
      ),
    );
  }
}

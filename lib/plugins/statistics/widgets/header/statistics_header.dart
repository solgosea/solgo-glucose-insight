import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/date_filter/widgets/date_filter_icon_button.dart';
import '../../application/i18n/statistics_l10n.dart';

class StatisticsHeader extends StatelessWidget {
  final String dateLabel;
  final VoidCallback onDateFilterPressed;

  const StatisticsHeader({
    super.key,
    required this.dateLabel,
    required this.onDateFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statisticsL10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.pageTitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
              letterSpacing: -0.4,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.22),
                  ),
                ),
                child: Text(
                  dateLabel,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DateFilterIconButton(
                onPressed: onDateFilterPressed,
                tooltip: l10n.dateFilterTooltip,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

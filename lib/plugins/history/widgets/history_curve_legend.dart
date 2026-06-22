import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../application/i18n/history_l10n.dart';

class HistoryCurveLegend extends StatelessWidget {
  const HistoryCurveLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.historyL10n;
    return Row(
      children: [
        _LegendDot(AppColors.green, l10n.legendInRange),
        const SizedBox(width: 10),
        _LegendDot(AppColors.rose, l10n.legendHigh),
        const SizedBox(width: 10),
        _LegendDot(AppColors.blue, l10n.legendLow),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: AppColors.textDim,
          ),
        ),
      ],
    );
  }
}

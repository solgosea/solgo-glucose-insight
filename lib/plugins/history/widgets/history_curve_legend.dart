import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class HistoryCurveLegend extends StatelessWidget {
  const HistoryCurveLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _LegendDot(AppColors.green, 'In range'),
        SizedBox(width: 10),
        _LegendDot(AppColors.rose, 'High'),
        SizedBox(width: 10),
        _LegendDot(AppColors.blue, 'Low'),
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

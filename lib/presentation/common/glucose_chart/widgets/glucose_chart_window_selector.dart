import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/glucose_chart_window_option.dart';

class GlucoseChartWindowSelector extends StatelessWidget {
  final List<GlucoseChartWindowOption> options;
  final ValueChanged<String> onChanged;

  const GlucoseChartWindowSelector({
    super.key,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.end,
        runAlignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final option in options)
            _WindowChip(
              option: option,
              onTap: () => onChanged(option.id),
            ),
        ],
      ),
    );
  }
}

class _WindowChip extends StatelessWidget {
  final GlucoseChartWindowOption option;
  final VoidCallback onTap;

  const _WindowChip({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.selected ? null : onTap,
      borderRadius: BorderRadius.circular(999),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: option.selected
              ? AppColors.green.withValues(alpha: .12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: option.selected ? AppColors.green : AppColors.borderMid,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            option.label,
            style: TextStyle(
              color: option.selected ? AppColors.green : AppColors.textDim,
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
    );
  }
}

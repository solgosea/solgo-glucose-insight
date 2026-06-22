import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../application/i18n/home_l10n.dart';
import '../application/i18n/home_range_l10n.dart';
import '../models/home_chart_range.dart';

class HomeRangeSelector extends StatelessWidget {
  final List<HomeChartRange> ranges;
  final HomeChartRange selectedRange;
  final ValueChanged<HomeChartRange> onChanged;

  const HomeRangeSelector({
    super.key,
    required this.ranges,
    required this.selectedRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.homeL10n;
    return Row(
      children: ranges.map((range) {
        final selected = selectedRange == range;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: GestureDetector(
            onTap: () => onChanged(range),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: selected ? AppColors.bgCard2 : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.borderMid : AppColors.border,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                l10n.rangeLabel(range),
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: selected ? AppColors.green : AppColors.textSoft,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

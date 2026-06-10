import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/statistics_view_model.dart';

class StatisticsPeriodTabs extends StatelessWidget {
  final List<StatisticsPeriodOptionViewModel> periods;
  final ValueChanged<int> onChanged;

  const StatisticsPeriodTabs({
    super.key,
    required this.periods,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      child: Row(
        children: [
          for (var i = 0; i < periods.length; i++) ...[
            Expanded(
              child: _TabButton(
                label: periods[i].label,
                active: periods[i].selected,
                onTap: () => onChanged(periods[i].days),
              ),
            ),
            if (i < periods.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.bgCard2 : Colors.transparent,
          border: Border.all(
            color: active ? AppColors.borderMid : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.green : AppColors.textSoft,
            letterSpacing: 0.36,
          ),
        ),
      ),
    );
  }
}

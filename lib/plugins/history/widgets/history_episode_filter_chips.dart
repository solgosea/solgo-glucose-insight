import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';

enum HistoryEpisodeFilter {
  all,
  high,
  low,
}

class HistoryEpisodeFilterChips extends StatelessWidget {
  final HistoryEpisodeFilter selected;
  final int allCount;
  final int highCount;
  final int lowCount;
  final ValueChanged<HistoryEpisodeFilter> onSelected;
  final String allLabel;
  final String highsLabel;
  final String lowsLabel;

  const HistoryEpisodeFilterChips({
    super.key,
    required this.selected,
    required this.allCount,
    required this.highCount,
    required this.lowCount,
    required this.onSelected,
    required this.allLabel,
    required this.highsLabel,
    required this.lowsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _Chip(
            label: allLabel,
            count: allCount,
            active: selected == HistoryEpisodeFilter.all,
            onTap: () => onSelected(HistoryEpisodeFilter.all),
          ),
          const SizedBox(width: 6),
          _Chip(
            label: highsLabel,
            count: highCount,
            active: selected == HistoryEpisodeFilter.high,
            onTap: () => onSelected(HistoryEpisodeFilter.high),
          ),
          const SizedBox(width: 6),
          _Chip(
            label: lowsLabel,
            count: lowCount,
            active: selected == HistoryEpisodeFilter.low,
            onTap: () => onSelected(HistoryEpisodeFilter.low),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.green : AppColors.textSoft;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: active
                ? AppColors.green.withValues(alpha: 0.08)
                : AppColors.bgCard,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? AppColors.borderMid : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '$count',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: active ? AppColors.green : AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

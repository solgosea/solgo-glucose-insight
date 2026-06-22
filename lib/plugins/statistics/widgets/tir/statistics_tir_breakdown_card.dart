import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../../application/i18n/statistics_l10n.dart';
import '../../models/statistics_view_model.dart';
import '../shared/statistics_section_card.dart';
import 'statistics_extreme_cell.dart';
import 'statistics_legend_dot.dart';

class StatisticsTirBreakdownCard extends StatelessWidget {
  final StatisticsTirBreakdownViewModel viewModel;

  const StatisticsTirBreakdownCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticsSectionCard(
      title: context.statisticsL10n.tirBreakdownTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StackedBar(segments: viewModel.segments),
          const SizedBox(height: 9),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final item in viewModel.legends)
                StatisticsLegendDot(viewModel: item),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                for (var i = 0; i < viewModel.extremes.length; i++) ...[
                  Expanded(
                    child: StatisticsExtremeCell(
                      viewModel: viewModel.extremes[i],
                    ),
                  ),
                  if (i < viewModel.extremes.length - 1)
                    const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedBar extends StatelessWidget {
  final List<StatisticsTirSegmentViewModel> segments;

  const _StackedBar({required this.segments});

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(height: 22, color: AppColors.border),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 22,
        child: Row(
          children: [
            for (final segment in segments)
              Expanded(
                flex: (segment.fraction * 100).round().clamp(1, 100000),
                child: Container(color: segment.color),
              ),
          ],
        ),
      ),
    );
  }
}

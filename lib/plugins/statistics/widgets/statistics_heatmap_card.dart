import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/statistics_view_model.dart';
import 'statistics_section_card.dart';

class StatisticsHeatmapCard extends StatelessWidget {
  final StatisticsHeatmapViewModel viewModel;

  const StatisticsHeatmapCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StatisticsSectionCard(
      title: viewModel.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < viewModel.cells.length; i++)
                Expanded(
                  child: Container(
                    height: 30,
                    margin: EdgeInsets.only(
                      right: i == viewModel.cells.length - 1 ? 0 : 3,
                    ),
                    decoration: BoxDecoration(
                      color: viewModel.cells[i].color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in viewModel.labels) _HeatmapLabel(label),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatmapLabel extends StatelessWidget {
  final String text;

  const _HeatmapLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 10,
        color: AppColors.textDim,
      ),
    );
  }
}

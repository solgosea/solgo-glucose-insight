import 'package:flutter/material.dart';
import '../models/statistics_view_model.dart';
import 'agp/statistics_agp_card.dart';
import 'header/statistics_header.dart';
import 'heatmap/statistics_heatmap_card.dart';
import 'metrics/statistics_metric_grid.dart';
import 'metrics/statistics_metrics_header.dart';
import 'tir/statistics_tir_breakdown_card.dart';

class StatisticsBody extends StatelessWidget {
  final StatisticsViewModel viewModel;
  final VoidCallback onDateFilterPressed;

  const StatisticsBody({
    super.key,
    required this.viewModel,
    required this.onDateFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatisticsHeader(
              dateLabel: viewModel.dateFilterLabel,
              onDateFilterPressed: onDateFilterPressed,
            ),
            StatisticsMetricsHeader(text: viewModel.metricsHeader),
            StatisticsMetricGrid(metrics: viewModel.metrics),
            const SizedBox(height: 16),
            StatisticsTirBreakdownCard(viewModel: viewModel.tirBreakdown),
            StatisticsAgpCard(viewModel: viewModel.agp),
            StatisticsHeatmapCard(viewModel: viewModel.heatmap),
          ],
        ),
      ),
    );
  }
}

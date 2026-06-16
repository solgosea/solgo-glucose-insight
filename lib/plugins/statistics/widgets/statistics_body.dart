import 'package:flutter/material.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../models/statistics_view_model.dart';
import 'statistics_agp_card.dart';
import 'statistics_header.dart';
import 'statistics_heatmap_card.dart';
import 'statistics_metric_grid.dart';
import 'statistics_metrics_header.dart';
import 'statistics_period_tabs.dart';
import 'statistics_tir_breakdown_card.dart';

class StatisticsBody extends StatelessWidget {
  final StatisticsViewModel viewModel;
  final ValueChanged<StatisticsAnalysisWindowId> onPeriodChanged;

  const StatisticsBody({
    super.key,
    required this.viewModel,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StatisticsHeader(),
            StatisticsPeriodTabs(
              periods: viewModel.periodOptions,
              onChanged: onPeriodChanged,
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

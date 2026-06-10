import 'package:flutter/material.dart';
import '../models/statistics_view_model.dart';
import 'statistics_metric_card.dart';

class StatisticsMetricGrid extends StatelessWidget {
  final List<StatisticsMetricCardViewModel> metrics;

  const StatisticsMetricGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: StatisticsMetricCard(viewModel: metrics[0])),
                const SizedBox(width: 10),
                if (metrics.length > 1)
                  Expanded(child: StatisticsMetricCard(viewModel: metrics[1])),
              ],
            ),
          ),
          if (metrics.length > 2) ...[
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: StatisticsMetricCard(viewModel: metrics[2])),
                  const SizedBox(width: 10),
                  if (metrics.length > 3)
                    Expanded(
                      child: StatisticsMetricCard(viewModel: metrics[3]),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

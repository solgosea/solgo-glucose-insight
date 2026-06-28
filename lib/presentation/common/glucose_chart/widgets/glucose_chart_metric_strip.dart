import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/glucose_chart_metric_tile_view_model.dart';

class GlucoseChartMetricStrip extends StatelessWidget {
  final List<GlucoseChartMetricTileViewModel> metrics;

  const GlucoseChartMetricStrip({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        if (compact) {
          return Column(
            children: [
              for (var i = 0; i < metrics.length; i++) ...[
                _MetricTile(metric: metrics[i]),
                if (i != metrics.length - 1) const SizedBox(height: 8),
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < metrics.length; i++) ...[
              Expanded(child: _MetricTile(metric: metrics[i])),
              if (i != metrics.length - 1) const SizedBox(width: 8),
            ],
          ],
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  final GlucoseChartMetricTileViewModel metric;

  const _MetricTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgCard2.withValues(alpha: .62),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metric.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textDim,
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: .45,
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                metric.value,
                style: TextStyle(
                  color: metric.valueColor,
                  fontSize: 18,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              metric.helper,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textDim,
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

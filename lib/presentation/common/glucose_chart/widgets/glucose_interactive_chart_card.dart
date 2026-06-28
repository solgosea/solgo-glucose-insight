import 'package:flutter/material.dart';

import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../../../foundation/theme/app_colors.dart';
import '../../widgets/charts/glucose_line_chart.dart';
import '../models/glucose_chart_metric_tile_view_model.dart';
import '../models/glucose_chart_window_option.dart';
import 'glucose_chart_metric_strip.dart';
import 'glucose_chart_window_selector.dart';

class GlucoseInteractiveChartCard extends StatelessWidget {
  final String title;
  final List<GlucoseChartWindowOption> windows;
  final ValueChanged<String> onWindowChanged;
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final double chartHeight;
  final List<GlucoseChartMetricTileViewModel> metrics;
  final bool showCurrentDot;
  final ValueChanged<bool>? onInspectionChanged;
  final DateTime? timeRangeStart;
  final DateTime? timeRangeEnd;

  const GlucoseInteractiveChartCard({
    super.key,
    required this.title,
    required this.windows,
    required this.onWindowChanged,
    required this.readings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    this.chartHeight = 160,
    this.metrics = const [],
    this.showCurrentDot = true,
    this.onInspectionChanged,
    this.timeRangeStart,
    this.timeRangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDim,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GlucoseChartWindowSelector(
                      options: windows,
                      onChanged: onWindowChanged,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GlucoseLineChart(
              readings: readings,
              unit: unit,
              low: lowThreshold,
              high: highThreshold,
              height: chartHeight,
              showCurrentDot: showCurrentDot,
              enableInspection: true,
              onInspectionChanged: onInspectionChanged,
              coloringMode: ChartColoringMode.single,
              thresholdLineMode: ThresholdLineMode.subtle,
              xLabelMode: XLabelMode.hourMinute,
              xLabelCount: 5,
              timeRangeStart: timeRangeStart,
              timeRangeEnd: timeRangeEnd,
            ),
            if (metrics.isNotEmpty) ...[
              const SizedBox(height: 10),
              GlucoseChartMetricStrip(metrics: metrics),
            ],
          ],
        ),
      ),
    );
  }
}

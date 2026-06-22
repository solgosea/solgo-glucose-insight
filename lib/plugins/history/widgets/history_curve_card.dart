import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../application/i18n/history_l10n.dart';
import '../models/history_view_model.dart';
import 'history_curve_legend.dart';

class HistoryCurveCard extends StatefulWidget {
  final HistoryCurveViewModel viewModel;
  final ValueChanged<DateTime> onTimeSelected;

  const HistoryCurveCard({
    super.key,
    required this.viewModel,
    required this.onTimeSelected,
  });

  @override
  State<HistoryCurveCard> createState() => _HistoryCurveCardState();
}

class _HistoryCurveCardState extends State<HistoryCurveCard> {
  bool _inspecting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderMid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.historyL10n.curveTitle,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSoft,
                    letterSpacing: 1.2,
                  ),
                ),
                AnimatedOpacity(
                  opacity: _inspecting ? 0.42 : 1,
                  duration: const Duration(milliseconds: 140),
                  child: const HistoryCurveLegend(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 6),
            child: GlucoseLineChart(
              readings: widget.viewModel.readings,
              unit: widget.viewModel.unit,
              low: widget.viewModel.lowThreshold,
              high: widget.viewModel.highThreshold,
              timeRangeStart: widget.viewModel.timeRangeStart,
              timeRangeEnd: widget.viewModel.timeRangeEnd,
              height: 180,
              showCurrentDot: false,
              enableInspection: true,
              onInspectionPointChanged: (point) {
                if (point == null) return;
                widget.onTimeSelected(point.reading.timestamp);
              },
              onInspectionChanged: (value) {
                if (_inspecting == value || !mounted) return;
                setState(() => _inspecting = value);
              },
              coloringMode: ChartColoringMode.byEpisode,
              thresholdLineMode: ThresholdLineMode.colored,
              xLabelMode: XLabelMode.hourOnly,
              xLabelCount: 7,
              showMidYLabel: true,
              episodes: widget.viewModel.episodes,
              markers: widget.viewModel.markers,
            ),
          ),
        ],
      ),
    );
  }
}

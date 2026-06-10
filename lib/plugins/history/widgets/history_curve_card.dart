import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../models/history_view_model.dart';
import 'history_curve_legend.dart';

class HistoryCurveCard extends StatelessWidget {
  final HistoryCurveViewModel viewModel;

  const HistoryCurveCard({super.key, required this.viewModel});

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
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '24-HOUR CURVE',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSoft,
                    letterSpacing: 1.2,
                  ),
                ),
                HistoryCurveLegend(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 6),
            child: GlucoseLineChart(
              readings: viewModel.readings,
              unit: viewModel.unit,
              low: viewModel.lowThreshold,
              high: viewModel.highThreshold,
              height: 180,
              showCurrentDot: false,
              coloringMode: ChartColoringMode.byEpisode,
              thresholdLineMode: ThresholdLineMode.colored,
              xLabelMode: XLabelMode.hourOnly,
              xLabelCount: 7,
              showMidYLabel: true,
              episodes: viewModel.episodes,
              markers: viewModel.markers,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';
import 'home_range_selector.dart';

class HomeRangeChartCard extends StatelessWidget {
  final HomeViewModel viewModel;
  final ValueChanged<HomeChartRange> onRangeChanged;

  const HomeRangeChartCard({
    super.key,
    required this.viewModel,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.selectedRange.title,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  letterSpacing: 1.4,
                  color: AppColors.textDim,
                ),
              ),
              HomeRangeSelector(
                ranges: viewModel.availableRanges,
                selectedRange: viewModel.selectedRange,
                onChanged: onRangeChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          GlucoseLineChart(
            readings: viewModel.chartReadings,
            unit: viewModel.unit,
            low: viewModel.lowThreshold,
            high: viewModel.highThreshold,
            height: 160,
            showCurrentDot: true,
            coloringMode: ChartColoringMode.single,
            thresholdLineMode: ThresholdLineMode.subtle,
            xLabelMode: XLabelMode.hourMinute,
            xLabelCount: 5,
          ),
        ],
      ),
    );
  }
}

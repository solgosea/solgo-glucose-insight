import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../application/i18n/home_l10n.dart';
import '../application/i18n/home_range_l10n.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';
import 'home_range_selector.dart';
import 'home_realtime_glucose_chart.dart';

class HomeRangeChartCard extends StatelessWidget {
  final HomeViewModel viewModel;
  final ValueChanged<HomeChartRange> onRangeChanged;
  final ValueChanged<bool> onInspectionChanged;

  const HomeRangeChartCard({
    super.key,
    required this.viewModel,
    required this.onRangeChanged,
    required this.onInspectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.homeL10n;
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
                l10n.rangeTitle(viewModel.selectedRange),
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
          HomeRealtimeGlucoseChart(
            viewModel: viewModel,
            onInspectionChanged: onInspectionChanged,
          ),
        ],
      ),
    );
  }
}

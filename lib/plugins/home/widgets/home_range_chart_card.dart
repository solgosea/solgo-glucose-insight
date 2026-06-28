import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/glucose_chart/models/glucose_chart_window_option.dart';
import 'package:smart_xdrip/presentation/common/glucose_chart/widgets/glucose_interactive_chart_card.dart';
import '../application/i18n/home_l10n.dart';
import '../application/i18n/home_range_l10n.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';

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
    return GlucoseInteractiveChartCard(
      title: l10n.rangeTitle(viewModel.selectedRange),
      windows: [
        for (final range in viewModel.availableRanges)
          GlucoseChartWindowOption(
            id: range.name,
            label: l10n.rangeLabel(range),
            selected: range == viewModel.selectedRange,
          ),
      ],
      onWindowChanged: (id) {
        final range = viewModel.availableRanges.firstWhere(
          (candidate) => candidate.name == id,
          orElse: () => viewModel.selectedRange,
        );
        onRangeChanged(range);
      },
      readings: viewModel.chartReadings,
      unit: viewModel.unit,
      lowThreshold: viewModel.lowThreshold,
      highThreshold: viewModel.highThreshold,
      chartHeight: 160,
      metrics: const [],
      showCurrentDot: true,
      onInspectionChanged: onInspectionChanged,
    );
  }
}

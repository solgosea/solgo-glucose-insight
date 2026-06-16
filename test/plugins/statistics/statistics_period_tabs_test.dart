import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';
import 'package:smart_xdrip/plugins/statistics/models/statistics_view_model.dart';
import 'package:smart_xdrip/plugins/statistics/widgets/statistics_period_tabs.dart';

void main() {
  testWidgets('statistics period tabs emit selected window id', (tester) async {
    StatisticsAnalysisWindowId? selected;
    final periods = StatisticsAnalysisWindowCatalog.all
        .map(
          (window) => StatisticsPeriodOptionViewModel(
            id: window.id,
            label: window.label,
            selected: window.id == StatisticsAnalysisWindowId.last14Days,
          ),
        )
        .toList();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatisticsPeriodTabs(
            periods: periods,
            onChanged: (id) => selected = id,
          ),
        ),
      ),
    );

    await tester.tap(find.text('24h'));

    expect(selected, StatisticsAnalysisWindowId.last24Hours);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/statistics/application/statistics_period_query.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';
import 'package:smart_xdrip/plugins/statistics/models/statistics_view_model.dart';
import 'package:smart_xdrip/plugins/statistics/runtime/statistics_runtime_cache.dart';

void main() {
  test('statistics runtime cache keys snapshots by subject and window id', () {
    final cache = StatisticsRuntimeCache();
    const viewModel = StatisticsViewModel(
      selectedWindowId: StatisticsAnalysisWindowId.last24Hours,
      periodOptions: [],
      metricsHeader: 'KEY METRICS - LAST 24 HOURS',
      metrics: [],
      tirBreakdown: StatisticsTirBreakdownViewModel(
        segments: [],
        legends: [],
        extremes: [],
      ),
      agp: StatisticsAgpViewModel(
        title: 'AGP',
        slots: [],
        unit: GlucoseUnit.mmolL,
        lowThreshold: 3.9,
        highThreshold: 10,
        annotations: [],
        note: '',
      ),
      heatmap: StatisticsHeatmapViewModel(
        title: 'Heatmap',
        cells: [],
        labels: [],
      ),
    );

    cache.put(
      StatisticsRuntimeSnapshot(
        query: const StatisticsPeriodQuery(
          subjectId: 'self',
          windowId: StatisticsAnalysisWindowId.last24Hours,
        ),
        viewModel: viewModel,
        updatedAt: DateTime(2026),
      ),
    );

    expect(
      cache.freshViewModel(
        subjectId: 'self',
        windowId: StatisticsAnalysisWindowId.last24Hours,
      ),
      same(viewModel),
    );
    expect(
      cache.freshViewModel(
        subjectId: 'self',
        windowId: StatisticsAnalysisWindowId.last14Days,
      ),
      isNull,
    );
  });
}

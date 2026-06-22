import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/home/mappers/home_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/home/l10n/generated/home_localizations_zh.dart';
import 'package:smart_xdrip/plugins/home/models/home_chart_range.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';

void main() {
  tearDown(() => AnalysisSessionStore.instance.clear());

  test('home CV card uses the same 24h window as avg and TIR', () {
    final now = DateTime(2026, 6, 14, 10);
    final readings = [
      GlucoseReading(
          timestamp: now.subtract(const Duration(days: 2)), value: 2),
      GlucoseReading(
        timestamp: now.subtract(const Duration(days: 2, minutes: -5)),
        value: 18,
      ),
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 2)), value: 7),
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 1)), value: 7),
      GlucoseReading(timestamp: now, value: 7),
    ];

    AnalysisSessionStore.instance.update(
      AnalysisRefreshResult(
        snapshot: AnalysisSnapshot(
          generatedAt: now,
          windowStart: readings.first.timestamp,
          windowEnd: now,
          readings: readings,
          dailySummaries: const [],
          periodSummaries: const [],
          events: const [],
        ),
        insights: const [],
      ),
    );

    final viewModel = const HomeViewModelMapper().map(
      facade: AnalysisFacade.current(),
      selectedRange: HomeChartRange.twentyFourHours,
      syncStatus: const SyncStatusViewModel(
        label: 'Synced',
        semanticLabel: 'Synced',
        color: Colors.green,
        pulsing: false,
      ),
    );

    final cv =
        viewModel.stats.firstWhere((stat) => stat.label.startsWith('CV'));

    expect(cv.label, 'CV 24h');
    expect(cv.value, '0%');
  });

  test('home mapper emits localized stat and TIR labels', () {
    final now = DateTime(2026, 6, 14, 10);
    final readings = [
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 2)), value: 7),
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 1)), value: 8),
      GlucoseReading(timestamp: now, value: 9),
    ];

    AnalysisSessionStore.instance.update(
      AnalysisRefreshResult(
        snapshot: AnalysisSnapshot(
          generatedAt: now,
          windowStart: readings.first.timestamp,
          windowEnd: now,
          readings: readings,
          dailySummaries: const [],
          periodSummaries: const [],
          events: const [],
        ),
        insights: const [],
      ),
    );

    final viewModel = const HomeViewModelMapper().map(
      facade: AnalysisFacade.current(),
      selectedRange: HomeChartRange.fourHours,
      syncStatus: const SyncStatusViewModel(
        label: 'Synced',
        semanticLabel: 'Synced',
        color: Colors.green,
        pulsing: false,
      ),
      l10n: HomeLocalizationsZh(),
    );

    expect(viewModel.stats.first.label, '平均 24h');
    expect(viewModel.tir.footer, contains('过去 24 小时'));
    expect(viewModel.tir.rows.map((row) => row.label), contains('目标范围内'));
  });
}

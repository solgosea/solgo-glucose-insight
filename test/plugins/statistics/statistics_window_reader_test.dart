import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/statistics/application/statistics_window_reader.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';

void main() {
  tearDown(() => AnalysisSessionStore.instance.clear());

  test('window reader separates current and previous 24h readings', () {
    final now = DateTime(2026, 6, 14, 12);
    final readings = [
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 48)), value: 5),
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 30)), value: 6),
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 23)), value: 7),
      GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 1)), value: 8),
      GlucoseReading(timestamp: now, value: 9),
    ];
    AnalysisSessionStore.instance.update(
      AnalysisRefreshResult(
        snapshot: AnalysisSnapshot(
          generatedAt: now,
          windowStart: readings.first.timestamp,
          windowEnd: readings.last.timestamp,
          readings: readings,
          dailySummaries: const [],
          periodSummaries: const [],
          events: const [],
        ),
        insights: const [],
      ),
    );

    const reader = StatisticsWindowReader();
    final window = StatisticsAnalysisWindowCatalog.byId(
      StatisticsAnalysisWindowId.last24Hours,
    );

    expect(
      reader
          .readingsForWindow(AnalysisFacade.current(), window)
          .map((reading) => reading.value),
      [7, 8, 9],
    );
    expect(
      reader
          .previousReadingsForWindow(AnalysisFacade.current(), window)
          .map((reading) => reading.value),
      [5, 6],
    );
  });
}

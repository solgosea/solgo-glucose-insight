import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/analysis/daily_glucose_summary.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/mappers/profile_view_model_mapper.dart';

void main() {
  group('ProfileViewModelMapper', () {
    tearDown(() => AnalysisSessionStore.instance.clear());

    test('formats profile glucose metrics with selected unit', () {
      final now = DateTime(2026, 6, 4, 12);
      AnalysisSessionStore.instance.update(
        AnalysisRefreshResult(
          snapshot: AnalysisSnapshot(
            generatedAt: now,
            windowStart: now.subtract(const Duration(days: 5)),
            windowEnd: now,
            readings: const [],
            dailySummaries: [
              for (var i = 0; i < 5; i++)
                DailyGlucoseSummary(
                  day: DateTime(2026, 6, 4).subtract(Duration(days: i)),
                  readingCount: 288,
                  tir: 78.0 + i,
                  tar: 18.0,
                  tbr: 4.0,
                  mean: 6.0 + i * 0.1,
                  cv: 28.0 + i,
                  minValue: 3.8,
                  maxValue: 9.8 + i * 0.2,
                  firstReadingValue: 5.4 + i * 0.1,
                ),
            ],
            periodSummaries: const [],
            events: const [],
          ),
          insights: const [],
        ),
        settings: const AppSettings(unit: GlucoseUnit.mgDl),
      );

      final viewModel = const ProfileViewModelMapper().map(
        facade: AnalysisFacade.current(),
        settings: const AppSettings(unit: GlucoseUnit.mgDl),
      );
      final average = viewModel.stats.singleWhere(
        (stat) => stat.label == 'Avg 14d',
      );

      expect(average.value, isNot(contains('mg/dL')));
      expect(average.unit, 'mg/dL');
    });
  });
}

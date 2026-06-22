import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/statistics/application/statistics_host_services.dart';
import 'package:smart_xdrip/plugins/statistics/application/statistics_service.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';
import 'package:smart_xdrip/plugins/statistics/l10n/generated/statistics_localizations_zh.dart';
import 'package:smart_xdrip/plugins/statistics/mappers/statistics_view_model_mapper.dart';

void main() {
  tearDown(() {
    AnalysisSessionStore.instance.clear();
  });

  test('AGP note renders actual calculated facts instead of sample copy', () {
    final now = DateTime(2026, 6, 10, 23);
    final readings = _readings(now);
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
      settings: const AppSettings(),
    );

    final output = StatisticsService(hostServices: _hostServices()).load(
      windowId: StatisticsAnalysisWindowId.last14Days,
    );
    final viewModel = const StatisticsViewModelMapper().map(output);

    expect(viewModel.agp.note, contains('04:00-07:00'));
    expect(viewModel.agp.note, contains('14 of 14 observed days'));
    expect(viewModel.agp.note, contains('1.6 mmol/L'));
    expect(viewModel.agp.note, contains('around 13:00'));
    expect(viewModel.agp.note, isNot(contains('1.8 mmol/L')));
  });

  test('AGP note and metric header follow Chinese locale', () {
    final now = DateTime(2026, 6, 10, 23);
    final readings = _readings(now);
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
      settings: const AppSettings(),
    );

    final output = StatisticsService(hostServices: _hostServices()).load(
      windowId: StatisticsAnalysisWindowId.last14Days,
    );
    final viewModel = const StatisticsViewModelMapper().map(
      output,
      l10n: StatisticsLocalizationsZh(),
    );

    expect(
        viewModel.periodOptions.map((option) => option.label), contains('14天'));
    expect(viewModel.metricsHeader, '关键指标 - 过去 14 天');
    expect(viewModel.metrics.first.label, '目标范围时间');
    expect(viewModel.agp.title, contains('14天'));
    expect(viewModel.agp.note, contains('黎明前上升'));
    expect(viewModel.agp.note, contains('14 个观察日中有 14 天'));
    expect(viewModel.agp.note, contains('中位曲线'));
  });
}

StatisticsHostServices _hostServices() {
  return StatisticsHostServices(
    changeSignal: _NoopListenable(),
    facadeProvider: AnalysisFacade.current,
    settingsProvider: () => AnalysisSessionStore.instance.settings,
  );
}

class _NoopListenable extends Listenable {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

List<GlucoseReading> _readings(DateTime now) {
  final start =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 13));
  final rows = <GlucoseReading>[];
  for (var day = 0; day < 14; day++) {
    final dayStart = start.add(Duration(days: day));
    for (var hour = 0; hour < 24; hour++) {
      rows.add(
        GlucoseReading(
          timestamp: dayStart.add(Duration(hours: hour)),
          value: _valueForHour(hour),
        ),
      );
    }
    rows.addAll([
      GlucoseReading(
        timestamp: dayStart.add(const Duration(hours: 4, minutes: 30)),
        value: 5.2,
      ),
      GlucoseReading(
        timestamp: dayStart.add(const Duration(hours: 5, minutes: 30)),
        value: 6.0,
      ),
      GlucoseReading(
        timestamp: dayStart.add(const Duration(hours: 6, minutes: 30)),
        value: 6.8,
      ),
    ]);
  }
  rows.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return rows;
}

double _valueForHour(int hour) {
  if (hour == 4) return 5.2;
  if (hour == 5) return 6.0;
  if (hour == 6) return 6.8;
  if (hour == 13) return 9.4;
  if (hour >= 6 && hour < 12) return 7.0 + (hour - 6) * 0.15;
  if (hour >= 12 && hour < 18) return 8.0 + (hour - 12) * 0.1;
  return 6.4;
}

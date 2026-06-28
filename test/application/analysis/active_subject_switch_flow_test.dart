import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_engine.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_window.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugins/explore/report/application/report_service.dart';
import 'package:smart_xdrip/plugins/explore/report/controllers/report_controller.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_period.dart';
import 'package:smart_xdrip/plugins/home/mappers/home_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/home/models/home_chart_range.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';

import '../../_support/test_database.dart';

void main() {
  tearDown(() => AnalysisSessionStore.instance.clear());

  test('active subject switch changes facade, home and report data', () async {
    final database = TestDatabase.create();
    addTearDown(database.close);
    final store = AnalysisSessionStore.instance;
    const settings = AppSettings();
    final now = DateTime(2026, 6, 6, 12);
    const child = AnalysisSubject(
      id: 'child_subject',
      displayName: 'Child',
      sourceLabel: 'Remote Nightscout',
      origin: AnalysisSubjectOrigin('remote'),
    );
    final window = AnalysisWindow(
      start: now.subtract(const Duration(hours: 8)),
      end: now.add(const Duration(minutes: 1)),
      label: 'test',
    );

    await database.upsertMany(_rows(now, value: 6.0));
    await database.upsertMany(_rows(now, value: 10.0), subjectId: child.id);

    final engine = AnalysisEngine(database: database);
    final selfSnapshot = await engine.runWindow(
      settings: settings,
      window: window,
    );
    store.update(
      AnalysisRefreshResult(snapshot: selfSnapshot, insights: const []),
      settings: settings,
    );
    expect(AnalysisFacade.current().latestReading?.value, 6.0);

    final childSnapshot = await engine.runWindow(
      settings: settings,
      window: window,
      subjectId: child.id,
    );
    store.update(
      AnalysisRefreshResult(
        snapshot: childSnapshot,
        insights: const [],
        subjectId: child.id,
      ),
      settings: settings,
      subject: child,
    );

    final facade = AnalysisFacade.current();
    final home = const HomeViewModelMapper().map(
      facade: facade,
      selectedRange: HomeChartRange.eightHours,
      syncStatus: const SyncStatusViewModel(
        label: 'Synced',
        semanticLabel: 'Synced',
        color: AppColors.green,
        pulsing: false,
      ),
    );
    final report = const ReportService().buildViewModel(
      readings: facade.readingsForLastDays(14, now: now),
      settings: settings,
      period: ReportPeriod.days14,
      sections: ReportController.defaultSections,
      generatedAt: now,
    );

    expect(facade.activeSubject.id, child.id);
    expect(facade.latestReading?.value, 10.0);
    expect(facade.readings.every((reading) => reading.value == 10.0), isTrue);
    expect(home.activeSubject.id, child.id);
    expect(
        home.chartReadings.every((reading) => reading.value == 10.0), isTrue);
    expect(report.hasData, isTrue);
    expect(
      report.metrics.firstWhere((metric) => metric.label == 'Avg').value,
      '10.0',
    );
  });

  test('analysis window anchors to active subject latest reading', () async {
    final database = TestDatabase.create();
    addTearDown(database.close);
    final store = AnalysisSessionStore.instance;
    const settings = AppSettings();
    const child = AnalysisSubject(
      id: 'remote_child_stale',
      displayName: 'Child',
      sourceLabel: 'Remote Nightscout',
      origin: AnalysisSubjectOrigin('remote'),
    );
    final childAnchor = DateTime(2025, 12, 10, 12);

    await database.upsertMany(
      _rows(childAnchor, value: 9.4),
      subjectId: child.id,
    );

    final snapshot = await AnalysisEngine(database: database).runWindow(
      settings: settings,
      subjectId: child.id,
    );
    store.update(
      AnalysisRefreshResult(
        snapshot: snapshot,
        insights: const [],
        subjectId: child.id,
      ),
      settings: settings,
      subject: child,
    );

    final facade = AnalysisFacade.current();
    final home = const HomeViewModelMapper().map(
      facade: facade,
      selectedRange: HomeChartRange.eightHours,
      syncStatus: const SyncStatusViewModel(
        label: 'Synced',
        semanticLabel: 'Synced',
        color: AppColors.green,
        pulsing: false,
      ),
    );

    expect(facade.activeSubject.id, child.id);
    expect(facade.readings, isNotEmpty);
    expect(facade.latestReading?.value, 9.4);
    expect(home.chartReadings, isNotEmpty);
    expect(home.glucose.value, '9.4');
  });
}

List<GlucoseReading> _rows(DateTime now, {required double value}) {
  return [
    for (var i = 95; i >= 0; i--)
      GlucoseReading(
        timestamp: now.subtract(Duration(minutes: i * 5)),
        value: value,
      ),
  ];
}

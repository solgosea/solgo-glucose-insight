import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugins/explore/report/application/report_default_sections.dart';
import 'package:smart_xdrip/plugins/explore/report/application/report_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_period.dart';
import 'package:smart_xdrip/plugins/explore/report/runtime/report_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/explore/report/runtime/report_runtime_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(_resetStore);

  test('report runtime preheats a report snapshot on resume', () async {
    _seedAnalysisStore(subject: ActiveSubjectDefaults.self);
    final cache = ReportRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    manager.register(
      ReportPluginRuntime(
        cache: cache,
        preheater: const ReportSnapshotPreheater(
          facadeProvider: AnalysisFacade.current,
        ),
      ),
    );

    await manager.resume(ReportPluginRuntime.id);

    final snapshot = cache.freshSnapshot(
      subjectId: ActiveSubjectDefaults.self.id,
      period: ReportPeriod.days30,
      sections: ReportDefaultSections.values,
    );
    expect(cache.stale, isFalse);
    expect(snapshot, isNotNull);
    expect(snapshot!.subjectId, ActiveSubjectDefaults.self.id);
    expect(snapshot.viewModel.hasData, isTrue);
  });

  test('report runtime refreshes cache when data changes', () async {
    _seedAnalysisStore(subject: ActiveSubjectDefaults.self);
    final cache = ReportRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    manager.register(
      ReportPluginRuntime(
        cache: cache,
        preheater: const ReportSnapshotPreheater(
          facadeProvider: AnalysisFacade.current,
        ),
      ),
    );
    await manager.resume(ReportPluginRuntime.id);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.subjectDataChanged,
        occurredAt: DateTime(2026, 6, 6, 12, 1),
      ),
    );
    await pumpEventQueue();

    final refreshed = cache.freshSnapshot(
      subjectId: ActiveSubjectDefaults.self.id,
      period: ReportPeriod.days30,
      sections: ReportDefaultSections.values,
    );
    expect(cache.stale, isFalse);
    expect(refreshed, isNotNull);
    expect(refreshed!.reason, PluginRuntimeEventType.subjectDataChanged.name);
  });

  test('report runtime refreshes cache after active subject changes', () async {
    _seedAnalysisStore(subject: ActiveSubjectDefaults.self);
    final cache = ReportRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    manager.register(
      ReportPluginRuntime(
        cache: cache,
        preheater: const ReportSnapshotPreheater(
          facadeProvider: AnalysisFacade.current,
        ),
      ),
    );
    await manager.resume(ReportPluginRuntime.id);

    const child = AnalysisSubject(
      id: 'remote:report-child',
      displayName: 'Report Child',
      sourceLabel: 'Remote Nightscout',
      origin: AnalysisSubjectOrigin('remote'),
    );
    _seedAnalysisStore(
      subject: child,
      now: DateTime(2026, 6, 6, 12, 5),
    );
    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.activeSubjectChanged,
        occurredAt: DateTime(2026, 6, 6, 12, 6),
        payload: {'subjectId': child.id},
      ),
    );
    await pumpEventQueue();

    final childSnapshot = cache.freshSnapshot(
      subjectId: child.id,
      period: ReportPeriod.days30,
      sections: ReportDefaultSections.values,
    );
    expect(cache.stale, isFalse);
    expect(childSnapshot, isNotNull);
    expect(childSnapshot!.subjectId, child.id);
    expect(
      childSnapshot.reason,
      PluginRuntimeEventType.activeSubjectChanged.name,
    );
  });

  test('report runtime caches selected periods independently', () async {
    _seedAnalysisStore(subject: ActiveSubjectDefaults.self);
    final cache = ReportRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    final runtime = ReportPluginRuntime(
      cache: cache,
      preheater: const ReportSnapshotPreheater(
        facadeProvider: AnalysisFacade.current,
      ),
    );
    manager.register(runtime);
    await manager.resume(ReportPluginRuntime.id);

    await runtime.preheatPeriod(
      manager.context,
      period: ReportPeriod.days14,
      sections: ReportDefaultSections.values,
      reason: 'test',
    );

    expect(
      cache.freshSnapshot(
        subjectId: ActiveSubjectDefaults.self.id,
        period: ReportPeriod.days30,
        sections: ReportDefaultSections.values,
      ),
      isNotNull,
    );
    expect(
      cache.freshSnapshot(
        subjectId: ActiveSubjectDefaults.self.id,
        period: ReportPeriod.days14,
        sections: ReportDefaultSections.values,
      ),
      isNotNull,
    );
  });
}

void _seedAnalysisStore({
  required AnalysisSubject subject,
  DateTime? now,
}) {
  final current = now ?? DateTime(2026, 6, 6, 12);
  final readings = List.generate(
    30 * 24,
    (index) => GlucoseReading(
      timestamp: current.subtract(Duration(hours: (30 * 24 - 1) - index)),
      value: 5.6 + (index % 24) * 0.02,
    ),
  );
  AnalysisSessionStore.instance.update(
    AnalysisRefreshResult(
      snapshot: AnalysisSnapshot(
        generatedAt: current,
        windowStart: readings.first.timestamp,
        windowEnd: readings.last.timestamp,
        readings: readings,
        dailySummaries: const [],
        periodSummaries: const [],
        events: const [],
      ),
      insights: const [],
      subjectId: subject.id,
    ),
    settings: const AppSettings(),
    subject: subject,
  );
}

void _resetStore() {
  final store = AnalysisSessionStore.instance;
  store.clear();
  store.updateSettings(const AppSettings());
  store.setActiveSubject(ActiveSubjectDefaults.self);
}

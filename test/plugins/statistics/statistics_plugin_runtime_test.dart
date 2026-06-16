import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugins/statistics/application/statistics_host_services.dart';
import 'package:smart_xdrip/plugins/statistics/application/statistics_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';
import 'package:smart_xdrip/plugins/statistics/runtime/statistics_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/statistics/runtime/statistics_runtime_cache.dart';

void main() {
  tearDown(() {
    AnalysisSessionStore.instance.clear();
  });

  test('statistics runtime preheats the default period on enter', () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now);
    final cache = StatisticsRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      StatisticsPluginRuntime(
        cache: cache,
        preheater: StatisticsSnapshotPreheater(
          hostServices: _hostServices(),
          now: () => now,
        ),
      ),
    );

    await manager.resume(StatisticsPluginRuntime.id);

    expect(cache.stale, isFalse);
    expect(cache.snapshots.single.query.subjectId, 'self');
    expect(cache.snapshots.single.query.windowId,
        StatisticsAnalysisWindowId.last14Days);
    expect(cache.snapshots.single.viewModel.selectedWindowId,
        StatisticsAnalysisWindowId.last14Days);
    expect(
      cache.freshViewModel(
        subjectId: 'self',
        windowId: StatisticsAnalysisWindowId.last14Days,
      ),
      isNotNull,
    );
  });

  test(
      'statistics runtime marks stale on datasource changes and refreshes on sync',
      () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now);
    final cache = StatisticsRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      StatisticsPluginRuntime(
        cache: cache,
        preheater: StatisticsSnapshotPreheater(
          hostServices: _hostServices(),
          now: () => now,
        ),
      ),
    );
    await manager.resume(StatisticsPluginRuntime.id);
    expect(cache.stale, isFalse);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.datasourceChanged,
        occurredAt: now.add(const Duration(minutes: 1)),
      ),
    );
    await pumpEventQueue();

    expect(cache.stale, isTrue);
    expect(cache.staleReason, PluginRuntimeEventType.datasourceChanged.name);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.subjectDataChanged,
        occurredAt: now.add(const Duration(minutes: 2)),
      ),
    );
    await pumpEventQueue();

    expect(cache.stale, isFalse);
    expect(cache.staleReason, isNull);
  });

  test('statistics runtime can preheat another window on demand', () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now);
    final cache = StatisticsRuntimeCache();
    final runtime = StatisticsPluginRuntime(
      cache: cache,
      preheater: StatisticsSnapshotPreheater(
        hostServices: _hostServices(),
        now: () => now,
      ),
    );

    final snapshot = await runtime.preheatWindow(
      windowId: StatisticsAnalysisWindowId.last30Days,
    );

    expect(snapshot?.query.windowId, StatisticsAnalysisWindowId.last30Days);
    expect(
      snapshot?.viewModel.selectedWindowId,
      StatisticsAnalysisWindowId.last30Days,
    );
    expect(
      cache.freshViewModel(
        subjectId: 'self',
        windowId: StatisticsAnalysisWindowId.last30Days,
      ),
      isNotNull,
    );
  });
}

StatisticsHostServices _hostServices() {
  return StatisticsHostServices(
    changeSignal: _NoopListenable(),
    facadeProvider: AnalysisFacade.current,
    settingsProvider: () => AnalysisSessionStore.instance.settings,
  );
}

void _seedAnalysisStore(DateTime now) {
  final start = now.subtract(const Duration(days: 39));
  final readings = <GlucoseReading>[];
  for (var day = 0; day < 40; day++) {
    final dayStart = DateTime(
      start.year,
      start.month,
      start.day,
    ).add(Duration(days: day));
    for (var slot = 0; slot < 24; slot++) {
      readings.add(
        GlucoseReading(
          timestamp: dayStart.add(Duration(hours: slot)),
          value: 5.6 + (slot % 8) * 0.25 + (day % 5) * 0.08,
          ratePerMin: 0.01,
        ),
      );
    }
  }
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
}

class _NoopListenable extends Listenable {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

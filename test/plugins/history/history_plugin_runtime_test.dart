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
import 'package:smart_xdrip/plugins/history/application/history_host_services.dart';
import 'package:smart_xdrip/plugins/history/application/history_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/history/runtime/history_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/history/runtime/history_runtime_cache.dart';

void main() {
  tearDown(() {
    AnalysisSessionStore.instance.clear();
  });

  test('history runtime preheats selected day on enter', () async {
    final today = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(today);
    final cache = HistoryRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => today);
    addTearDown(manager.dispose);
    manager.register(
      HistoryPluginRuntime(
        cache: cache,
        preheater: HistorySnapshotPreheater(
          hostServices: _hostServices(today),
          now: () => today,
        ),
      ),
    );

    await manager.resume(HistoryPluginRuntime.id);

    expect(cache.stale, isFalse);
    expect(cache.snapshots.single.query.subjectId, 'self');
    expect(cache.snapshots.single.viewModel.curve.readings, hasLength(24));
    expect(cache.freshViewModel(subjectId: 'self', day: today), isNotNull);
  });

  test(
    'history runtime marks stale on datasource changes and refreshes on sync',
    () async {
      final today = DateTime(2026, 6, 6, 12);
      _seedAnalysisStore(today);
      final cache = HistoryRuntimeCache();
      final manager = PluginRuntimeManager.create(now: () => today);
      addTearDown(manager.dispose);
      manager.register(
        HistoryPluginRuntime(
          cache: cache,
          preheater: HistorySnapshotPreheater(
            hostServices: _hostServices(today),
            now: () => today,
          ),
        ),
      );
      await manager.resume(HistoryPluginRuntime.id);
      expect(cache.stale, isFalse);

      manager.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.datasourceChanged,
          occurredAt: today.add(const Duration(minutes: 1)),
        ),
      );
      await pumpEventQueue();

      expect(cache.stale, isTrue);
      expect(cache.staleReason, PluginRuntimeEventType.datasourceChanged.name);

      manager.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.subjectDataChanged,
          occurredAt: today.add(const Duration(minutes: 2)),
        ),
      );
      await pumpEventQueue();

      expect(cache.stale, isFalse);
      expect(cache.staleReason, isNull);
    },
  );

  test('history runtime can preheat another day on demand', () async {
    final today = DateTime(2026, 6, 6, 12);
    final yesterday = today.subtract(const Duration(days: 1));
    _seedAnalysisStore(today);
    final cache = HistoryRuntimeCache();
    final runtime = HistoryPluginRuntime(
      cache: cache,
      preheater: HistorySnapshotPreheater(
        hostServices: _hostServices(today),
        now: () => today,
      ),
    );

    final snapshot = await runtime.preheatDay(day: yesterday);

    expect(snapshot?.query.normalizedDay, DateTime(2026, 6, 5));
    expect(snapshot?.viewModel.curve.readings, hasLength(12));
    expect(cache.freshViewModel(subjectId: 'self', day: yesterday), isNotNull);
  });
}

HistoryHostServices _hostServices(DateTime now) {
  return HistoryHostServices(
    changeSignal: _NoopListenable(),
    facadeProvider: AnalysisFacade.current,
    settingsProvider: () => AnalysisSessionStore.instance.settings,
  );
}

void _seedAnalysisStore(DateTime now) {
  final todayStart = DateTime(now.year, now.month, now.day);
  final yesterdayStart = todayStart.subtract(const Duration(days: 1));
  final todayReadings = List.generate(
    24,
    (index) => GlucoseReading(
      timestamp: todayStart.add(Duration(minutes: index * 30)),
      value: 5.8 + (index % 6) * 0.2,
      ratePerMin: 0.01,
    ),
  );
  final yesterdayReadings = List.generate(
    12,
    (index) => GlucoseReading(
      timestamp: yesterdayStart.add(Duration(hours: index * 2)),
      value: 6.2 + (index % 4) * 0.25,
      ratePerMin: 0.01,
    ),
  );
  final readings = [...yesterdayReadings, ...todayReadings];
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

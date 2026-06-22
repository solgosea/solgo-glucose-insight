import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/plugins/home/application/home_host_services.dart';
import 'package:smart_xdrip/plugins/home/controllers/home_controller.dart';
import 'package:smart_xdrip/plugins/home/application/home_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/home/mappers/home_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/home/models/home_chart_range.dart';
import 'package:smart_xdrip/plugins/home/runtime/home_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/home/runtime/home_runtime_cache.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';

void main() {
  tearDown(() {
    AnalysisSessionStore.instance.clear();
  });

  test('home runtime preheats default home snapshot on app start', () async {
    _seedAnalysisStore();
    final cache = HomeRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    manager.register(
      HomePluginRuntime(
        cache: cache,
        preheater: HomeSnapshotPreheater(
          hostServices: _hostServices(),
          facadeProvider: AnalysisFacade.current,
        ),
      ),
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );

    await manager.startAppRuntimes();

    expect(cache.stale, isFalse);
    expect(cache.snapshots.single.range, HomeChartRange.fourHours);
    expect(
      cache.freshViewModel(subjectId: 'self', range: HomeChartRange.fourHours),
      isNotNull,
    );
  });

  test('home runtime marks stale on datasource changes and refreshes on sync',
      () async {
    _seedAnalysisStore();
    final cache = HomeRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    manager.register(
      HomePluginRuntime(
        cache: cache,
        preheater: HomeSnapshotPreheater(
          hostServices: _hostServices(),
          facadeProvider: AnalysisFacade.current,
        ),
      ),
    );
    await manager.resume(HomePluginRuntime.id);
    expect(cache.stale, isFalse);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.datasourceChanged,
        occurredAt: DateTime(2026, 6, 6, 12, 1),
      ),
    );
    await pumpEventQueue();

    expect(cache.stale, isTrue);
    expect(cache.staleReason, PluginRuntimeEventType.datasourceChanged.name);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.subjectDataChanged,
        occurredAt: DateTime(2026, 6, 6, 12, 2),
      ),
    );
    await pumpEventQueue();

    expect(cache.stale, isFalse);
    expect(cache.staleReason, isNull);
  });

  test('home runtime reruns preheat when data changes during preheat',
      () async {
    _seedAnalysisStore(value: 5.6);
    final cache = HomeRuntimeCache();
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);

    final firstSyncStarted = Completer<void>();
    final releaseFirstSync = Completer<void>();
    var syncCalls = 0;

    manager.register(
      HomePluginRuntime(
        cache: cache,
        preheater: HomeSnapshotPreheater(
          hostServices: _hostServices(
            syncStatusSnapshot: () async {
              syncCalls += 1;
              if (syncCalls == 1) {
                firstSyncStarted.complete();
                await releaseFirstSync.future;
              }
              return _freshSyncStatus();
            },
          ),
          facadeProvider: AnalysisFacade.current,
        ),
      ),
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );

    final start = manager.startAppRuntimes();
    await firstSyncStarted.future;

    _seedAnalysisStore(value: 12.3);
    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.subjectDataChanged,
        occurredAt: DateTime(2026, 6, 6, 12, 2),
      ),
    );
    releaseFirstSync.complete();
    await start;
    await pumpEventQueue();

    final home = cache.freshViewModel(
      subjectId: 'self',
      range: HomeChartRange.fourHours,
    );
    expect(home?.glucose.value, '13.4');
    expect(syncCalls, greaterThanOrEqualTo(2));
  });

  test('home runtime can preheat a non-default range on demand', () async {
    _seedAnalysisStore();
    final cache = HomeRuntimeCache();
    final runtime = HomePluginRuntime(
      cache: cache,
      preheater: HomeSnapshotPreheater(
        hostServices: _hostServices(),
        facadeProvider: AnalysisFacade.current,
      ),
    );

    final snapshot = await runtime.preheatRange(
      range: HomeChartRange.eightHours,
    );

    expect(snapshot?.range, HomeChartRange.eightHours);
    expect(
      cache.freshViewModel(subjectId: 'self', range: HomeChartRange.eightHours),
      isNotNull,
    );
  });

  test('home one hour range is available and maps recent readings', () async {
    _seedAnalysisStore();

    final home = const HomeViewModelMapper().map(
      facade: AnalysisFacade.current(),
      selectedRange: HomeChartRange.oneHour,
      syncStatus: _syncViewModel(),
    );

    expect(home.availableRanges.first, HomeChartRange.oneHour);
    expect(home.selectedRange, HomeChartRange.oneHour);
    expect(home.chartReadings.length, 13);
    expect(
      home.chartReadings.first.timestamp,
      DateTime(2026, 6, 6, 11),
    );
    expect(
      home.chartReadings.last.timestamp,
      DateTime(2026, 6, 6, 12),
    );
  });

  test('home range changes do not refresh sync status', () async {
    _seedAnalysisStore();
    var syncCalls = 0;
    final controller = HomeController(
      hostServices: _hostServices(
        syncStatusSnapshot: () async {
          syncCalls += 1;
          return _freshSyncStatus();
        },
      ),
    );
    addTearDown(controller.dispose);

    await controller.init();
    final initialStatus = controller.viewModel?.syncStatus;

    await controller.selectRange(HomeChartRange.oneHour);

    expect(syncCalls, 1);
    expect(controller.viewModel?.selectedRange, HomeChartRange.oneHour);
    expect(controller.viewModel?.syncStatus, same(initialStatus));
  });
}

HomeHostServices _hostServices({
  Future<SyncStatusSnapshot> Function()? syncStatusSnapshot,
}) {
  return HomeHostServices(
    changeSignal: _NoopListenable(),
    syncStatusSnapshot: syncStatusSnapshot ?? () async => _freshSyncStatus(),
    switchToSelfSubject: () async {},
  );
}

SyncStatusSnapshot _freshSyncStatus() {
  return SyncStatusSnapshot(
    sourceLabel: 'Nightscout API',
    level: SyncStatusLevel.fresh,
    active: true,
    lastSuccessAt: DateTime(2026, 6, 6, 11, 58),
  );
}

SyncStatusViewModel _syncViewModel() {
  return const SyncStatusViewModel(
    label: 'Synced',
    semanticLabel: 'Synced',
    color: Color(0xFF6EE89E),
    pulsing: false,
  );
}

void _seedAnalysisStore({double value = 5.6}) {
  final now = DateTime(2026, 6, 6, 12);
  final readings = List.generate(
    72,
    (index) => GlucoseReading(
      timestamp: now.subtract(Duration(minutes: (71 - index) * 5)),
      value: value + (index % 8) * 0.15,
      ratePerMin: 0.02,
    ),
  );
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
}

class _NoopListenable extends Listenable {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

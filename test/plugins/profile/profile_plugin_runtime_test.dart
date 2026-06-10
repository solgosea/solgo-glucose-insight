import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugins/profile/application/profile_host_services.dart';
import 'package:smart_xdrip/plugins/profile/application/profile_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/profile/runtime/profile_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/profile/runtime/profile_runtime_cache.dart';

void main() {
  tearDown(() {
    AnalysisSessionStore.instance.clear();
  });

  test('profile runtime preheats current subject profile view model', () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now, subjectId: 'self');
    final cache = ProfileRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      ProfilePluginRuntime(
        cache: cache,
        preheater: ProfileSnapshotPreheater(
          hostServices: _hostServices(now),
          now: () => now,
        ),
      ),
    );

    await manager.resume(ProfilePluginRuntime.id);

    expect(cache.stale, isFalse);
    expect(cache.snapshots.single.subjectId, 'self');
    expect(
      cache.snapshots.single.viewModel.dataSources.single.name,
      'Nightscout API',
    );
    expect(cache.freshSnapshot(subjectId: 'self'), isNotNull);
  });

  test('profile runtime caches snapshots by subject id', () async {
    final now = DateTime(2026, 6, 6, 12);
    final cache = ProfileRuntimeCache();
    final runtime = ProfilePluginRuntime(
      cache: cache,
      preheater: ProfileSnapshotPreheater(
        hostServices: _hostServices(now),
        now: () => now,
      ),
    );

    _seedAnalysisStore(now, subjectId: 'self');
    await runtime.preheat();
    _seedAnalysisStore(now, subjectId: 'child-1');
    cache.markStale('subjectChanged');
    await runtime.preheat();

    expect(cache.freshSnapshot(subjectId: 'self'), isNotNull);
    expect(cache.freshSnapshot(subjectId: 'child-1'), isNotNull);
  });

  test('profile runtime refreshes after datasource events', () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now, subjectId: 'self');
    final cache = ProfileRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      ProfilePluginRuntime(
        cache: cache,
        preheater: ProfileSnapshotPreheater(
          hostServices: _hostServices(now),
          now: () => now,
        ),
      ),
    );
    await manager.resume(ProfilePluginRuntime.id);
    expect(cache.stale, isFalse);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.datasourceChanged,
        occurredAt: now.add(const Duration(minutes: 1)),
      ),
    );
    await pumpEventQueue();

    expect(cache.stale, isFalse);
    expect(cache.staleReason, isNull);
    expect(cache.freshSnapshot(subjectId: 'self'), isNotNull);
  });
}

ProfileHostServices _hostServices(DateTime now) {
  return ProfileHostServices(
    changeSignal: _NoopListenable(),
    facadeProvider: AnalysisFacade.current,
    settingsProvider: () => const AppSettings(nightscoutSyncEnabled: true),
    syncStatusSnapshot:
        () async => SyncStatusSnapshot(
          sourceLabel: 'Nightscout API',
          level: SyncStatusLevel.waitingFirstSync,
          active: true,
          lastAttemptAt: now,
        ),
    xdripSupported: () => false,
    dataSourceSnapshots:
        ({required bool xdripSupported}) async => [
          const DataSourceConnectionSnapshot(
            kind: DataSourceKind.nightscout,
            status: DataSourceConnectionStatus.syncing,
            action: DataSourceConnectionAction.sync,
            strategyAction: DataSourceSyncStrategyAction.disable,
            title: 'Nightscout API',
            subtitle: 'Configured endpoint',
            trailing: 'Sync',
            strategyTrailing: 'On',
            active: true,
            detected: true,
            configured: true,
            strategyEnabled: true,
            supported: true,
          ),
        ],
  );
}

void _seedAnalysisStore(DateTime now, {required String subjectId}) {
  final readings = List.generate(
    72,
    (index) => GlucoseReading(
      timestamp: now.subtract(Duration(minutes: (71 - index) * 20)),
      value: 5.8 + (index % 7) * 0.18,
      ratePerMin: 0.01,
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
    subject: AnalysisSubject(
      id: subjectId,
      displayName: subjectId,
      sourceLabel: 'Test source',
      origin:
          subjectId == 'self'
              ? AnalysisSubjectOrigin.self
              : const AnalysisSubjectOrigin('external'),
    ),
  );
}

class _NoopListenable extends Listenable {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

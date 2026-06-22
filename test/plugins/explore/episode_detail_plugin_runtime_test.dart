import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_registry.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/episode_detail_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/install/episode_detail_runtime_installer.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/mappers/episode_detail_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_kind.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/runtime/episode_detail_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/runtime/episode_detail_runtime_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(_resetStore);

  test('runtime preheats high and low episode detail for current subject',
      () async {
    final now = DateTime(2026, 6, 6, 8);
    _seedStore(now, subject: ActiveSubjectDefaults.self);
    final cache = EpisodeDetailRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      EpisodeDetailPluginRuntime(
        cache: cache,
        preheater: _preheater(now),
      ),
    );

    await manager.resume(EpisodeDetailPluginRuntime.id);

    final high = cache.freshSnapshot(
      subjectId: ActiveSubjectDefaults.self.id,
      kind: EpisodeKind.high,
    );
    final low = cache.freshSnapshot(
      subjectId: ActiveSubjectDefaults.self.id,
      kind: EpisodeKind.low,
    );
    expect(high, isNotNull);
    expect(low, isNotNull);
    final mapper = const EpisodeDetailViewModelMapper();
    final highViewModel = mapper.map(high!.output);
    final lowViewModel = mapper.map(low!.output);
    expect(highViewModel.kind, EpisodeKind.high);
    expect(lowViewModel.kind, EpisodeKind.low);
    expect(highViewModel.hero, isNotNull);
    expect(lowViewModel.hero, isNotNull);
    final highChart = highViewModel.chart!;
    final lowChart = lowViewModel.chart!;
    expect(
      highChart.timeRangeStart,
      DateTime(2026, 6, 6, 5, 45),
    );
    expect(
      highChart.timeRangeEnd,
      DateTime(2026, 6, 6, 10, 23),
    );
    expect(
      lowChart.timeRangeStart,
      DateTime(2026, 6, 6, 1, 20),
    );
    expect(
      lowChart.timeRangeEnd,
      DateTime(2026, 6, 6, 5, 43),
    );
  });

  test('runtime refreshes cache after active subject changes', () async {
    final now = DateTime(2026, 6, 6, 8);
    _seedStore(now, subject: ActiveSubjectDefaults.self);
    final cache = EpisodeDetailRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      EpisodeDetailPluginRuntime(
        cache: cache,
        preheater: _preheater(now),
      ),
    );
    await manager.resume(EpisodeDetailPluginRuntime.id);

    const child = AnalysisSubject(
      id: 'remote:child-episode',
      displayName: 'Child Episode',
      sourceLabel: 'Remote Nightscout',
      origin: AnalysisSubjectOrigin('remote'),
    );
    _seedStore(now.add(const Duration(minutes: 5)), subject: child);
    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.activeSubjectChanged,
        occurredAt: now,
        payload: {'subjectId': child.id},
      ),
    );
    await pumpEventQueue();

    final high = cache.freshSnapshot(
      subjectId: child.id,
      kind: EpisodeKind.high,
    );
    final low = cache.freshSnapshot(
      subjectId: child.id,
      kind: EpisodeKind.low,
    );
    expect(high, isNotNull);
    expect(low, isNotNull);
    expect(high!.reason, PluginRuntimeEventType.activeSubjectChanged.name);
    expect(low!.reason, PluginRuntimeEventType.activeSubjectChanged.name);
  });

  test('installer is idempotent for low and high entry plugins', () {
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 8),
    );
    addTearDown(manager.dispose);
    final services = PluginServiceRegistry();
    final context = PluginInstallContext(
      runtimeManager: manager,
      services: services,
      schemaRegistry: PluginSchemaRegistry(),
    );

    EpisodeDetailRuntimeInstaller.install(context);
    EpisodeDetailRuntimeInstaller.install(context);

    expect(services.maybe<EpisodeDetailRuntimeCache>(), isNotNull);
    expect(services.maybe<EpisodeDetailPluginRuntime>(), isNotNull);
    expect(
      manager.registry.handles
          .where((handle) =>
              handle.runtime.pluginId == EpisodeDetailPluginRuntime.id)
          .length,
      1,
    );
  });
}

EpisodeDetailSnapshotPreheater _preheater(DateTime now) {
  return EpisodeDetailSnapshotPreheater(
    facadeProvider: AnalysisFacade.current,
    now: () => now,
  );
}

void _seedStore(DateTime now, {required AnalysisSubject subject}) {
  final start =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 20));
  final readings = <GlucoseReading>[];
  for (var day = 0; day < 21; day++) {
    final current = start.add(Duration(days: day));
    final normalized = DateTime(current.year, current.month, current.day);
    for (var sample = 0; sample < 24; sample++) {
      final hour = sample;
      final highWave = hour >= 7 && hour <= 9 ? 4.0 : 0.0;
      final lowWave = hour >= 2 && hour <= 4 ? -2.2 : 0.0;
      readings.add(
        GlucoseReading(
          timestamp: normalized.add(Duration(hours: hour)),
          value: 5.8 + highWave + lowWave + (sample % 3) * 0.08,
        ),
      );
    }
  }
  final latestDay = DateTime(now.year, now.month, now.day);
  final events = [
    GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: latestDay.add(const Duration(hours: 7, minutes: 45)),
      value: 10.8,
      endTime: latestDay.add(const Duration(hours: 8, minutes: 23)),
      peakOrNadir: 10.8,
      ratePerMin: 0.08,
      areaOutOfRange: 65,
    ),
    GlucoseEvent(
      type: GlucoseEventType.lowEpisode,
      time: latestDay.add(const Duration(hours: 3, minutes: 20)),
      value: 3.1,
      endTime: latestDay.add(const Duration(hours: 3, minutes: 43)),
      peakOrNadir: 3.1,
      ratePerMin: -0.18,
      isNocturnal: true,
      lowSeverity: LowSeverity.mild,
      areaOutOfRange: 22,
    ),
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
        events: events,
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

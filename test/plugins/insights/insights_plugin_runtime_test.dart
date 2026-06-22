import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_module_code.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';
import 'package:smart_xdrip/domain/insight/narrative_insight.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugins/insights/application/insights_host_services.dart';
import 'package:smart_xdrip/plugins/insights/application/insights_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/insights/runtime/insights_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/insights/runtime/insights_runtime_cache.dart';

void main() {
  tearDown(() {
    AnalysisSessionStore.instance.clear();
  });

  test('insights runtime preheats current subject insight view model',
      () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now, subjectId: 'self', dailyBody: 'Self daily brief');
    final cache = InsightsRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      InsightsPluginRuntime(
        cache: cache,
        preheater: InsightsSnapshotPreheater(
          hostServices: _hostServices(),
          now: () => now,
        ),
      ),
    );

    await manager.resume(InsightsPluginRuntime.id);

    expect(cache.stale, isFalse);
    expect(cache.snapshots.single.subjectId, 'self');
    expect(cache.snapshots.single.viewModel.dailyBrief, 'Self daily brief');
    expect(cache.freshViewModel(subjectId: 'self'), isNotNull);
  });

  test('insights runtime caches by subject id', () async {
    final now = DateTime(2026, 6, 6, 12);
    final cache = InsightsRuntimeCache();
    final runtime = InsightsPluginRuntime(
      cache: cache,
      preheater: InsightsSnapshotPreheater(
        hostServices: _hostServices(),
        now: () => now,
      ),
    );

    _seedAnalysisStore(now, subjectId: 'self', dailyBody: 'Self insight');
    await runtime.preheat();
    _seedAnalysisStore(now, subjectId: 'child-1', dailyBody: 'Child insight');
    cache.markStale('subjectChanged');
    await runtime.preheat();

    expect(cache.freshViewModel(subjectId: 'child-1')?.dailyBrief,
        'Child insight');
    expect(cache.freshViewModel(subjectId: 'self')?.dailyBrief, 'Self insight');
  });

  test(
      'insights runtime marks stale on datasource changes and refreshes on sync',
      () async {
    final now = DateTime(2026, 6, 6, 12);
    _seedAnalysisStore(now, subjectId: 'self', dailyBody: 'Self daily brief');
    final cache = InsightsRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      InsightsPluginRuntime(
        cache: cache,
        preheater: InsightsSnapshotPreheater(
          hostServices: _hostServices(),
          now: () => now,
        ),
      ),
    );
    await manager.resume(InsightsPluginRuntime.id);
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
}

InsightsHostServices _hostServices() {
  return InsightsHostServices(
    changeSignal: _NoopListenable(),
    facadeProvider: AnalysisFacade.current,
    settingsProvider: () => AnalysisSessionStore.instance.settings,
  );
}

void _seedAnalysisStore(
  DateTime now, {
  required String subjectId,
  required String dailyBody,
}) {
  final readings = List.generate(
    12,
    (index) => GlucoseReading(
      timestamp: now.subtract(Duration(minutes: (11 - index) * 5)),
      value: 5.8 + (index % 4) * 0.2,
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
      insights: [
        NarrativeInsight(
          id: '$subjectId-daily',
          module: AnalysisModuleCode.insights,
          slot: InsightSlotCode.dailyBrief,
          type: InsightTypeCode.dailyCompleteDay,
          templateCode: 'daily',
          templateVersion: 1,
          body: dailyBody,
          footer: 'Generated from CGM data',
          facts: const {},
          generatedAt: now,
        ),
        NarrativeInsight(
          id: '$subjectId-weekly',
          module: AnalysisModuleCode.insights,
          slot: InsightSlotCode.weeklyReview,
          type: InsightTypeCode.weeklyReview,
          templateCode: 'weekly',
          templateVersion: 1,
          eyebrow: 'Weekly review',
          body: 'Weekly body',
          facts: const {
            'tir7': '78%',
            'bestDayShort': 'Tue',
            'longestHighValue': '42m',
            'longestHighLabel': 'High run',
            'hasLongestHigh': true,
          },
          generatedAt: now,
        ),
        NarrativeInsight(
          id: '$subjectId-pattern',
          module: AnalysisModuleCode.insights,
          slot: InsightSlotCode.patternCard,
          type: InsightTypeCode.stablePeriod,
          templateCode: 'pattern',
          templateVersion: 1,
          title: 'Stable window',
          body: 'A stable period was found.',
          footer: 'Pattern footer',
          facts: const {},
          generatedAt: now,
        ),
      ],
    ),
    subject: AnalysisSubject(
      id: subjectId,
      displayName: subjectId,
      sourceLabel: 'Test source',
      origin: subjectId == 'self'
          ? AnalysisSubjectOrigin.self
          : const AnalysisSubjectOrigin('remote'),
    ),
  );
}

class _NoopListenable extends Listenable {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/i18n/episode_detail_l10n_resolver.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/controllers/episode_detail_controller.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_entry_intent.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_query.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine_input.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine_output.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/mappers/episode_detail_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_kind.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/runtime/episode_detail_runtime_cache.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/runtime/episode_detail_runtime_snapshot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    final store = AnalysisSessionStore.instance;
    store.clear();
    store.updateSettings(const AppSettings());
    store.setActiveSubject(ActiveSubjectDefaults.self);
  });

  test('controller remaps cached engine output when locale changes', () async {
    final now = DateTime(2026, 6, 17, 12);
    final output = _highEpisodeOutput(now);
    _seedActiveSubject(output.chartSection!.readings, now);

    final cache = EpisodeDetailRuntimeCache();
    cache.put(
      EpisodeDetailRuntimeSnapshot(
        subjectId: ActiveSubjectDefaults.self.id,
        kind: EpisodeKind.high,
        output: output,
        updatedAt: now,
        reason: 'test',
      ),
    );

    final controller = EpisodeDetailController(
      intent: EpisodeDetailEntryIntent.latest(kind: EpisodeKind.high),
      runtimeCache: cache,
      mapper: const EpisodeDetailViewModelMapper(),
    );
    addTearDown(controller.dispose);

    await controller.load();
    expect(
      controller.viewModel!.highContext!.metrics.first.label,
      'Peak vs usual daily peak',
    );

    controller.remapWith(
      EpisodeDetailViewModelMapper(
        l10n: EpisodeDetailL10nResolver.resolve(const Locale('zh')),
      ),
    );

    expect(
      controller.viewModel!.highContext!.metrics.first.label,
      '峰值 vs 日常峰值',
    );
  });
}

EpisodeDetailEngineOutput _highEpisodeOutput(DateTime now) {
  final start = DateTime(now.year, now.month, now.day, 8);
  final readings = <GlucoseReading>[];
  for (var day = 0; day < 21; day++) {
    final currentDay = start.subtract(Duration(days: 20 - day));
    for (var minute = 0; minute <= 240; minute += 5) {
      final isFocusDay = day == 20;
      final value = isFocusDay
          ? minute < 60
              ? 6.8
              : minute < 110
                  ? 10 + (minute - 60) * 0.09
                  : minute < 210
                      ? 14.6 - (minute - 110) * 0.04
                      : 8.8
          : 6.6 + (minute % 30) * 0.01;
      readings.add(
        GlucoseReading(
          timestamp: currentDay.add(Duration(minutes: minute)),
          value: value,
        ),
      );
    }
  }
  final event = GlucoseEvent(
    type: GlucoseEventType.highEpisode,
    time: start.add(const Duration(minutes: 60)),
    value: 10.6,
    endTime: start.add(const Duration(minutes: 210)),
    peakOrNadir: 14.6,
    ratePerMin: 0.08,
    areaOutOfRange: 220,
  );

  return const EpisodeDetailEngine().run(
    EpisodeDetailEngineInput(
      query: EpisodeDetailQuery(
        subjectId: 'self',
        kind: EpisodeKind.high,
        anchorTime: now,
      ),
      readings: readings,
      events: [event],
      settings: const AppSettings(),
    ),
  );
}

void _seedActiveSubject(List<GlucoseReading> readings, DateTime now) {
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
      subjectId: ActiveSubjectDefaults.self.id,
    ),
    settings: const AppSettings(),
    subject: ActiveSubjectDefaults.self,
  );
}

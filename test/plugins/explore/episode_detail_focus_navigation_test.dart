import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/episode_detail_route_codec.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_entry_intent.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_focus.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_focus_match.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_query.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/sections/episode_header_section.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/sections/episode_similar_section.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/calculators/episode_focus_calculator.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine_output.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_kind.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/runtime/episode_detail_runtime_cache.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/runtime/episode_detail_runtime_snapshot.dart';
import 'package:smart_xdrip/plugins/history/domain/sections/history_episode_section.dart';
import 'package:smart_xdrip/plugins/history/domain/history_episode_context.dart';
import 'package:smart_xdrip/plugins/history/mappers/history_episode_view_model_mapper.dart';

void main() {
  test('route codec preserves focused high episode identity', () {
    final eventTime = DateTime(2026, 6, 17, 8, 10);
    final endTime = DateTime(2026, 6, 17, 9, 20);
    const codec = EpisodeDetailRouteCodec();

    final route = codec.encode(
      EpisodeDetailEntryIntent.focused(
        kind: EpisodeKind.high,
        focus: EpisodeDetailFocus(
          eventTime: eventTime,
          endTime: endTime,
          value: 13.2,
          durationMinutes: 70,
        ),
        sourceDay: DateTime(2026, 6, 17),
        source: 'history',
      ),
    );

    expect(route, startsWith('/explore/high-episode?'));
    final decoded = codec.decode(Uri.parse(route), kind: EpisodeKind.high);
    expect(decoded.isFocused, isTrue);
    expect(decoded.kind, EpisodeKind.high);
    expect(decoded.focus?.eventTime, eventTime);
    expect(decoded.focus?.endTime, endTime);
    expect(decoded.focus?.durationMinutes, 70);
    expect(decoded.sourceDay, DateTime(2026, 6, 17));
    expect(decoded.source, 'history');
  });

  test('focused selector chooses requested event instead of latest', () {
    final oldEventTime = DateTime(2026, 6, 10, 8);
    final latestEventTime = DateTime(2026, 6, 17, 8);
    final oldEvent = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: oldEventTime,
      value: 12,
      endTime: oldEventTime.add(const Duration(minutes: 45)),
    );
    final latestEvent = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: latestEventTime,
      value: 14,
      endTime: latestEventTime.add(const Duration(minutes: 60)),
    );

    final selected = const EpisodeFocusCalculator().select(
      [oldEvent, latestEvent],
      type: GlucoseEventType.highEpisode,
      anchorTime: latestEventTime,
      focus: EpisodeDetailFocus(eventTime: oldEventTime),
    );

    expect(selected.event, oldEvent);
    expect(selected.match.kind, EpisodeDetailFocusMatchKind.exactTime);

    final missing = const EpisodeFocusCalculator().select(
      [oldEvent, latestEvent],
      type: GlucoseEventType.highEpisode,
      anchorTime: latestEventTime,
      focus: EpisodeDetailFocus(eventTime: DateTime(2026, 6, 1, 8)),
    );
    expect(missing.event, isNull);
    expect(missing.match.kind, EpisodeDetailFocusMatchKind.notFound);
  });

  test('episode detail cache separates latest and focused snapshots', () {
    final cache = EpisodeDetailRuntimeCache();
    final focusTime = DateTime(2026, 6, 10, 8);
    final latest = EpisodeDetailRuntimeSnapshot(
      subjectId: 'self',
      kind: EpisodeKind.high,
      output: fakeHighEpisodeOutput(title: 'Latest High'),
      updatedAt: DateTime(2026, 6, 17),
      reason: 'latest',
    );
    final focused = EpisodeDetailRuntimeSnapshot(
      subjectId: 'self',
      kind: EpisodeKind.high,
      focus: EpisodeDetailFocus(eventTime: focusTime),
      output: fakeHighEpisodeOutput(title: 'Focused High'),
      updatedAt: DateTime(2026, 6, 17),
      reason: 'focused',
    );

    cache.put(latest);
    cache.put(focused);

    expect(
      cache
          .freshSnapshot(subjectId: 'self', kind: EpisodeKind.high)
          ?.output
          .headerSection
          .title,
      'Latest High',
    );
    expect(
      cache
          .freshSnapshot(
            subjectId: 'self',
            kind: EpisodeKind.high,
            focus: EpisodeDetailFocus(eventTime: focusTime),
          )
          ?.output
          .headerSection
          .title,
      'Focused High',
    );
  });

  test('history episode mapper creates focused navigation route', () {
    final eventTime = DateTime(2026, 6, 17, 8, 10);
    final event = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: eventTime,
      value: 12.4,
      endTime: eventTime.add(const Duration(minutes: 50)),
    );

    final callouts = const HistoryEpisodeViewModelMapper().map(
      HistoryEpisodeSection(
        episodes: [HistoryEpisodeContext(event: event)],
        focused: false,
      ),
      const AppSettings(),
      selectedDay: DateTime(2026, 6, 17),
    );

    expect(callouts, hasLength(1));
    final route = callouts.single.route;
    expect(route, startsWith('/explore/high-episode?'));
    expect(route, contains('mode=focused'));
    expect(route, contains('eventTime='));
    final decoded = const EpisodeDetailRouteCodec()
        .decode(Uri.parse(route), kind: EpisodeKind.high);
    expect(decoded.focus?.eventTime, eventTime);
    expect(decoded.source, 'history');
  });
}

EpisodeDetailEngineOutput fakeHighEpisodeOutput({required String title}) {
  return EpisodeDetailEngineOutput(
    query: EpisodeDetailQuery(
      subjectId: 'self',
      kind: EpisodeKind.high,
      anchorTime: DateTime(2026, 6, 17),
    ),
    focusMatch: const EpisodeDetailFocusMatch.latest(),
    settings: const AppSettings(),
    focus: null,
    headerSection: EpisodeHeaderSection(
      kind: EpisodeKind.high,
      title: title,
      episodeTime: null,
      emptySubtitle: '',
    ),
    window: null,
    chartSection: null,
    similarSection: const EpisodeSimilarSection(
      title: '',
      windowDays: 30,
      currentPoint: null,
      points: [],
      selected: null,
    ),
    highBurden: null,
    highDriver: null,
    highRecovery: null,
    highContext: null,
    highRepeat: null,
    highReliability: null,
    lowBurden: null,
    lowDriver: null,
    lowRecovery: null,
    lowContext: null,
    lowRepeat: null,
    lowReliability: null,
  );
}

import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../domain/sections/episode_chart_section.dart';
import '../domain/sections/episode_header_section.dart';
import '../domain/sections/episode_similar_section.dart';
import '../models/episode_kind.dart';
import 'calculators/episode_focus_calculator.dart';
import 'calculators/episode_similar_calculator.dart';
import 'calculators/episode_window_calculator.dart';
import 'calculators/high_episode_baseline_calculator.dart';
import 'calculators/high_episode_burden_calculator.dart';
import 'calculators/high_episode_driver_calculator.dart';
import 'calculators/high_episode_recovery_calculator.dart';
import 'calculators/high_episode_reliability_calculator.dart';
import 'calculators/high_episode_repeat_calculator.dart';
import 'calculators/low_episode_baseline_calculator.dart';
import 'calculators/low_episode_burden_calculator.dart';
import 'calculators/low_episode_driver_calculator.dart';
import 'calculators/low_episode_recovery_calculator.dart';
import 'calculators/low_episode_reliability_calculator.dart';
import 'calculators/low_episode_repeat_calculator.dart';
import 'episode_detail_engine_input.dart';
import 'episode_detail_engine_output.dart';

class EpisodeDetailEngine {
  final EpisodeFocusCalculator focusCalculator;
  final EpisodeWindowCalculator windowCalculator;
  final EpisodeSimilarCalculator similarCalculator;
  final HighEpisodeRecoveryCalculator highRecoveryCalculator;
  final HighEpisodeRepeatCalculator highRepeatCalculator;
  final HighEpisodeBurdenCalculator highBurdenCalculator;
  final HighEpisodeDriverCalculator highDriverCalculator;
  final HighEpisodeBaselineCalculator highBaselineCalculator;
  final HighEpisodeReliabilityCalculator highReliabilityCalculator;
  final LowEpisodeRecoveryCalculator lowRecoveryCalculator;
  final LowEpisodeRepeatCalculator lowRepeatCalculator;
  final LowEpisodeBurdenCalculator lowBurdenCalculator;
  final LowEpisodeDriverCalculator lowDriverCalculator;
  final LowEpisodeBaselineCalculator lowBaselineCalculator;
  final LowEpisodeReliabilityCalculator lowReliabilityCalculator;

  const EpisodeDetailEngine({
    this.focusCalculator = const EpisodeFocusCalculator(),
    this.windowCalculator = const EpisodeWindowCalculator(),
    this.similarCalculator = const EpisodeSimilarCalculator(),
    this.highRecoveryCalculator = const HighEpisodeRecoveryCalculator(),
    this.highRepeatCalculator = const HighEpisodeRepeatCalculator(),
    this.highBurdenCalculator = const HighEpisodeBurdenCalculator(),
    this.highDriverCalculator = const HighEpisodeDriverCalculator(),
    this.highBaselineCalculator = const HighEpisodeBaselineCalculator(),
    this.highReliabilityCalculator = const HighEpisodeReliabilityCalculator(),
    this.lowRecoveryCalculator = const LowEpisodeRecoveryCalculator(),
    this.lowRepeatCalculator = const LowEpisodeRepeatCalculator(),
    this.lowBurdenCalculator = const LowEpisodeBurdenCalculator(),
    this.lowDriverCalculator = const LowEpisodeDriverCalculator(),
    this.lowBaselineCalculator = const LowEpisodeBaselineCalculator(),
    this.lowReliabilityCalculator = const LowEpisodeReliabilityCalculator(),
  });

  EpisodeDetailEngineOutput run(EpisodeDetailEngineInput input) {
    final high = input.query.kind == EpisodeKind.high;
    final eventType =
        high ? GlucoseEventType.highEpisode : GlucoseEventType.lowEpisode;
    final events = input.events
        .where((event) => event.type == eventType)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    final recentEvents = _eventsInLastDays(events, 30, input.query.anchorTime);
    final focusSelection = focusCalculator.select(
      recentEvents.isNotEmpty ? recentEvents : events,
      type: eventType,
      anchorTime: input.query.anchorTime,
      focus: input.query.focus,
    );
    final focus = focusSelection.event;
    final header = EpisodeHeaderSection(
      kind: input.query.kind,
      title: '',
      episodeTime: focus?.time,
      emptySubtitle: '',
    );

    if (focus == null) {
      return EpisodeDetailEngineOutput(
        query: input.query,
        focusMatch: focusSelection.match,
        settings: input.settings,
        focus: null,
        headerSection: header,
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

    final window = windowCalculator.calculate(
      event: focus,
      allReadings: input.readings,
      high: high,
    );
    final episodeEndTime = focus.endTime ??
        focus.time.add(Duration(minutes: math.max(focus.durationMinutes, 0)));
    final chart = EpisodeChartSection(
      readings: window.readings,
      lowThreshold: input.settings.lowThreshold,
      highThreshold: input.settings.highThreshold,
      onsetTime: focus.time,
      peakOrNadirTime: window.extremeReading?.timestamp ?? focus.time,
      episodeEndTime: episodeEndTime,
      recoveryTime: focus.endTime,
      timeRangeStart: window.start,
      timeRangeEnd: window.end,
    );
    final similar = similarCalculator.calculate(
      current: focus,
      events: events,
      high: high,
      windowDays: 30,
      title: '',
    );

    if (!high) {
      final lowEvents = input.events
          .where((event) => event.type == GlucoseEventType.lowEpisode)
          .toList()
        ..sort((a, b) => a.time.compareTo(b.time));
      final recovery = lowRecoveryCalculator.calculate(
        focus,
        nadirTime: chart.peakOrNadirTime,
      );
      final repeat = lowRepeatCalculator.calculate(
        lowEvents: lowEvents,
        focus: focus,
        anchor: input.query.anchorTime,
      );
      final burden = lowBurdenCalculator.calculate(
        event: focus,
        window: window,
        recovery: recovery,
        settings: input.settings,
        repeated: repeat.count >= 2,
      );
      final driver = lowDriverCalculator.calculate(
        burden: burden,
        recovery: recovery,
        repeat: repeat,
      );
      final context = lowBaselineCalculator.calculate(
        episodeTime: focus.time,
        window: window,
        allReadings: input.readings,
      );
      final reliability = lowReliabilityCalculator.calculate(
        windowReadings: window.readings,
        nadirTime: chart.peakOrNadirTime,
        recoveryTime: recovery.recoveryTime,
      );
      return EpisodeDetailEngineOutput(
        query: input.query,
        focusMatch: focusSelection.match,
        settings: input.settings,
        focus: focus,
        headerSection: header,
        window: window,
        chartSection: chart,
        similarSection: similar,
        highBurden: null,
        highDriver: null,
        highRecovery: null,
        highContext: null,
        highRepeat: null,
        highReliability: null,
        lowBurden: burden,
        lowDriver: driver,
        lowRecovery: recovery,
        lowContext: context,
        lowRepeat: repeat,
        lowReliability: reliability,
      );
    }

    final highEvents = input.events
        .where((event) => event.type == GlucoseEventType.highEpisode)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    final recovery = highRecoveryCalculator.calculate(
      focus,
      peakTime: chart.peakOrNadirTime,
    );
    final repeat = highRepeatCalculator.calculate(
      highEvents: highEvents,
      focus: focus,
      anchor: input.query.anchorTime,
    );
    final burden = highBurdenCalculator.calculate(
      event: focus,
      window: window,
      recovery: recovery,
      settings: input.settings,
      repeated: repeat.count >= 2,
    );
    final driver = highDriverCalculator.calculate(
      burden: burden,
      recovery: recovery,
      repeat: repeat,
    );
    final context = highBaselineCalculator.calculate(
      episodeTime: focus.time,
      window: window,
      allReadings: input.readings,
    );
    final reliability = highReliabilityCalculator.calculate(
      windowReadings: window.readings,
      peakTime: chart.peakOrNadirTime,
      recoveryTime: recovery.recoveryTime,
    );

    return EpisodeDetailEngineOutput(
      query: input.query,
      focusMatch: focusSelection.match,
      settings: input.settings,
      focus: focus,
      headerSection: header,
      window: window,
      chartSection: chart,
      similarSection: similar,
      highBurden: burden,
      highDriver: driver,
      highRecovery: recovery,
      highContext: context,
      highRepeat: repeat,
      highReliability: reliability,
      lowBurden: null,
      lowDriver: null,
      lowRecovery: null,
      lowContext: null,
      lowRepeat: null,
      lowReliability: null,
    );
  }

  List<GlucoseEvent> _eventsInLastDays(
    List<GlucoseEvent> events,
    int days,
    DateTime anchor,
  ) {
    final cutoff = anchor.subtract(Duration(days: days));
    return events
        .where((event) =>
            !event.time.isBefore(cutoff) && !event.time.isAfter(anchor))
        .toList();
  }
}

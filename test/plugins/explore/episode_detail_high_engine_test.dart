import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_data_confidence.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_query.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_similar_match.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/high_episode_review_priority.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine_input.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/mappers/episode_detail_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_kind.dart';

void main() {
  test('high episode engine builds burden, driver and reliability facts', () {
    final start = DateTime(2026, 6, 17, 8);
    final event = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start.add(const Duration(minutes: 60)),
      value: 10.6,
      endTime: start.add(const Duration(minutes: 210)),
      peakOrNadir: 14.6,
      ratePerMin: 0.08,
      areaOutOfRange: 220,
    );
    final readings = <GlucoseReading>[
      for (var i = 0; i <= 240; i += 5)
        GlucoseReading(
          timestamp: start.add(Duration(minutes: i)),
          value: i < 60
              ? 6.8
              : i < 110
                  ? 10 + (i - 60) * 0.09
                  : i < 210
                      ? 14.6 - (i - 110) * 0.04
                      : 8.8,
        ),
    ];

    final output = const EpisodeDetailEngine().run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: 'self',
          kind: EpisodeKind.high,
          anchorTime: start.add(const Duration(days: 1)),
        ),
        readings: readings,
        events: [event],
        settings: const AppSettings(),
      ),
    );

    expect(output.focus, event);
    expect(output.highBurden?.priority, HighEpisodeReviewPriority.important);
    expect(output.highBurden?.durationMinutes, 150);
    expect(output.highDriver, isNotNull);
    expect(output.highReliability?.confidence, EpisodeDataConfidence.high);
    expect(output.chartSection, isNotNull);
    expect(output.similarSection.windowDays, 30);
    expect(output.highRepeat?.windowDays, 30);
    expect(output.highRepeat?.chartDataset.dayMarks, hasLength(30));
    expect(output.highRepeat?.chartDataset.timeBlockBuckets, hasLength(5));
    expect(
      output.highRepeat?.chartDataset.dayMarks.any((mark) => mark.isCurrent),
      isTrue,
    );

    final viewModel = const EpisodeDetailViewModelMapper().map(output);
    expect(viewModel.subtitle, 'Jun 17 · 09:00 - 11:30');
    expect(viewModel.highSummary?.recoveryTimeText, '11:30');
    expect(viewModel.highRepeat?.windowLabel, 'Past 30 days');
    expect(viewModel.highRepeat?.dayMarks, hasLength(30));
    expect(viewModel.highRepeat?.timeBlocks, hasLength(5));
    expect(
      viewModel.highBurden?.metrics
          .firstWhere((metric) => metric.label == 'Recovery')
          .value,
      '100m',
    );
    final lifecycle = viewModel.highLifecycle!.steps;
    expect(lifecycle.map((step) => step.label), [
      'Baseline',
      'Rise',
      'Peak',
      'Duration',
      'Recovery',
    ]);
    expect(lifecycle[0].value, isNot(contains(':')));
    expect(lifecycle[1].value, '+0.08/min');
    expect(lifecycle[2].value, '14.6');
    expect(lifecycle[3].value, '150 min');
    expect(lifecycle[4].value, '11:30');
  });

  test('high episode peak is selected from the episode window only', () {
    final start = DateTime(2026, 6, 17, 9);
    final event = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start,
      endTime: start.add(const Duration(minutes: 30)),
      value: 10.4,
      peakOrNadir: 11.1,
    );
    final readings = [
      GlucoseReading(
        timestamp: start.subtract(const Duration(minutes: 20)),
        value: 7.2,
      ),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 10)),
        value: 10.8,
      ),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 20)),
        value: 11.2,
      ),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 90)),
        value: 16.4,
      ),
    ];

    final output = const EpisodeDetailEngine().run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: 'self',
          kind: EpisodeKind.high,
          anchorTime: start.add(const Duration(days: 1)),
        ),
        readings: readings,
        events: [event],
        settings: const AppSettings(),
      ),
    );

    expect(output.highBurden?.peakMmol, 11.2);
    expect(
      output.chartSection?.peakOrNadirTime,
      start.add(const Duration(minutes: 20)),
    );
  });

  test('high episode without visible recovery stays unrecovered', () {
    final start = DateTime(2026, 6, 17, 9);
    final event = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start,
      value: 10.4,
      peakOrNadir: 11.0,
    );
    final readings = [
      GlucoseReading(timestamp: start, value: 10.4),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 10)),
        value: 11.0,
      ),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 20)),
        value: 10.5,
      ),
    ];

    final output = const EpisodeDetailEngine().run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: 'self',
          kind: EpisodeKind.high,
          anchorTime: start.add(const Duration(days: 1)),
        ),
        readings: readings,
        events: [event],
        settings: const AppSettings(),
      ),
    );

    expect(output.chartSection?.recoveryTime, isNull);
    expect(output.highRecovery?.recoveryMinutes, isNull);
    expect(output.highBurden?.priority, HighEpisodeReviewPriority.important);

    final viewModel = const EpisodeDetailViewModelMapper().map(output);
    expect(viewModel.highSummary?.recoveryTimeText, 'Not visible');
    expect(
      viewModel.highBurden?.metrics
          .firstWhere((metric) => metric.label == 'Recovery')
          .value,
      'Not visible',
    );
  });

  test('short mild recovered high can remain informational', () {
    final start = DateTime(2026, 6, 17, 9);
    final event = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start,
      endTime: start.add(const Duration(minutes: 20)),
      value: 10.1,
      peakOrNadir: 10.6,
    );
    final readings = [
      GlucoseReading(timestamp: start, value: 10.1),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 10)),
        value: 10.6,
      ),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 20)),
        value: 9.8,
      ),
    ];

    final output = const EpisodeDetailEngine().run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: 'self',
          kind: EpisodeKind.high,
          anchorTime: start.add(const Duration(days: 1)),
        ),
        readings: readings,
        events: [event],
        settings: const AppSettings(),
      ),
    );

    expect(output.highBurden?.priority, HighEpisodeReviewPriority.info);
  });

  test('similar high episodes use 30 day candidates and select best match', () {
    final start = DateTime(2026, 6, 17, 8);
    final current = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start,
      endTime: start.add(const Duration(minutes: 40)),
      value: 10.4,
      peakOrNadir: 11.0,
      ratePerMin: 0.06,
    );
    final bestMatch = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start.subtract(const Duration(days: 4)).add(
            const Duration(minutes: 7),
          ),
      endTime: start.subtract(const Duration(days: 4)).add(
            const Duration(minutes: 47),
          ),
      value: 10.3,
      peakOrNadir: 10.9,
      ratePerMin: 0.05,
    );
    final looseMatch = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start.subtract(const Duration(days: 8)).add(
            const Duration(hours: 8),
          ),
      endTime: start.subtract(const Duration(days: 8)).add(
            const Duration(hours: 8, minutes: 20),
          ),
      value: 10.1,
      peakOrNadir: 13.4,
      ratePerMin: 0.01,
    );
    final tooOld = GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: start.subtract(const Duration(days: 45)),
      endTime: start.subtract(const Duration(days: 45)).add(
            const Duration(minutes: 40),
          ),
      value: 10.3,
      peakOrNadir: 10.9,
    );

    final output = const EpisodeDetailEngine().run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: 'self',
          kind: EpisodeKind.high,
          anchorTime: start.add(const Duration(days: 1)),
          focus: null,
        ),
        readings: [
          GlucoseReading(timestamp: start, value: 10.4),
          GlucoseReading(
            timestamp: start.add(const Duration(minutes: 20)),
            value: 11.0,
          ),
          GlucoseReading(
            timestamp: start.add(const Duration(minutes: 40)),
            value: 9.8,
          ),
        ],
        events: [tooOld, looseMatch, bestMatch, current],
        settings: const AppSettings(),
      ),
    );

    expect(output.similarSection.windowDays, 30);
    expect(output.similarSection.points.where((point) => !point.isCurrent),
        hasLength(2));
    expect(
      output.similarSection.points.any(
        (point) => point.time == current.time && !point.isCurrent,
      ),
      isFalse,
    );
    expect(output.similarSection.selected?.match.event, bestMatch);
    expect(output.similarSection.selected?.match.label,
        EpisodeSimilarMatchLabel.verySimilar);
  });
}

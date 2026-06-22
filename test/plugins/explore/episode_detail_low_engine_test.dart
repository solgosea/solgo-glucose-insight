import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_data_confidence.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_detail_query.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/low_episode_review_priority.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/engine/episode_detail_engine_input.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/mappers/episode_detail_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_kind.dart';

void main() {
  test('low episode engine builds burden, driver and section view models', () {
    final start = DateTime(2026, 6, 17);
    final event = GlucoseEvent(
      type: GlucoseEventType.lowEpisode,
      time: start.add(const Duration(hours: 3, minutes: 5)),
      value: 3.6,
      endTime: start.add(const Duration(hours: 3, minutes: 52)),
      peakOrNadir: 2.9,
      ratePerMin: -0.08,
      areaOutOfRange: 42,
    );
    final repeatEvent = GlucoseEvent(
      type: GlucoseEventType.lowEpisode,
      time: start.subtract(const Duration(days: 3)).add(
            const Duration(hours: 3, minutes: 10),
          ),
      value: 3.5,
      endTime: start.subtract(const Duration(days: 3)).add(
            const Duration(hours: 3, minutes: 45),
          ),
      peakOrNadir: 3.0,
      ratePerMin: -0.07,
    );
    final readings = <GlucoseReading>[
      for (var i = 0; i <= 300; i += 5)
        GlucoseReading(
          timestamp: start.add(Duration(hours: 1, minutes: i)),
          value: i < 95
              ? 5.4
              : i < 125
                  ? 5.4 - (i - 95) * 0.083
                  : i < 172
                      ? 2.9 + (i - 125) * 0.02
                      : 4.4,
        ),
      for (var d = 1; d <= 14; d++)
        GlucoseReading(
          timestamp: start.subtract(Duration(days: d)).add(
                const Duration(hours: 3),
              ),
          value: d.isEven ? 3.7 : 5.2,
        ),
    ];

    final output = const EpisodeDetailEngine().run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: 'self',
          kind: EpisodeKind.low,
          anchorTime: start.add(const Duration(days: 1)),
        ),
        readings: readings,
        events: [event, repeatEvent],
        settings: const AppSettings(),
      ),
    );

    expect(output.focus, event);
    expect(output.lowBurden?.priority, LowEpisodeReviewPriority.important);
    expect(output.lowBurden?.durationMinutes, 47);
    expect(output.lowDriver, isNotNull);
    expect(output.lowRecovery?.recoveryTime, event.endTime);
    expect(output.lowRepeat?.count, greaterThanOrEqualTo(1));
    expect(output.lowRepeat?.windowDays, 30);
    expect(output.lowRepeat?.chartDataset.dayMarks, hasLength(30));
    expect(output.lowRepeat?.chartDataset.timeBlockBuckets, hasLength(5));
    expect(
      output.lowRepeat?.chartDataset.dayMarks.any((mark) => mark.isCurrent),
      isTrue,
    );
    expect(output.lowReliability?.confidence, EpisodeDataConfidence.high);
    expect(output.similarSection.windowDays, 30);

    final viewModel = const EpisodeDetailViewModelMapper().map(output);
    expect(viewModel.hasEpisode, isTrue);
    expect(viewModel.subtitle, 'Jun 17 · 03:05 - 03:52');
    expect(viewModel.lowSummary?.recoveryTimeText, '03:52');
    expect(viewModel.lowRepeat?.windowLabel, 'Past 30 days');
    expect(viewModel.lowRepeat?.dayMarks, hasLength(30));
    expect(viewModel.lowRepeat?.timeBlocks, hasLength(5));
    expect(
      viewModel.lowBurden?.metrics
          .firstWhere((metric) => metric.label == 'Recovered')
          .value,
      '47m',
    );
    final lifecycle = viewModel.lowLifecycle!.steps;
    expect(lifecycle.map((step) => step.label), [
      'Baseline',
      'Descent',
      'Nadir',
      'Low time',
      'Recovery',
    ]);
    expect(lifecycle[0].value, isNot(contains(':')));
    expect(lifecycle[1].value, '-0.08/min');
    expect(lifecycle[2].value, '2.9');
    expect(lifecycle[3].value, '47 min');
    expect(lifecycle[4].value, '03:52');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/text/high_episode_text_builders.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/text/low_episode_text_builders.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/text/episode_detail_text_renderer.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_data_confidence.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/high_episode_driver_type.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/high_episode_repeat_pattern.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/high_episode_review_priority.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/low_episode_driver_type.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/low_episode_recovery_quality.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/low_episode_repeat_pattern.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/low_episode_review_priority.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/text/episode_detail_text_slot.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/text/episode_detail_text_type.dart';

void main() {
  test('episode detail renderer renders pattern text from facts', () {
    const renderer = EpisodeDetailTextRenderer();

    final text = renderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail('highPatternClustered'),
      facts: {
        'count': 5,
        'range': '07:40-09:15',
      },
    );

    expect(text, contains('5 morning-window high episodes'));
    expect(text, contains('07:40-09:15'));
  });

  test('episode detail renderer renders severity text from facts', () {
    const renderer = EpisodeDetailTextRenderer();

    final text = renderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail('lowSeverityDescription'),
      facts: {'nadirLabel': '3.1 mmol/L'},
    );

    expect(text, '3.1 mmol/L is compared with this threshold band.');
  });

  test('episode detail renderer prefers Chinese templates by locale', () {
    const renderer = EpisodeDetailTextRenderer();

    final text = renderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail('highPatternClustered'),
      facts: {
        'count': 5,
        'range': '07:40-09:15',
      },
      context: const PluginTextRenderContext(locale: 'zh'),
    );

    expect(text, contains('过去 14 天检测到 5 次晨间高血糖事件'));
    expect(text, contains('07:40-09:15'));
  });

  test('episode detail renderer falls back to English when locale is missing',
      () {
    const renderer = EpisodeDetailTextRenderer();

    final text = renderer.render(
      slot: EpisodeDetailTextSlot.highSummaryTitle,
      type: EpisodeDetailTextType.highPriorityInfo,
      facts: const {},
      context: const PluginTextRenderContext(locale: 'es'),
    );

    expect(text, 'A short high episode worth noting.');
  });

  test('high episode text builders render Chinese templates', () {
    const context = PluginTextRenderContext(locale: 'zh');
    const summary = HighEpisodeSummaryTextBuilder();
    const driver = HighEpisodeDriverTextBuilder();
    const repeat = HighEpisodeRepeatTextBuilder();
    const reliability = HighEpisodeReliabilityTextBuilder();
    final facts = {
      'driverLabel': '持续时间',
      'peakLabel': '12.5 mmol/L',
      'durationMinutes': 68,
      'areaLabel': '42 mmol·min/L',
      'count': 3,
      'range': '08:00-09:30',
    };

    expect(
      summary.title(
        HighEpisodeReviewPriority.notable,
        facts,
        context: context,
      ),
      contains('高血糖事件'),
    );
    expect(
      driver.body(HighEpisodeDriverType.peak, facts, context: context),
      contains('12.5 mmol/L'),
    );
    expect(
      repeat.body(
        HighEpisodeRepeatPatternType.morning,
        facts,
        context: context,
      ),
      contains('晨间窗口出现了 3 次'),
    );
    expect(
      reliability.note(EpisodeDataConfidence.medium, facts, context: context),
      contains('中等可信度'),
    );
  });

  test('low episode text builders render Chinese templates', () {
    const context = PluginTextRenderContext(locale: 'zh');
    const summary = LowEpisodeSummaryTextBuilder();
    const driver = LowEpisodeDriverTextBuilder();
    const recovery = LowEpisodeRecoveryTextBuilder();
    const repeat = LowEpisodeRepeatTextBuilder();
    const reliability = LowEpisodeReliabilityTextBuilder();
    final facts = {
      'driverLabel': '最低值',
      'nadirLabel': '3.1 mmol/L',
      'durationMinutes': 24,
      'areaLabel': '18 mmol·min/L',
      'count': 2,
      'range': '02:00-03:00',
    };

    expect(
      summary.subtitle(
        LowEpisodeReviewPriority.notable,
        facts,
        context: context,
      ),
      contains('最低值为 3.1 mmol/L'),
    );
    expect(
      driver.title(LowEpisodeDriverType.nadir, facts, context: context),
      '最低值是主要驱动因素。',
    );
    expect(
      recovery.note(
        LowEpisodeRecoveryQuality.gradual,
        facts,
        context: context,
      ),
      contains('较为渐进'),
    );
    expect(
      repeat.body(
        LowEpisodeRepeatPatternType.sameTime,
        facts,
        context: context,
      ),
      contains('02:00-03:00'),
    );
    expect(
      reliability.note(EpisodeDataConfidence.low, facts, context: context),
      contains('数据间隙'),
    );
  });

  test('repeat takeaway templates are locale aware', () {
    const context = PluginTextRenderContext(locale: 'zh');
    const highRepeat = HighEpisodeRepeatTextBuilder();
    const lowRepeat = LowEpisodeRepeatTextBuilder();

    final highTakeaway = highRepeat.takeaway(
      HighEpisodeRepeatPatternType.morning,
      const {
        'count': 3,
        'windowDays': 30,
        'range': '08:00-09:30',
        'blockLabel': '上午',
        'rangeSuffix': ' (08:00-09:30)',
      },
      context: context,
    );
    expect(highTakeaway, contains('30'));
    expect(highTakeaway, isNot(contains('High episodes repeated')));

    final lowTakeaway = lowRepeat.takeaway(
      LowEpisodeRepeatPatternType.sameTime,
      const {
        'count': 2,
        'windowDays': 30,
        'range': '02:00-03:00',
        'blockLabel': '夜间',
        'rangeSuffix': ' (02:00-03:00)',
      },
      context: context,
    );
    expect(lowTakeaway, contains('30'));
    expect(lowTakeaway, isNot(contains('same-time low cluster')));
  });
}

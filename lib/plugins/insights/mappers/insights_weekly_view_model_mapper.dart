import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../application/text/insights_weekly_text_builder.dart';
import '../domain/insights_mini_stat.dart' as domain;
import '../domain/sections/insights_weekly_section.dart';
import '../domain/text/insights_text_type.dart';
import '../models/insights_view_model.dart';

class InsightsWeeklyViewModelMapper {
  final InsightsWeeklyTextBuilder textBuilder;

  const InsightsWeeklyViewModelMapper({
    this.textBuilder = const InsightsWeeklyTextBuilder(),
  });

  WeeklyReviewViewModel map(
    InsightsWeeklySection section, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return WeeklyReviewViewModel(
      eyebrow: textBuilder.eyebrow(
        facts: section.facts,
        context: context,
        fallback: section.fallbackEyebrow,
      ),
      body: textBuilder.body(
        facts: section.facts,
        context: context,
        fallback: section.fallbackBody,
      ),
      stats: section.stats
          .map((stat) => _miniStat(stat, context))
          .toList(growable: false),
    );
  }

  InsightMiniStatViewModel _miniStat(
    domain.InsightsMiniStat stat,
    PluginTextRenderContext context,
  ) {
    return InsightMiniStatViewModel(
      value: stat.value,
      label: _label(stat.labelType, context),
      tone: _tone(stat.tone),
    );
  }

  String _label(String labelType, PluginTextRenderContext context) {
    return switch (labelType) {
      InsightsTextType.weeklyStatBestDay =>
        textBuilder.bestDayLabel(context: context),
      InsightsTextType.weeklyStatLongestHigh =>
        textBuilder.longestHighLabel(context: context),
      _ => textBuilder.tirLabel(context: context),
    };
  }

  InsightMiniStatTone _tone(domain.InsightsMiniStatTone tone) {
    return switch (tone) {
      domain.InsightsMiniStatTone.positive => InsightMiniStatTone.positive,
      domain.InsightsMiniStatTone.warning => InsightMiniStatTone.warning,
      domain.InsightsMiniStatTone.neutral => InsightMiniStatTone.neutral,
    };
  }
}

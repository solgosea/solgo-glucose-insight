import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../application/text/insights_header_text_builder.dart';
import '../application/text/insights_empty_state_text_builder.dart';
import '../engine/insights_engine_output.dart';
import '../application/i18n/insights_l10n_resolver.dart';
import '../l10n/generated/insights_localizations.dart';
import '../models/insights_view_model.dart';
import 'insights_daily_view_model_mapper.dart';
import 'insights_patterns_view_model_mapper.dart';
import 'insights_weekly_view_model_mapper.dart';

class InsightsViewModelMapper {
  final InsightsHeaderTextBuilder headerTextBuilder;
  final InsightsEmptyStateTextBuilder emptyStateTextBuilder;
  final InsightsDailyViewModelMapper dailyMapper;
  final InsightsWeeklyViewModelMapper weeklyMapper;
  final InsightsPatternsViewModelMapper patternsMapper;

  const InsightsViewModelMapper({
    this.headerTextBuilder = const InsightsHeaderTextBuilder(),
    this.emptyStateTextBuilder = const InsightsEmptyStateTextBuilder(),
    this.dailyMapper = const InsightsDailyViewModelMapper(),
    this.weeklyMapper = const InsightsWeeklyViewModelMapper(),
    this.patternsMapper = const InsightsPatternsViewModelMapper(),
  });

  InsightsViewModel map(
    InsightsEngineOutput output, {
    InsightsLocalizations? l10n,
  }) {
    final strings = l10n ?? InsightsL10nResolver.fallback;
    final context = PluginTextRenderContext(locale: strings.localeName);
    final daily = dailyMapper.map(output.dailySection, context: context);
    return InsightsViewModel(
      headerDate:
          headerTextBuilder.date(output.query.anchorTime, context: context),
      dailyBrief: daily.body,
      dailyBriefFooter: daily.footer,
      weeklyReview: weeklyMapper.map(output.weeklySection, context: context),
      patterns: patternsMapper.map(output.patternsSection, context: context),
      patternsEmptyText: emptyStateTextBuilder.noData(context: context),
    );
  }
}

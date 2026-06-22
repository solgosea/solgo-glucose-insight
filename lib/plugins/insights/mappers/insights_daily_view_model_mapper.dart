import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../application/text/insights_daily_text_builder.dart';
import '../domain/sections/insights_daily_section.dart';

class InsightsDailyViewModelMapper {
  final InsightsDailyTextBuilder textBuilder;

  const InsightsDailyViewModelMapper({
    this.textBuilder = const InsightsDailyTextBuilder(),
  });

  ({String body, String footer}) map(
    InsightsDailySection section, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return (
      body: textBuilder.body(
        type: section.textType,
        facts: section.facts,
        context: context,
        fallback: section.fallbackBody,
      ),
      footer: textBuilder.footer(
        type: section.textType,
        facts: section.facts,
        context: context,
        fallback: section.fallbackFooter,
      ),
    );
  }
}

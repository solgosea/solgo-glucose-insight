import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../application/text/insights_pattern_text_builder.dart';
import '../domain/insights_pattern_kind.dart' as domain;
import '../domain/sections/insights_patterns_section.dart';
import '../models/insights_view_model.dart';

class InsightsPatternsViewModelMapper {
  final InsightsPatternTextBuilder textBuilder;

  const InsightsPatternsViewModelMapper({
    this.textBuilder = const InsightsPatternTextBuilder(),
  });

  List<InsightPatternViewModel> map(
    InsightsPatternsSection section, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return section.items
        .map((item) => _pattern(item, context))
        .toList(growable: false);
  }

  InsightPatternViewModel _pattern(
    InsightsPatternItem item,
    PluginTextRenderContext context,
  ) {
    return InsightPatternViewModel(
      icon: _icon(item.kind),
      title: textBuilder.title(
        type: item.textType,
        facts: item.facts,
        context: context,
        fallback: item.fallbackTitle,
      ),
      body: textBuilder.body(
        type: item.textType,
        facts: item.facts,
        context: context,
        fallback: item.fallbackBody,
      ),
      footer: textBuilder.footer(
        type: item.textType,
        facts: item.facts,
        context: context,
        fallback: item.fallbackFooter,
      ),
    );
  }

  InsightPatternIcon _icon(domain.InsightsPatternKind kind) {
    return switch (kind) {
      domain.InsightsPatternKind.dawn => InsightPatternIcon.dawn,
      domain.InsightsPatternKind.volatility => InsightPatternIcon.volatility,
      domain.InsightsPatternKind.stability => InsightPatternIcon.stability,
      domain.InsightsPatternKind.weekday => InsightPatternIcon.weekday,
      domain.InsightsPatternKind.generic => InsightPatternIcon.generic,
    };
  }
}

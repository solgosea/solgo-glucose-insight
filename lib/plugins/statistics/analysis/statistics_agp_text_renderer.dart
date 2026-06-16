import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_selector.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';

import '../data/seed/statistics_default_text_templates.dart';
import '../domain/text/statistics_text_slot.dart';
import '../domain/text/statistics_text_type.dart';

class StatisticsAgpTextRenderer {
  final PluginTextTemplateSelector selector;
  final PluginTextRenderer renderer;

  const StatisticsAgpTextRenderer({
    this.selector = const PluginTextTemplateSelector(),
    this.renderer = const PluginTextRenderer(
      templates: StatisticsDefaultTextTemplates.all,
    ),
  });

  String renderEmpty() {
    return _render(
      type: InsightTypeCode.agpNoData,
      facts: const {'notEnoughData': true},
    );
  }

  String renderDawn(Map<String, Object?> facts) {
    return _render(type: InsightTypeCode.agpDawnRise, facts: facts);
  }

  String renderPeak(Map<String, Object?> facts) {
    return _render(type: InsightTypeCode.agpMedianPeak, facts: facts);
  }

  String renderVariability(Map<String, Object?> facts) {
    return _render(type: InsightTypeCode.agpVariability, facts: facts);
  }

  String _render({
    required InsightTypeCode type,
    required Map<String, Object?> facts,
  }) {
    final textType = _textTypeFor(type);
    final template = selector.select(
      templates: StatisticsDefaultTextTemplates.all,
      slot: StatisticsTextSlot.agpSummary,
      type: textType,
      facts: facts,
    );
    if (template == null) {
      throw StateError('Missing statistics AGP template for ${type.code}');
    }
    return renderer.render(template.key, facts).body;
  }

  String _textTypeFor(InsightTypeCode type) {
    return switch (type) {
      InsightTypeCode.agpNoData => StatisticsTextType.agpNoData,
      InsightTypeCode.agpDawnRise => StatisticsTextType.agpDawnRise,
      InsightTypeCode.agpMedianPeak => StatisticsTextType.agpMedianPeak,
      InsightTypeCode.agpVariability => StatisticsTextType.agpVariability,
      _ => throw StateError('Unsupported statistics AGP type ${type.code}'),
    };
  }
}

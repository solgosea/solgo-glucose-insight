import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_selector.dart';

import '../../data/seed/insights_default_text_templates.dart';
import '../../data/seed/insights_zh_text_templates.dart';

const _insightsTextTemplates = <PluginTextTemplate>[
  ...InsightsDefaultTextTemplates.all,
  ...InsightsZhTextTemplates.all,
];

class InsightsTextRenderer {
  static const templates = _insightsTextTemplates;

  final PluginTextTemplateSelector selector;
  final PluginTextRenderer renderer;

  const InsightsTextRenderer({
    this.selector = const PluginTextTemplateSelector(),
    this.renderer = const PluginTextRenderer(templates: templates),
  });

  String render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
    String? fallback,
  }) {
    final template = selector.select(
      templates: templates,
      slot: slot,
      type: type,
      facts: facts,
      locale: context.locale,
      fallbackLocale: context.fallbackLocale,
    );
    if (template == null) {
      if (fallback != null) return fallback;
      throw StateError('Missing insights text template for $slot / $type');
    }
    return renderer.renderTemplate(template, facts).body;
  }
}

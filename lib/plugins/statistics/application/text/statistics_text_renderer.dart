import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_selector.dart';

import '../../data/seed/statistics_default_text_templates.dart';
import '../../data/seed/statistics_zh_text_templates.dart';

class StatisticsTextRenderer {
  static const templates = [
    ...StatisticsDefaultTextTemplates.all,
    ...StatisticsZhTextTemplates.all,
  ];

  final PluginTextTemplateSelector selector;
  final PluginTextRenderer renderer;

  const StatisticsTextRenderer({
    this.selector = const PluginTextTemplateSelector(),
    this.renderer = const PluginTextRenderer(
      templates: templates,
    ),
  });

  String render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
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
      throw StateError('Missing statistics text template for $slot / $type');
    }
    return renderer.renderTemplate(template, facts).body;
  }
}

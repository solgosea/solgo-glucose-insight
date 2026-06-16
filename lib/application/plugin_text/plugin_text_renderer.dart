import '../insight/template_renderer.dart';
import 'plugin_rendered_text.dart';
import 'plugin_text_template.dart';

class PluginTextRenderer {
  final TemplateRenderer renderer;
  final List<PluginTextTemplate> templates;

  const PluginTextRenderer({
    required this.templates,
    this.renderer = const TemplateRenderer(),
  });

  PluginRenderedText render(
    String key,
    Map<String, Object?> facts, {
    String? fallback,
  }) {
    final template = _template(key);
    if (template == null) return PluginRenderedText(body: fallback ?? '');
    return PluginRenderedText(
      title: _optional(template.titleTemplate, facts),
      body: renderer.render(template.bodyTemplate, facts),
      footer: _optional(template.footerTemplate, facts),
    );
  }

  PluginTextTemplate? _template(String key) {
    for (final template in templates) {
      if (template.key == key && template.enabled) return template;
    }
    return null;
  }

  String? _optional(String? template, Map<String, Object?> facts) {
    if (template == null || template.isEmpty) return null;
    return renderer.render(template, facts);
  }
}

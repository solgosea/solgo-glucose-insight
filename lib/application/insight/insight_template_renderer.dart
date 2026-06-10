import '../../domain/insight/insight_rendered_text.dart';
import '../../domain/insight/insight_template.dart';
import 'template_renderer.dart';

class InsightTemplateRenderer {
  final TemplateRenderer renderer;

  const InsightTemplateRenderer({this.renderer = const TemplateRenderer()});

  InsightRenderedText render(
    InsightTemplate template,
    Map<String, Object?> facts,
  ) {
    return InsightRenderedText(
      title: _renderOptional(template.titleTemplate, facts),
      eyebrow: _renderOptional(template.eyebrowTemplate, facts),
      body: renderer.render(template.bodyTemplate, facts),
      footer: _renderOptional(template.footerTemplate, facts),
    );
  }

  String? _renderOptional(String? template, Map<String, Object?> facts) {
    if (template == null || template.isEmpty) return null;
    return renderer.render(template, facts);
  }
}

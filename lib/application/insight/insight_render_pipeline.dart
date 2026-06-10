import '../../domain/insight/insight_fact_bundle.dart';
import '../../domain/insight/insight_template.dart';
import '../../domain/insight/narrative_insight.dart';
import 'insight_template_renderer.dart';
import 'insight_template_selector.dart';

class InsightRenderPipeline {
  final InsightTemplateSelector selector;
  final InsightTemplateRenderer renderer;

  const InsightRenderPipeline({
    this.selector = const InsightTemplateSelector(),
    this.renderer = const InsightTemplateRenderer(),
  });

  List<NarrativeInsight> renderAll({
    required List<InsightFactBundle> factBundles,
    required List<InsightTemplate> templates,
    required DateTime generatedAt,
  }) {
    final rendered = <NarrativeInsight>[];
    for (final facts in factBundles) {
      final template = selector.select(facts, templates);
      if (template == null) continue;
      final text = renderer.render(template, facts.facts);
      rendered.add(
        NarrativeInsight(
          id:
              '${template.code}_${generatedAt.millisecondsSinceEpoch}_${rendered.length}',
          module: facts.module,
          slot: facts.slot,
          type: facts.type,
          templateCode: template.code,
          templateVersion: template.version,
          title: text.title,
          eyebrow: text.eyebrow,
          body: text.body,
          footer: text.footer,
          facts: facts.facts,
          generatedAt: generatedAt,
        ),
      );
    }
    rendered.sort((a, b) => _sortKey(a).compareTo(_sortKey(b)));
    return rendered;
  }

  String _sortKey(NarrativeInsight insight) =>
      '${insight.slot.code}_${insight.type.code}_${insight.templateCode}';
}

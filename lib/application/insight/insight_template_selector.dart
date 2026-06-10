import '../../domain/insight/insight_fact_bundle.dart';
import '../../domain/insight/insight_template.dart';

class InsightTemplateSelector {
  const InsightTemplateSelector();

  InsightTemplate? select(
    InsightFactBundle facts,
    List<InsightTemplate> templates,
  ) {
    final candidates =
        templates
            .where(
              (template) =>
                  template.enabled &&
                  template.module == facts.module &&
                  template.slot == facts.slot &&
                  template.type == facts.type &&
                  _hasRequiredFacts(template, facts),
            )
            .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority));

    if (candidates.isNotEmpty) return candidates.first;
    return null;
  }

  bool _hasRequiredFacts(InsightTemplate template, InsightFactBundle bundle) {
    for (final key in template.requiredFacts) {
      if (!bundle.facts.containsKey(key)) return false;
    }
    return true;
  }
}

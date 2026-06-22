import '../../domain/insight/insight_fact_bundle.dart';
import '../../domain/insight/insight_template.dart';

class InsightTemplateSelector {
  const InsightTemplateSelector();

  InsightTemplate? select(
    InsightFactBundle facts,
    List<InsightTemplate> templates, {
    String locale = 'en',
    String fallbackLocale = 'en',
  }) {
    final candidates = templates
        .where((template) =>
            template.enabled &&
            template.module == facts.module &&
            template.slot == facts.slot &&
            template.type == facts.type &&
            _hasRequiredFacts(template, facts))
        .toList();

    final localeCandidates = candidates
        .where((template) => _matchesLocale(template.locale, locale))
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (localeCandidates.isNotEmpty) return localeCandidates.first;

    final fallbackCandidates = candidates
        .where((template) => _matchesLocale(template.locale, fallbackLocale))
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (fallbackCandidates.isNotEmpty) return fallbackCandidates.first;

    candidates.sort((a, b) => a.priority.compareTo(b.priority));
    if (candidates.isNotEmpty) return candidates.first;
    return null;
  }

  bool _matchesLocale(String templateLocale, String locale) {
    final template = templateLocale.toLowerCase().replaceAll('_', '-');
    final requested = locale.toLowerCase().replaceAll('_', '-');
    return template == requested ||
        template.split('-').first == requested.split('-').first;
  }

  bool _hasRequiredFacts(
    InsightTemplate template,
    InsightFactBundle bundle,
  ) {
    for (final key in template.requiredFacts) {
      if (!bundle.facts.containsKey(key)) return false;
    }
    return true;
  }
}

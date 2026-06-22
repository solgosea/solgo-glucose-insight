import 'plugin_text_template.dart';

class PluginTextTemplateSelector {
  const PluginTextTemplateSelector();

  PluginTextTemplate? select({
    required List<PluginTextTemplate> templates,
    required String slot,
    required String type,
    required Map<String, Object?> facts,
    String? locale,
    String fallbackLocale = 'en',
  }) {
    if (locale == null || locale.trim().isEmpty) {
      return _bestMatch(
        templates: templates,
        slot: slot,
        type: type,
        facts: facts,
      );
    }
    for (final candidate in _localeCandidates(locale, fallbackLocale)) {
      final match = _bestMatch(
        templates: templates,
        slot: slot,
        type: type,
        facts: facts,
        locale: candidate,
      );
      if (match != null) return match;
    }
    return null;
  }

  PluginTextTemplate? _bestMatch({
    required List<PluginTextTemplate> templates,
    required String slot,
    required String type,
    required Map<String, Object?> facts,
    String? locale,
  }) {
    final normalizedLocale = locale == null ? null : _normalizeLocale(locale);
    final matches = templates.where((template) {
      if (!template.enabled) return false;
      if (template.slot != slot || template.type != type) return false;
      if (normalizedLocale != null &&
          _normalizeLocale(template.locale) != normalizedLocale) {
        return false;
      }
      return template.requiredFacts.every((fact) => facts[fact] != null);
    }).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (matches.isEmpty) return null;
    return matches.first;
  }

  List<String> _localeCandidates(String locale, String fallbackLocale) {
    final normalized = _normalizeLocale(locale);
    final fallback = _normalizeLocale(fallbackLocale);
    final raw = <String>[
      normalized,
      if (normalized.contains('_')) normalized.split('_').first,
      fallback,
    ];
    final seen = <String>{};
    final candidates = <String>[];
    for (final candidate in raw) {
      if (candidate.isEmpty || seen.contains(candidate)) continue;
      seen.add(candidate);
      candidates.add(candidate);
    }
    return candidates;
  }

  String _normalizeLocale(String locale) {
    final normalized = locale.trim().replaceAll('-', '_').toLowerCase();
    if (normalized.startsWith('zh')) return 'zh';
    if (normalized.startsWith('en')) return 'en';
    return normalized;
  }
}

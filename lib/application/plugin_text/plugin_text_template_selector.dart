import 'plugin_text_template.dart';

class PluginTextTemplateSelector {
  const PluginTextTemplateSelector();

  PluginTextTemplate? select({
    required List<PluginTextTemplate> templates,
    required String slot,
    required String type,
    required Map<String, Object?> facts,
  }) {
    final matches = templates.where((template) {
      if (!template.enabled) return false;
      if (template.slot != slot || template.type != type) return false;
      return template.requiredFacts.every((fact) => facts[fact] != null);
    }).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (matches.isEmpty) return null;
    return matches.first;
  }
}

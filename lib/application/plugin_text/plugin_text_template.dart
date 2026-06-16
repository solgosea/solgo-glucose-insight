class PluginTextTemplate {
  final String key;
  final String slot;
  final String type;
  final String locale;
  final int version;
  final String? titleTemplate;
  final String bodyTemplate;
  final String? footerTemplate;
  final List<String> requiredFacts;
  final bool enabled;
  final int priority;
  final int updatedAtMs;

  const PluginTextTemplate({
    required this.key,
    required this.slot,
    required this.type,
    required this.bodyTemplate,
    this.locale = 'en',
    this.version = 1,
    this.titleTemplate,
    this.footerTemplate,
    this.requiredFacts = const [],
    this.enabled = true,
    this.priority = 100,
    this.updatedAtMs = 0,
  });
}

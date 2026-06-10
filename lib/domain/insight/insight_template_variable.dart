class InsightTemplateVariable {
  final String templateCode;
  final String key;
  final String valueType;
  final String? formatRule;
  final bool required;
  final String? description;

  const InsightTemplateVariable({
    required this.templateCode,
    required this.key,
    required this.valueType,
    this.formatRule,
    this.required = true,
    this.description,
  });
}

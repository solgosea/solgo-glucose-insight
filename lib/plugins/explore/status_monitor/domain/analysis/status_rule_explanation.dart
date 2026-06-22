class StatusRuleExplanation {
  final String summary;
  final String detail;
  final String? templateKey;
  final Map<String, Object?> facts;

  const StatusRuleExplanation({
    required this.summary,
    required this.detail,
    this.templateKey,
    this.facts = const {},
  });
}

enum AlertRuleScope {
  self,
  subject,
  plugin;

  String get code => name;

  static AlertRuleScope fromCode(String code) {
    return AlertRuleScope.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertRuleScope.self,
    );
  }
}

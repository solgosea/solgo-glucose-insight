enum AlertRuleComparator {
  lessThan,
  greaterThan,
  rateBelow,
  staleForMinutes;

  String get code => switch (this) {
    AlertRuleComparator.lessThan => 'lt',
    AlertRuleComparator.greaterThan => 'gt',
    AlertRuleComparator.rateBelow => 'rate_below',
    AlertRuleComparator.staleForMinutes => 'stale_for_minutes',
  };

  static AlertRuleComparator fromCode(String code) {
    return AlertRuleComparator.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertRuleComparator.lessThan,
    );
  }
}

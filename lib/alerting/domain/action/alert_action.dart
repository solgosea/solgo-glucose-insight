enum AlertAction {
  acknowledge,
  snooze,
  dismiss,
  stop;

  String get code => name;

  static AlertAction fromCode(String code) {
    return AlertAction.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertAction.dismiss,
    );
  }
}

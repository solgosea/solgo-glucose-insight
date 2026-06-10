enum AlertLevel {
  info,
  warning,
  critical;

  String get code => name;

  static AlertLevel fromCode(String code) {
    return AlertLevel.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertLevel.info,
    );
  }
}

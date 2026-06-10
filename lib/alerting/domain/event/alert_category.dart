class AlertCategory {
  static const glucoseLow = AlertCategory('glucose_low');
  static const glucoseUrgentLow = AlertCategory('glucose_urgent_low');
  static const glucoseHigh = AlertCategory('glucose_high');
  static const glucoseRapidFall = AlertCategory('glucose_rapid_fall');
  static const noData = AlertCategory('no_data');
  static const syncFailure = AlertCategory('sync_failure');
  static const system = AlertCategory('system');

  final String code;

  const AlertCategory(this.code);

  String get name => code;

  static AlertCategory fromCode(String code) {
    final normalized = code.trim();
    return normalized.isEmpty ? system : AlertCategory(normalized);
  }

  @override
  bool operator ==(Object other) {
    return other is AlertCategory && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

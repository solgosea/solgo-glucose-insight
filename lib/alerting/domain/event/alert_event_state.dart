enum AlertEventState {
  received,
  shown,
  acknowledged,
  snoozed,
  suppressed,
  dismissed,
  expired;

  String get code => name;

  static AlertEventState fromCode(String code) {
    return AlertEventState.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertEventState.received,
    );
  }
}

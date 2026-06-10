enum AlertDeliveryState {
  planned,
  delivering,
  delivered,
  skipped,
  failed;

  String get code => name;

  static AlertDeliveryState fromCode(String code) {
    return AlertDeliveryState.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertDeliveryState.planned,
    );
  }
}

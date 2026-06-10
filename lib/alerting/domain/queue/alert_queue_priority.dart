enum AlertQueuePriority {
  low,
  normal,
  high,
  critical;

  String get code => name;

  int get rank => switch (this) {
    AlertQueuePriority.low => 0,
    AlertQueuePriority.normal => 1,
    AlertQueuePriority.high => 2,
    AlertQueuePriority.critical => 3,
  };

  static AlertQueuePriority fromCode(String code) {
    return AlertQueuePriority.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertQueuePriority.normal,
    );
  }
}

enum AlertQueueMessageState {
  pending,
  processing,
  processed,
  failed;

  String get code => name;

  static AlertQueueMessageState fromCode(String code) {
    return AlertQueueMessageState.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertQueueMessageState.pending,
    );
  }
}

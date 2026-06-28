class StatusCheckSessionId {
  final String value;

  const StatusCheckSessionId(this.value);

  factory StatusCheckSessionId.now(DateTime now) {
    return StatusCheckSessionId('status-${now.microsecondsSinceEpoch}');
  }

  @override
  String toString() => value;
}

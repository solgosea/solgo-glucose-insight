class StatusResponseSnapshot {
  final bool reachable;
  final int? statusCode;
  final Duration elapsed;
  final String? errorLabel;

  const StatusResponseSnapshot({
    required this.reachable,
    this.statusCode,
    required this.elapsed,
    this.errorLabel,
  });
}

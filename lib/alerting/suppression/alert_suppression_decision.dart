class AlertSuppressionDecision {
  final bool suppressed;
  final String? reason;

  const AlertSuppressionDecision._({required this.suppressed, this.reason});

  const AlertSuppressionDecision.allowed() : this._(suppressed: false);

  const AlertSuppressionDecision.suppressed(String reason)
    : this._(suppressed: true, reason: reason);
}

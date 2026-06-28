class StatusTraceConfidencePolicy {
  const StatusTraceConfidencePolicy();

  String label(double confidence) {
    final value = confidence.clamp(0, 1);
    if (value >= .8) return 'High confidence';
    if (value >= .45) return 'Partial confidence';
    return 'Low confidence';
  }
}

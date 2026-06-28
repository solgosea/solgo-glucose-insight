class StatusEvidenceTraceConfidence {
  final double value;
  final String label;

  const StatusEvidenceTraceConfidence({
    required this.value,
    required this.label,
  });

  factory StatusEvidenceTraceConfidence.fromValue(double value) {
    final clamped = value.clamp(0, 1).toDouble();
    return StatusEvidenceTraceConfidence(
      value: clamped,
      label: clamped >= .8
          ? 'High confidence'
          : clamped >= .45
              ? 'Partial confidence'
              : 'Low confidence',
    );
  }

  static const unknown = StatusEvidenceTraceConfidence(
    value: 0,
    label: 'Unknown confidence',
  );

  Map<String, Object?> toJson() => {
        'value': value,
        'label': label,
      };
}

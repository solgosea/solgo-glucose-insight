class StatusEvidenceTraceSummary {
  final String label;
  final String sourceLabel;
  final String stateLabel;
  final String confidenceLabel;
  final DateTime? observedAt;

  const StatusEvidenceTraceSummary({
    required this.label,
    required this.sourceLabel,
    required this.stateLabel,
    required this.confidenceLabel,
    this.observedAt,
  });

  static const unavailable = StatusEvidenceTraceSummary(
    label: 'Evidence unavailable',
    sourceLabel: 'Unavailable',
    stateLabel: 'Unknown',
    confidenceLabel: 'Unknown confidence',
  );

  Map<String, Object?> toJson() => {
        'label': label,
        'sourceLabel': sourceLabel,
        'stateLabel': stateLabel,
        'confidenceLabel': confidenceLabel,
        'observedAt': observedAt?.millisecondsSinceEpoch,
      };
}

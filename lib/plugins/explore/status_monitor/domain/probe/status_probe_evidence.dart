class StatusProbeEvidence {
  final String label;
  final String value;
  final DateTime? observedAt;
  final Map<String, Object?> metadata;

  const StatusProbeEvidence({
    required this.label,
    required this.value,
    this.observedAt,
    this.metadata = const {},
  });

  Map<String, Object?> toJson() => {
        'label': label,
        'value': value,
        'observedAtMs': observedAt?.millisecondsSinceEpoch,
        'metadata': metadata,
      };
}

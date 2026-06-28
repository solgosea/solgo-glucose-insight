class StatusEvidenceTraceState {
  final String rawState;
  final String mappedState;
  final String label;

  const StatusEvidenceTraceState({
    required this.rawState,
    required this.mappedState,
    required this.label,
  });

  static const unknown = StatusEvidenceTraceState(
    rawState: 'unknown',
    mappedState: 'unknown',
    label: 'Unknown',
  );

  Map<String, Object?> toJson() => {
        'rawState': rawState,
        'mappedState': mappedState,
        'label': label,
      };
}

class StatusEvidenceTraceRef {
  final String label;
  final String value;
  final String? path;

  const StatusEvidenceTraceRef({
    required this.label,
    required this.value,
    this.path,
  });

  Map<String, Object?> toJson() => {
        'label': label,
        'value': value,
        'path': path,
      };
}

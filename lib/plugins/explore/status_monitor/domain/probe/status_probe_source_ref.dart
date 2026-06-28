class StatusProbeSourceRef {
  final String source;
  final String path;
  final String? detail;

  const StatusProbeSourceRef({
    required this.source,
    required this.path,
    this.detail,
  });

  Map<String, Object?> toJson() => {
        'source': source,
        'path': path,
        'detail': detail,
      };
}

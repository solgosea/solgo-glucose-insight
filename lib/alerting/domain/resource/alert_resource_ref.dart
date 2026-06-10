class AlertResourceRef {
  final String id;
  final String resourceType;
  final String resourceKey;
  final String displayName;
  final String uri;
  final Map<String, Object?> metadata;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertResourceRef({
    required this.id,
    required this.resourceType,
    required this.resourceKey,
    required this.displayName,
    required this.uri,
    required this.metadata,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
}

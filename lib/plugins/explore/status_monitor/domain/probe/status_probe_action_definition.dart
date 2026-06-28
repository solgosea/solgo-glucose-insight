class StatusProbeActionDefinition {
  final String id;
  final String labelKey;
  final String? route;
  final String? externalUrl;

  const StatusProbeActionDefinition({
    required this.id,
    required this.labelKey,
    this.route,
    this.externalUrl,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        'labelKey': labelKey,
        'route': route,
        'externalUrl': externalUrl,
      };
}

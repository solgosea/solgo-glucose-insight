class BackgroundRuntimeReason {
  static const selfDatasourceEnabled = BackgroundRuntimeReason(
    code: 'self.datasource.enabled',
    label: 'self datasource',
    pluginId: 'core.datasource',
  );

  final String code;
  final String label;
  final String pluginId;

  const BackgroundRuntimeReason({
    required this.code,
    required this.label,
    required this.pluginId,
  });

  @override
  bool operator ==(Object other) {
    return other is BackgroundRuntimeReason && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

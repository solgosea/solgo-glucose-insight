class PluginId {
  final String value;

  const PluginId(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PluginId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

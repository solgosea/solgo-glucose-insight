class PluginSlotKey {
  final String value;

  const PluginSlotKey(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PluginSlotKey &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

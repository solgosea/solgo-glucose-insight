class AlertSourceId {
  final String value;

  const AlertSourceId(this.value);

  @override
  bool operator ==(Object other) {
    return other is AlertSourceId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class AlertEventSource {
  static const xdripLocal = AlertEventSource('xdrip_local');
  static const nightscout = AlertEventSource('nightscout');
  static const backgroundSync = AlertEventSource('background_sync');
  static const system = AlertEventSource('system');

  final String code;

  const AlertEventSource(this.code);

  String get name => code;

  static AlertEventSource fromCode(String code) {
    final normalized = code.trim();
    return normalized.isEmpty ? system : AlertEventSource(normalized);
  }

  @override
  bool operator ==(Object other) {
    return other is AlertEventSource && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

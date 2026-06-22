enum StatusMonitorWidgetDisplayMode {
  full('full'),
  rangeOnly('range_only'),
  private('private'),
  off('off');

  final String code;

  const StatusMonitorWidgetDisplayMode(this.code);

  static StatusMonitorWidgetDisplayMode fromCode(String? code) {
    return StatusMonitorWidgetDisplayMode.values.firstWhere(
      (mode) => mode.code == code,
      orElse: () => StatusMonitorWidgetDisplayMode.full,
    );
  }
}

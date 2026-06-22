enum StatusFloatingMode {
  enabled('enabled'),
  disabled('disabled');

  final String code;

  const StatusFloatingMode(this.code);

  static StatusFloatingMode fromCode(String? code) {
    return StatusFloatingMode.values.firstWhere(
      (mode) => mode.code == code,
      orElse: () => StatusFloatingMode.enabled,
    );
  }
}

enum FloatingGlanceMode {
  enabled('enabled'),
  disabled('disabled');

  final String code;

  const FloatingGlanceMode(this.code);

  static FloatingGlanceMode fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => FloatingGlanceMode.enabled,
    );
  }
}

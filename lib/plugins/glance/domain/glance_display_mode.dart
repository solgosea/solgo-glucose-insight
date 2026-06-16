enum GlanceDisplayMode {
  fullValue('full_value', 'Full value'),
  rangeOnly('range_only', 'Range only'),
  private('private', 'Private'),
  minimal('minimal', 'Minimal'),
  off('off', 'Off');

  final String code;
  final String label;

  const GlanceDisplayMode(this.code, this.label);

  static GlanceDisplayMode fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceDisplayMode.fullValue,
    );
  }
}

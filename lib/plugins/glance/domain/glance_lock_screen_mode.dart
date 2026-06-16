enum GlanceLockScreenMode {
  fullValue('full_value', 'Full value'),
  rangeOnly('range_only', 'Range only'),
  private('private', 'Private'),
  off('off', 'Off');

  final String code;
  final String label;

  const GlanceLockScreenMode(this.code, this.label);

  static GlanceLockScreenMode fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceLockScreenMode.fullValue,
    );
  }
}

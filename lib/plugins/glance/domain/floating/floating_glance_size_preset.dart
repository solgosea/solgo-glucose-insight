enum FloatingGlanceSizePreset {
  small('small'),
  medium('medium'),
  large('large');

  final String code;

  const FloatingGlanceSizePreset(this.code);

  static FloatingGlanceSizePreset fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => FloatingGlanceSizePreset.medium,
    );
  }
}

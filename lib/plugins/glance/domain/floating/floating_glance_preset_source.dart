enum FloatingGlancePresetSource {
  automatic('automatic'),
  user('user');

  final String code;

  const FloatingGlancePresetSource(this.code);

  static FloatingGlancePresetSource fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => FloatingGlancePresetSource.automatic,
    );
  }
}

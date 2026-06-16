enum FloatingGlanceDisplayStyle {
  pill('pill', 'Compact pill'),
  miniCard('mini_card', 'Mini card');

  final String code;
  final String label;

  const FloatingGlanceDisplayStyle(this.code, this.label);

  static FloatingGlanceDisplayStyle fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => FloatingGlanceDisplayStyle.pill,
    );
  }
}

enum FloatingGlanceFormFactor {
  pill('pill'),
  card('card');

  final String code;

  const FloatingGlanceFormFactor(this.code);

  static FloatingGlanceFormFactor fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => FloatingGlanceFormFactor.pill,
    );
  }
}

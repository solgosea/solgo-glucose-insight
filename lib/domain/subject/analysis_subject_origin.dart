class AnalysisSubjectOrigin {
  static const self = AnalysisSubjectOrigin('self');
  static const external = AnalysisSubjectOrigin('external');
  static const values = [self, external];

  final String code;

  const AnalysisSubjectOrigin(this.code);

  String get name => code;

  static AnalysisSubjectOrigin fromCode(String? code) {
    final normalized = code?.trim();
    if (normalized == null || normalized.isEmpty) {
      return external;
    }
    for (final value in values) {
      if (value.code == normalized) return value;
    }
    return AnalysisSubjectOrigin(normalized);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalysisSubjectOrigin && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

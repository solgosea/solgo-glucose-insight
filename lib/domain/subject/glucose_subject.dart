class GlucoseSubject {
  static const selfId = 'self';

  const GlucoseSubject._();

  static String normalizeKey(String key) {
    return key.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_:-]'), '_');
  }

  static bool isSelf(String subjectId) => subjectId == selfId;
}

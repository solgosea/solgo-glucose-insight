class AlertIdGenerator {
  const AlertIdGenerator();

  String newId(String prefix) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final marker = Object().hashCode.toRadixString(16);
    return '${prefix}_${now}_$marker';
  }

  String stableId(String prefix, String seed) {
    return '${prefix}_${seed.hashCode.toUnsigned(32).toRadixString(16)}';
  }
}

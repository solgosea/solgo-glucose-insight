class JsonSnapshot {
  final String key;
  final DateTime windowStart;
  final DateTime windowEnd;
  final Map<String, Object?> payload;
  final DateTime updatedAt;

  const JsonSnapshot({
    required this.key,
    required this.windowStart,
    required this.windowEnd,
    required this.payload,
    required this.updatedAt,
  });
}

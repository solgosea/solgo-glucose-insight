class RawGlucoseReading {
  final String id;
  final String source;
  final String sourceRecordId;
  final DateTime timestamp;
  final int bucketMs;
  final double value;
  final double? ratePerMin;
  final DateTime receivedAt;
  final String? payloadJson;

  const RawGlucoseReading({
    required this.id,
    required this.source,
    required this.sourceRecordId,
    required this.timestamp,
    required this.bucketMs,
    required this.value,
    required this.receivedAt,
    this.ratePerMin,
    this.payloadJson,
  });
}

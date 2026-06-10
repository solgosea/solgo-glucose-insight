class GlucoseGap {
  final String id;
  final DateTime start;
  final DateTime end;
  final int durationMinutes;
  final String source;

  const GlucoseGap({
    required this.id,
    required this.start,
    required this.end,
    required this.durationMinutes,
    required this.source,
  });
}

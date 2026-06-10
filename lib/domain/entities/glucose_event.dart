enum GlucoseEventType {
  highEpisode,
  lowEpisode,
  rise,
  recovery,
  stableWindow,
  firstReading,
  dawnPhenomenon,
}

enum LowSeverity { mild, significant, severe }

class GlucoseEvent {
  final GlucoseEventType type;
  final DateTime time;
  final double value;
  final DateTime? endTime;
  final double? peakOrNadir;
  final double? ratePerMin;
  final LowSeverity? lowSeverity;
  final bool isNocturnal;
  final double? areaOutOfRange; // mmol-min

  const GlucoseEvent({
    required this.type,
    required this.time,
    required this.value,
    this.endTime,
    this.peakOrNadir,
    this.ratePerMin,
    this.lowSeverity,
    this.isNocturnal = false,
    this.areaOutOfRange,
  });

  int get durationMinutes =>
      endTime != null ? endTime!.difference(time).inMinutes : 0;
}

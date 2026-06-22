import '../status_level.dart';

class CgmFlatPeriod {
  final DateTime start;
  final DateTime end;
  final Duration duration;
  final StatusLevel level;

  const CgmFlatPeriod({
    required this.start,
    required this.end,
    required this.duration,
    required this.level,
  });

  Map<String, Object?> toJson() => {
        'startMs': start.millisecondsSinceEpoch,
        'endMs': end.millisecondsSinceEpoch,
        'durationMinutes': duration.inMinutes,
        'level': level.name,
      };
}

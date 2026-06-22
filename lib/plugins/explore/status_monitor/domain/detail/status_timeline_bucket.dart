import '../status_level.dart';

class StatusTimelineBucket {
  final DateTime start;
  final DateTime end;
  final StatusLevel level;
  final String label;
  final num? value;

  const StatusTimelineBucket({
    required this.start,
    required this.end,
    required this.level,
    required this.label,
    this.value,
  });

  Map<String, Object?> toJson() => {
        'startMs': start.millisecondsSinceEpoch,
        'endMs': end.millisecondsSinceEpoch,
        'level': level.name,
        'label': label,
        'value': value,
      };
}

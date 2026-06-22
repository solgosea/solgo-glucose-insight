import '../status_level.dart';

class AapsLoopTimelineBucket {
  final DateTime at;
  final StatusLevel level;
  final String label;

  const AapsLoopTimelineBucket({
    required this.at,
    required this.level,
    required this.label,
  });

  Map<String, Object?> toJson() => {
        'at': at.millisecondsSinceEpoch,
        'level': level.name,
        'label': label,
      };
}

import '../status_level.dart';

class XdripCompletenessBucket {
  final DateTime start;
  final DateTime end;
  final int observed;
  final int expected;
  final StatusLevel level;

  const XdripCompletenessBucket({
    required this.start,
    required this.end,
    required this.observed,
    required this.expected,
    required this.level,
  });

  double get ratio => expected == 0 ? 0 : observed / expected;

  Map<String, Object?> toJson() => {
        'startMs': start.millisecondsSinceEpoch,
        'endMs': end.millisecondsSinceEpoch,
        'observed': observed,
        'expected': expected,
        'level': level.name,
      };
}

import '../status_level.dart';

class StatusResponseTimePoint {
  final DateTime at;
  final Duration elapsed;
  final StatusLevel level;
  final bool timeout;
  final String endpoint;

  const StatusResponseTimePoint({
    required this.at,
    required this.elapsed,
    required this.level,
    required this.endpoint,
    this.timeout = false,
  });

  Map<String, Object?> toJson() => {
        'atMs': at.millisecondsSinceEpoch,
        'elapsedMs': elapsed.inMilliseconds,
        'level': level.name,
        'timeout': timeout,
        'endpoint': endpoint,
      };
}

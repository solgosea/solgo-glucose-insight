import '../status_level.dart';

class StatusEndpointProbe {
  final String endpoint;
  final String label;
  final StatusLevel level;
  final bool reachable;
  final int? statusCode;
  final Duration elapsed;
  final DateTime checkedAt;
  final String? message;

  const StatusEndpointProbe({
    required this.endpoint,
    required this.label,
    required this.level,
    required this.reachable,
    required this.elapsed,
    required this.checkedAt,
    this.statusCode,
    this.message,
  });

  Map<String, Object?> toJson() => {
        'endpoint': endpoint,
        'label': label,
        'level': level.name,
        'reachable': reachable,
        'statusCode': statusCode,
        'elapsedMs': elapsed.inMilliseconds,
        'checkedAtMs': checkedAt.millisecondsSinceEpoch,
        'message': message,
      };
}

import '../status_level.dart';

class XdripLocalServiceProbe {
  final bool reachable;
  final int? statusCode;
  final Duration elapsed;
  final StatusLevel level;
  final String message;

  const XdripLocalServiceProbe({
    required this.reachable,
    required this.elapsed,
    required this.level,
    required this.message,
    this.statusCode,
  });

  Map<String, Object?> toJson() => {
        'reachable': reachable,
        'statusCode': statusCode,
        'elapsedMs': elapsed.inMilliseconds,
        'level': level.name,
        'message': message,
      };
}

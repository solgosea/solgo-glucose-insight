import 'juggluco_broadcast_format.dart';
import 'juggluco_broadcast_path.dart';

class JugglucoBroadcastPathSnapshot {
  final JugglucoBroadcastPath path;
  final DateTime? at;
  final double? glucose;
  final String? unit;
  final JugglucoBroadcastFormat format;
  final String? message;

  const JugglucoBroadcastPathSnapshot({
    required this.path,
    this.at,
    this.glucose,
    this.unit,
    this.format = JugglucoBroadcastFormat.unknown,
    this.message,
  });

  Duration? age(DateTime now) {
    final value = at;
    if (value == null) return null;
    return now.difference(value).abs();
  }
}

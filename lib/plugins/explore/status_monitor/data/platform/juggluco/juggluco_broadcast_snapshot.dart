import '../../../domain/juggluco/juggluco_broadcast_format.dart';
import '../../../domain/juggluco/juggluco_broadcast_path.dart';
import '../../../domain/juggluco/juggluco_broadcast_path_snapshot.dart';
import '../../../domain/juggluco/juggluco_freshness_bucket.dart';

class JugglucoBroadcastSnapshot {
  final bool receiverConfigured;
  final bool broadcastObserved;
  final DateTime? latestBroadcastAt;
  final double? latestGlucose;
  final String? unit;
  final JugglucoBroadcastFormat broadcastFormat;
  final JugglucoBroadcastPath latestPath;
  final List<JugglucoBroadcastPathSnapshot> latestByPath;
  final String? sanitizedMessage;
  final List<JugglucoFreshnessBucket> timeline;

  const JugglucoBroadcastSnapshot({
    required this.receiverConfigured,
    required this.broadcastObserved,
    this.latestBroadcastAt,
    this.latestGlucose,
    this.unit,
    this.broadcastFormat = JugglucoBroadcastFormat.unknown,
    this.latestPath = JugglucoBroadcastPath.unknown,
    this.latestByPath = const [],
    this.sanitizedMessage,
    this.timeline = const [],
  });
}

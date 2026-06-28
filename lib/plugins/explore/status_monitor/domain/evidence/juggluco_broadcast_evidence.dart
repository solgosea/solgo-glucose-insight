import '../juggluco/juggluco_broadcast_format.dart';
import '../juggluco/juggluco_broadcast_path.dart';
import '../juggluco/juggluco_broadcast_path_snapshot.dart';
import '../juggluco/juggluco_freshness_bucket.dart';

class JugglucoBroadcastEvidence {
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
  final DateTime generatedAt;

  const JugglucoBroadcastEvidence({
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
    required this.generatedAt,
  });

  const JugglucoBroadcastEvidence.none({
    required this.generatedAt,
  })  : receiverConfigured = false,
        broadcastObserved = false,
        latestBroadcastAt = null,
        latestGlucose = null,
        unit = null,
        broadcastFormat = JugglucoBroadcastFormat.unknown,
        latestPath = JugglucoBroadcastPath.unknown,
        latestByPath = const [],
        sanitizedMessage = null,
        timeline = const [];

  Duration? latestAge(DateTime now) {
    final latest = latestBroadcastAt;
    if (latest == null) return null;
    return now.difference(latest).abs();
  }

  bool get hasLatest => broadcastObserved && latestBroadcastAt != null;

  List<JugglucoBroadcastPathSnapshot> get xdripCompatiblePaths {
    return latestByPath
        .where((snapshot) => snapshot.path.isXdripCompatible)
        .toList(growable: false);
  }

  JugglucoBroadcastPathSnapshot? get latestXdripCompatiblePath {
    final items = xdripCompatiblePaths
        .where((snapshot) => snapshot.at != null)
        .toList(growable: false)
      ..sort((a, b) => b.at!.compareTo(a.at!));
    return items.isEmpty ? null : items.first;
  }

  bool get hasXdripCompatiblePath => latestXdripCompatiblePath != null;

  Duration? latestXdripCompatibleAge(DateTime now) {
    return latestXdripCompatiblePath?.age(now);
  }
}

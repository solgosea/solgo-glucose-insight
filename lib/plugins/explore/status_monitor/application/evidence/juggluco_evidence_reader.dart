import '../../data/platform/juggluco/juggluco_broadcast_bridge.dart';
import '../../data/platform/juggluco/method_channel_juggluco_broadcast_bridge.dart';
import '../../domain/evidence/juggluco_broadcast_evidence.dart';

class JugglucoEvidenceReader {
  final JugglucoBroadcastBridge bridge;

  const JugglucoEvidenceReader({
    this.bridge = const MethodChannelJugglucoBroadcastBridge(),
  });

  Future<JugglucoBroadcastEvidence> read({required DateTime now}) async {
    try {
      final snapshot = await bridge.latest();
      return JugglucoBroadcastEvidence(
        receiverConfigured: snapshot.receiverConfigured,
        broadcastObserved: snapshot.broadcastObserved,
        latestBroadcastAt: snapshot.latestBroadcastAt,
        latestGlucose: snapshot.latestGlucose,
        unit: snapshot.unit,
        broadcastFormat: snapshot.broadcastFormat,
        latestPath: snapshot.latestPath,
        latestByPath: snapshot.latestByPath,
        sanitizedMessage: snapshot.sanitizedMessage,
        timeline: snapshot.timeline,
        generatedAt: now,
      );
    } catch (_) {
      return JugglucoBroadcastEvidence.none(generatedAt: now);
    }
  }
}

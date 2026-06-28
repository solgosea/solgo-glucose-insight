import '../../data/platform/xdrip/method_channel_xdrip_broadcast_bridge.dart';
import '../../data/platform/xdrip/xdrip_broadcast_bridge.dart';
import '../../domain/xdrip/xdrip_broadcast_evidence.dart';

class XdripBroadcastEvidenceReader {
  final XdripBroadcastBridge bridge;

  const XdripBroadcastEvidenceReader({
    this.bridge = const MethodChannelXdripBroadcastBridge(),
  });

  Future<XdripBroadcastEvidence> read({required DateTime now}) async {
    try {
      final snapshot = await bridge.latest();
      return XdripBroadcastEvidence(
        receiverConfigured: snapshot.receiverConfigured,
        broadcastObserved: snapshot.broadcastObserved,
        latestBroadcastAt: snapshot.latestBroadcastAt,
        payload: snapshot.payload,
        timeline: snapshot.timeline,
        generatedAt: now,
      );
    } catch (_) {
      return XdripBroadcastEvidence.none(generatedAt: now);
    }
  }
}

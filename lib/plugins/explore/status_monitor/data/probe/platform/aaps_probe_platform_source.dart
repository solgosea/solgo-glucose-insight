import '../../platform/aaps/aaps_evidence_bridge.dart';
import '../../platform/aaps/aaps_evidence_snapshot.dart';
import '../../platform/aaps/method_channel_aaps_evidence_bridge.dart';

class AapsProbePlatformSource {
  final AapsEvidenceBridge bridge;

  const AapsProbePlatformSource({
    this.bridge = const MethodChannelAapsEvidenceBridge(),
  });

  Future<AapsEvidenceSnapshot> latestEvidence() => bridge.latest();

  bool get isSupported => bridge.isSupported;
}

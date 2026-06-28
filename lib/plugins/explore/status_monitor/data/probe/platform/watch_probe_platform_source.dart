import '../../platform/watch/method_channel_watch_evidence_bridge.dart';
import '../../platform/watch/watch_evidence_bridge.dart';
import '../../platform/watch/watch_evidence_snapshot.dart';

class WatchProbePlatformSource {
  final WatchEvidenceBridge bridge;

  const WatchProbePlatformSource({
    this.bridge = const MethodChannelWatchEvidenceBridge(),
  });

  Future<WatchEvidenceSnapshot> latestEvidence() => bridge.latest();

  bool get isSupported => bridge.isSupported;
}

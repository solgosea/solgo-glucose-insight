import 'watch_evidence_snapshot.dart';

abstract interface class WatchEvidenceBridge {
  bool get isSupported;

  Future<WatchEvidenceSnapshot> latest();
}

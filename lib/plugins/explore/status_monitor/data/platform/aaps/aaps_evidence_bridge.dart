import 'aaps_evidence_snapshot.dart';

abstract interface class AapsEvidenceBridge {
  bool get isSupported;

  Future<AapsEvidenceSnapshot> latest();
}

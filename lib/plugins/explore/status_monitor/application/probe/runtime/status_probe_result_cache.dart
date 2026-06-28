import '../../../domain/probe/status_probe_evidence_bundle.dart';

class StatusProbeResultCache {
  StatusProbeEvidenceBundle? _latest;

  StatusProbeEvidenceBundle? get latest => _latest;

  void update(StatusProbeEvidenceBundle bundle) {
    _latest = bundle;
  }

  void clear() {
    _latest = null;
  }
}

import '../../../domain/probe/status_probe_evidence_bundle.dart';

class StatusProbeHubFactAdapter {
  const StatusProbeHubFactAdapter();

  Map<String, Object?> adapt(StatusProbeEvidenceBundle bundle) {
    return {
      for (final suite in bundle.suites)
        suite.suiteId: {
          'state': suite.state.name,
          'confidence': suite.confidence,
          'latestUsefulEvidenceAtMs':
              suite.latestUsefulEvidenceAt?.millisecondsSinceEpoch,
        },
    };
  }
}

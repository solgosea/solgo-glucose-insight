import '../../../domain/probe/status_probe_evidence_bundle.dart';

class StatusProbeComponentSnapshotBuilder {
  const StatusProbeComponentSnapshotBuilder();

  Map<String, Object?> build(StatusProbeEvidenceBundle bundle) {
    return {
      'subjectId': bundle.subjectId,
      'generatedAtMs': bundle.generatedAt.millisecondsSinceEpoch,
      'suiteCount': bundle.suites.length,
    };
  }
}

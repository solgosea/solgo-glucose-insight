import '../../../domain/probe/status_probe_evidence_bundle.dart';
import '../../../domain/probe/status_probe_run_snapshot.dart';
import '../../../domain/probe/status_probe_suite_result.dart';

class StatusProbeEvidenceBundleBuilder {
  const StatusProbeEvidenceBundleBuilder();

  StatusProbeEvidenceBundle build({
    required String subjectId,
    required DateTime generatedAt,
    required List<StatusProbeSuiteResult> suites,
  }) {
    return StatusProbeEvidenceBundle(
      subjectId: subjectId,
      generatedAt: generatedAt,
      suites: suites,
    );
  }

  StatusProbeEvidenceBundle buildFromSnapshot({
    required String subjectId,
    required StatusProbeRunSnapshot snapshot,
  }) {
    return build(
      subjectId: subjectId,
      generatedAt: snapshot.generatedAt,
      suites: snapshot.suites
          .map((suite) => suite.suiteResult)
          .whereType<StatusProbeSuiteResult>()
          .toList(growable: false),
    );
  }
}

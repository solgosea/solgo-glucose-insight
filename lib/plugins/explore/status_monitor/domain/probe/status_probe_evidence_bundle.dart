import 'status_probe_suite_result.dart';

class StatusProbeEvidenceBundle {
  final String subjectId;
  final DateTime generatedAt;
  final List<StatusProbeSuiteResult> suites;

  const StatusProbeEvidenceBundle({
    required this.subjectId,
    required this.generatedAt,
    required this.suites,
  });

  StatusProbeSuiteResult? suite(String id) {
    for (final suite in suites) {
      if (suite.suiteId == id) return suite;
    }
    return null;
  }
}

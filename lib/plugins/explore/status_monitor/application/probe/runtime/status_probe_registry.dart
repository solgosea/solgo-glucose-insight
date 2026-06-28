import '../contracts/status_probe_suite.dart';

class StatusProbeRegistry {
  final List<StatusProbeSuite> suites;

  const StatusProbeRegistry({
    required this.suites,
  });

  StatusProbeSuite? suite(String id) {
    for (final suite in suites) {
      if (suite.definition.id == id) return suite;
    }
    return null;
  }
}

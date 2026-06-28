import '../../../domain/probe/status_probe_suite_definition.dart';
import '../contracts/status_probe_driver.dart';
import '../contracts/status_probe_suite.dart';

class StatusProbeConfiguredSuite implements StatusProbeSuite {
  @override
  final StatusProbeSuiteDefinition definition;

  @override
  final List<StatusProbeDriver> drivers;
  final Set<String> activationProbeIds;
  final bool skipWhenInactive;

  const StatusProbeConfiguredSuite({
    required this.definition,
    required this.drivers,
    this.activationProbeIds = const {},
    this.skipWhenInactive = false,
  });
}

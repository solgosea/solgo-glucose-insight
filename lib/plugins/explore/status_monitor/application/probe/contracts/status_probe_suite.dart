import '../../../domain/probe/status_probe_suite_definition.dart';
import 'status_probe_driver.dart';

abstract interface class StatusProbeSuite {
  StatusProbeSuiteDefinition get definition;

  List<StatusProbeDriver> get drivers;
}

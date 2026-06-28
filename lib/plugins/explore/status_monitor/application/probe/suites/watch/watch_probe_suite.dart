import '../../../../domain/probe/status_probe_kind.dart';
import '../../../../domain/probe/status_probe_suite_definition.dart';
import '../../contracts/status_probe_driver.dart';
import '../../contracts/status_probe_suite.dart';
import 'probes/watch_bridge_package_probe.dart';
import 'probes/watch_display_evidence_probe.dart';
import 'probes/watch_xdrip_web_service_entries_probe.dart';
import 'probes/watch_xdrip_web_service_reachable_probe.dart';

class WatchProbeSuite implements StatusProbeSuite {
  WatchProbeSuite({
    List<StatusProbeDriver>? drivers,
  }) : drivers = drivers ??
            [
              WatchBridgePackageProbe(),
              WatchXdripWebServiceReachableProbe(),
              WatchXdripWebServiceEntriesProbe(),
              WatchDisplayEvidenceProbe(),
            ];

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'watch',
        label: 'Watch',
        kind: StatusProbeKind.watch,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

import '../../../../domain/probe/status_probe_kind.dart';
import '../../../../domain/probe/status_probe_suite_definition.dart';
import '../../contracts/status_probe_driver.dart';
import '../../contracts/status_probe_suite.dart';
import 'probes/xdrip_bg_estimate_broadcast_probe.dart';
import 'probes/xdrip_broadcast_freshness_probe.dart';
import 'probes/xdrip_package_probe.dart';

class XdripProbeSuite implements StatusProbeSuite {
  XdripProbeSuite({
    List<StatusProbeDriver>? drivers,
  }) : drivers = drivers ??
            [
              XdripPackageProbe(),
              XdripBgEstimateBroadcastProbe(),
              XdripBroadcastFreshnessProbe(),
            ];

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'xdrip',
        label: 'xDrip+',
        kind: StatusProbeKind.xdrip,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

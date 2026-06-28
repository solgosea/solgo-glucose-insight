import '../../../../domain/probe/status_probe_kind.dart';
import '../../../../domain/probe/status_probe_suite_definition.dart';
import '../../contracts/status_probe_driver.dart';
import '../../contracts/status_probe_suite.dart';
import 'probes/juggluco_broadcast_freshness_probe.dart';
import 'probes/juggluco_glucodata_broadcast_probe.dart';
import 'probes/juggluco_package_probe.dart';
import 'probes/juggluco_xdrip_compatible_broadcast_probe.dart';

class JugglucoProbeSuite implements StatusProbeSuite {
  JugglucoProbeSuite({
    List<StatusProbeDriver>? drivers,
  }) : drivers = drivers ??
            [
              JugglucoPackageProbe(),
              JugglucoGlucodataBroadcastProbe(),
              JugglucoXdripCompatibleBroadcastProbe(),
              JugglucoBroadcastFreshnessProbe(),
            ];

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'juggluco',
        label: 'Juggluco',
        kind: StatusProbeKind.juggluco,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

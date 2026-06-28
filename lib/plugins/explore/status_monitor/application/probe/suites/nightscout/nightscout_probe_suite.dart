import '../../../../domain/probe/status_probe_kind.dart';
import '../../../../domain/probe/status_probe_suite_definition.dart';
import '../../contracts/status_probe_driver.dart';
import '../../contracts/status_probe_suite.dart';
import 'probes/nightscout_devicestatus_probe.dart';
import 'probes/nightscout_entries_freshness_probe.dart';
import 'probes/nightscout_response_time_probe.dart';
import 'probes/nightscout_status_reachable_probe.dart';

class NightscoutProbeSuite implements StatusProbeSuite {
  NightscoutProbeSuite({
    List<StatusProbeDriver>? drivers,
  }) : drivers = drivers ??
            [
              NightscoutStatusReachableProbe(),
              NightscoutEntriesFreshnessProbe(),
              NightscoutDevicestatusProbe(),
              NightscoutResponseTimeProbe(),
            ];

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'nightscout',
        label: 'Nightscout',
        kind: StatusProbeKind.nightscout,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

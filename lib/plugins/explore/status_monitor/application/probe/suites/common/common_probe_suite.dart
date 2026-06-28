import '../../../../domain/probe/status_probe_kind.dart';
import '../../../../domain/probe/status_probe_suite_definition.dart';
import '../../contracts/status_probe_driver.dart';
import '../../contracts/status_probe_suite.dart';
import 'probes/background_runtime_probe.dart';
import 'probes/battery_optimization_probe.dart';
import 'probes/bluetooth_enabled_probe.dart';
import 'probes/bluetooth_permission_probe.dart';
import 'probes/internet_reachability_probe.dart';
import 'probes/network_connectivity_probe.dart';
import 'probes/notification_permission_probe.dart';

class CommonProbeSuite implements StatusProbeSuite {
  CommonProbeSuite({
    List<StatusProbeDriver>? drivers,
  }) : drivers = drivers ??
            [
              NetworkConnectivityProbe(),
              InternetReachabilityProbe(),
              BluetoothEnabledProbe(),
              BluetoothPermissionProbe(),
              NotificationPermissionProbe(),
              BatteryOptimizationProbe(),
              BackgroundRuntimeProbe(),
            ];

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'common',
        label: 'Phone environment',
        kind: StatusProbeKind.common,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

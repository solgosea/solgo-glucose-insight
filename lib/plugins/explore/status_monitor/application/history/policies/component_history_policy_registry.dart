import '../../../domain/status_component_kind.dart';
import 'aaps_loop_history_policy.dart';
import 'cgm_sensor_history_policy.dart';
import 'component_history_policy.dart';
import 'nightscout_history_policy.dart';
import 'xdrip_history_policy.dart';

class ComponentHistoryPolicyRegistry {
  final Map<StatusComponentKind, ComponentHistoryPolicy> _policies;

  ComponentHistoryPolicyRegistry({
    List<ComponentHistoryPolicy>? policies,
  }) : _policies = {
          for (final policy in policies ??
              [
                CgmSensorHistoryPolicy(),
                XdripHistoryPolicy(),
                NightscoutHistoryPolicy(),
                AapsLoopHistoryPolicy(),
              ])
            policy.component: policy,
        };

  ComponentHistoryPolicy policyFor(StatusComponentKind component) {
    return _policies[component] ?? NightscoutHistoryPolicy();
  }
}

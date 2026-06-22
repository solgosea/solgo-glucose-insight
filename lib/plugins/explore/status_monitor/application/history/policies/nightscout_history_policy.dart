import '../../../domain/history/status_history_policy_config.dart';
import '../../../domain/status_component_kind.dart';
import 'component_history_policy.dart';

class NightscoutHistoryPolicy extends ComponentHistoryPolicy {
  @override
  StatusComponentKind get component => StatusComponentKind.nightscout;

  @override
  StatusHistoryPolicyConfig get config =>
      const StatusHistoryPolicyConfig(carryForwardTtl: Duration(minutes: 30));
}

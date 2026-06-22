import '../../../domain/history/status_history_policy_config.dart';
import '../../../domain/status_component_kind.dart';
import 'component_history_policy.dart';

class XdripHistoryPolicy extends ComponentHistoryPolicy {
  @override
  StatusComponentKind get component => StatusComponentKind.xdrip;

  @override
  StatusHistoryPolicyConfig get config =>
      const StatusHistoryPolicyConfig(carryForwardTtl: Duration(minutes: 15));
}

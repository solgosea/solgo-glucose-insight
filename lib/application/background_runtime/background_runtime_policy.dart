import 'background_runtime_context.dart';
import 'background_runtime_decision.dart';
import 'background_runtime_reason.dart';
import 'background_runtime_strategy_registry.dart';

class BackgroundRuntimePolicy {
  final BackgroundRuntimeStrategyRegistry registry;

  const BackgroundRuntimePolicy({required this.registry});

  Future<BackgroundRuntimeDecision> decide(
    BackgroundRuntimeContext context,
  ) async {
    final reasons = <BackgroundRuntimeReason>{};
    for (final strategy in registry.strategies) {
      if (await strategy.shouldStart(context)) {
        reasons.add(strategy.reason);
      }
    }
    return BackgroundRuntimeDecision.fromReasons(reasons);
  }
}

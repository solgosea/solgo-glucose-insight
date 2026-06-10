import '../../application/sync_strategy/data_source_sync_strategy_coordinator.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/polling/polling_decision.dart';
import '../../domain/polling/polling_mode.dart';
import 'polling_context_builder.dart';
import 'polling_policy_engine.dart';

class PollingDecisionService {
  final PollingContextBuilder contextBuilder;
  final PollingPolicyEngine policyEngine;
  final DataSourceSyncStrategyCoordinator strategyCoordinator;

  const PollingDecisionService({
    required this.contextBuilder,
    this.policyEngine = const PollingPolicyEngine(),
    this.strategyCoordinator = const DataSourceSyncStrategyCoordinator(),
  });

  Future<PollingDecision> decide({
    required AppSettings settings,
    required PollingMode mode,
  }) async {
    final kinds = _enabledKinds(settings);
    if (kinds.isEmpty || !strategyCoordinator.hasEnabledStrategy(settings)) {
      return PollingDecision.disabled;
    }
    final decisions = <PollingDecision>[];
    for (final kind in kinds) {
      final context = await contextBuilder.build(
        sourceKind: kind,
        mode: mode,
        settings: settings,
      );
      decisions.add(policyEngine.decide(context));
    }
    decisions.sort((a, b) => a.nextInterval.compareTo(b.nextInterval));
    return decisions.first;
  }

  List<DataSourceKind> _enabledKinds(AppSettings settings) {
    return [
      if (settings.xdripSyncEnabled) DataSourceKind.xdripLocal,
      if (settings.nightscoutSyncEnabled) DataSourceKind.nightscout,
    ];
  }
}

import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'data_source_sync_strategy_policy.dart';
import 'data_source_sync_strategy_registry.dart';

class DataSourceSyncStrategyCoordinator {
  final DataSourceSyncStrategyRegistry registry;
  final DataSourceSyncStrategyPolicy policy;

  const DataSourceSyncStrategyCoordinator({
    this.registry = const DataSourceSyncStrategyRegistry(),
    this.policy = const DataSourceSyncStrategyPolicy(),
  });

  AppSettings enable({
    required AppSettings settings,
    required DataSourceKind kind,
  }) {
    return registry.strategyFor(kind).enable(settings);
  }

  AppSettings disable({
    required AppSettings settings,
    required DataSourceKind kind,
  }) {
    return registry.strategyFor(kind).disable(settings);
  }

  bool hasEnabledStrategy(AppSettings settings) {
    return policy.hasEnabledStrategy(
      settings: settings,
      strategies: registry.strategies,
    );
  }
}

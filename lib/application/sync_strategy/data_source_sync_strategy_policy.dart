import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'data_source_sync_strategy.dart';

class DataSourceSyncStrategyPolicy {
  const DataSourceSyncStrategyPolicy();

  List<DataSourceSyncStrategy> enabledStrategies({
    required AppSettings settings,
    required List<DataSourceSyncStrategy> strategies,
  }) {
    return strategies
        .where((strategy) => strategy.canSync(settings))
        .toList(growable: false);
  }

  bool hasEnabledStrategy({
    required AppSettings settings,
    required List<DataSourceSyncStrategy> strategies,
  }) {
    return enabledStrategies(
      settings: settings,
      strategies: strategies,
    ).isNotEmpty;
  }
}

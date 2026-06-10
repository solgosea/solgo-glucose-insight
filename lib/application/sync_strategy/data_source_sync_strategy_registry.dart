import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';

import 'data_source_sync_strategy.dart';
import 'strategies/nightscout_sync_strategy.dart';
import 'strategies/xdrip_local_sync_strategy.dart';

class DataSourceSyncStrategyRegistry {
  final List<DataSourceSyncStrategy> strategies;

  const DataSourceSyncStrategyRegistry({
    this.strategies = const [
      NightscoutSyncStrategy(),
      XdripLocalSyncStrategy(),
    ],
  });

  DataSourceSyncStrategy strategyFor(DataSourceKind kind) {
    return strategies.firstWhere((strategy) => strategy.kind == kind);
  }
}

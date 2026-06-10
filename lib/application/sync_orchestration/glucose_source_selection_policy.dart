import 'package:smart_xdrip/application/sync_strategy/data_source_sync_strategy_registry.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'glucose_source_descriptor.dart';

class GlucoseSourceSelectionPolicy {
  final DataSourceSyncStrategyRegistry strategyRegistry;

  const GlucoseSourceSelectionPolicy({
    this.strategyRegistry = const DataSourceSyncStrategyRegistry(),
  });

  List<GlucoseSourceDescriptor> sourcesFor(AppSettings settings) {
    final sources = <GlucoseSourceDescriptor>[];

    for (final strategy in strategyRegistry.strategies) {
      if (!strategy.canSync(settings)) continue;
      sources.add(
        GlucoseSourceDescriptor(
          source: strategy.buildSource(settings),
          primaryHistory: strategy.kind == DataSourceKind.nightscout,
        ),
      );
    }

    return sources;
  }
}

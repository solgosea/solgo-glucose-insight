import '../../../domain/data_source/data_source_kind.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../../../domain/sync_target/glucose_sync_target.dart';
import '../../../domain/sync_target/glucose_sync_target_kind.dart';
import '../../../domain/sync_target/glucose_sync_target_owner.dart';
import '../../../domain/sync_target/glucose_sync_target_source_metadata.dart';
import '../../sync_strategy/data_source_sync_strategy_registry.dart';
import '../glucose_sync_target_provider.dart';

class SelfDataSourceSyncTargetProvider implements GlucoseSyncTargetProvider {
  final DataSourceSyncStrategyRegistry strategyRegistry;

  const SelfDataSourceSyncTargetProvider({
    this.strategyRegistry = const DataSourceSyncStrategyRegistry(),
  });

  @override
  Future<List<GlucoseSyncTarget>> targetsFor(AppSettings settings) async {
    final targets = <GlucoseSyncTarget>[];
    for (final strategy in strategyRegistry.strategies) {
      if (!strategy.canSync(settings)) continue;
      targets.add(
        GlucoseSyncTarget(
          targetId: 'self:${strategy.kind.name}',
          subjectId: GlucoseSubject.selfId,
          label: _labelFor(strategy.kind),
          kind: _kindFor(strategy.kind),
          source: strategy.buildSource(settings),
          primaryHistory: strategy.kind == DataSourceKind.nightscout,
          owner: GlucoseSyncTargetOwner.self,
          metadata: _metadataFor(settings, strategy.kind),
        ),
      );
    }
    return targets;
  }

  GlucoseSyncTargetKind _kindFor(DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => GlucoseSyncTargetKind.selfXdripLocal,
      DataSourceKind.nightscout => GlucoseSyncTargetKind.selfNightscout,
    };
  }

  String _labelFor(DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => 'Self xDrip+ Local',
      DataSourceKind.nightscout => 'Self Nightscout',
    };
  }

  GlucoseSyncTargetSourceMetadata _metadataFor(
    AppSettings settings,
    DataSourceKind kind,
  ) {
    return switch (kind) {
      DataSourceKind.nightscout => GlucoseSyncTargetSourceMetadata(
          nightscoutUrl: settings.nightscoutBaseUrl,
          accessToken: settings.nightscoutToken,
        ),
      DataSourceKind.xdripLocal => const GlucoseSyncTargetSourceMetadata(),
    };
  }
}

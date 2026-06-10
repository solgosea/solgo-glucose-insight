import '../../../domain/data_source/data_source_action.dart';
import '../../../domain/data_source/data_source_connection_snapshot.dart';
import '../../../domain/data_source/data_source_connection_status.dart';
import '../../../domain/data_source/data_source_kind.dart';
import '../../../domain/data_source/data_source_sync_strategy_action.dart';
import '../../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/source_sync_state.dart';
import '../data_source_connection_config.dart';
import '../data_source_connection_result.dart';
import '../data_source_connection_service.dart';
import 'data_source_handler.dart';

class NightscoutDataSourceHandler implements DataSourceHandler {
  final DataSourceConnectionService service;

  const NightscoutDataSourceHandler({
    this.service = const DataSourceConnectionService(),
  });

  @override
  DataSourceKind get kind => DataSourceKind.nightscout;

  @override
  Future<DataSourceConnectionSnapshot> snapshot({
    required AppSettings settings,
    SourceSyncState? syncState,
    required bool supported,
    DataSourceRuntimeSnapshot? runtime,
  }) async {
    final configured = runtime?.configured ?? _configured(settings);
    final strategyEnabled = settings.nightscoutSyncEnabled;
    final active = configured && strategyEnabled;
    final reachable = runtime?.reachable ?? configured;
    if (active) {
      final fresh = _isFresh(syncState);
      return DataSourceConnectionSnapshot(
        kind: DataSourceKind.nightscout,
        status:
            !reachable
                ? DataSourceConnectionStatus.failed
                : fresh
                ? DataSourceConnectionStatus.syncing
                : DataSourceConnectionStatus.connected,
        action: DataSourceConnectionAction.sync,
        strategyAction: DataSourceSyncStrategyAction.disable,
        title: 'Nightscout API',
        subtitle:
            reachable ? 'Sync enabled' : 'Enabled, but API is not reachable',
        trailing: 'Sync',
        strategyTrailing: 'Disable',
        active: true,
        detected: true,
        configured: configured,
        strategyEnabled: true,
        supported: true,
        syncState: syncState,
      );
    }

    return DataSourceConnectionSnapshot(
      kind: DataSourceKind.nightscout,
      status:
          configured
              ? reachable
                  ? DataSourceConnectionStatus.configured
                  : DataSourceConnectionStatus.failed
              : DataSourceConnectionStatus.notConfigured,
      action:
          !strategyEnabled
              ? DataSourceConnectionAction.none
              : configured
              ? DataSourceConnectionAction.none
              : DataSourceConnectionAction.configure,
      strategyAction:
          strategyEnabled
              ? DataSourceSyncStrategyAction.disable
              : DataSourceSyncStrategyAction.enable,
      title: 'Nightscout API',
      subtitle:
          !strategyEnabled
              ? 'Strategy is off - enable before setup'
              : configured
              ? reachable
                  ? 'Configured - strategy is disabled'
                  : 'Configured, but API is not reachable'
              : 'Not configured',
      trailing: configured ? 'Configured' : 'Set up',
      strategyTrailing: strategyEnabled ? 'Disable' : 'Enable',
      active: false,
      detected: configured,
      configured: configured,
      strategyEnabled: strategyEnabled,
      supported: true,
      syncState: syncState,
    );
  }

  @override
  Future<DataSourceConnectionResult> connect({
    required AppSettings settings,
    DataSourceConnectionConfig config = const DataSourceConnectionConfig(),
  }) async {
    final baseUrl = config.baseUrl ?? settings.nightscoutBaseUrl;
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return const DataSourceConnectionResult.failure(
        'Enter a valid Nightscout URL',
      );
    }
    final token = config.token ?? settings.nightscoutToken;
    final test = await service.testNightscout(baseUrl: baseUrl, token: token);
    if (!test.success) return DataSourceConnectionResult.failure(test.message);
    return DataSourceConnectionResult.success(
      message: test.message,
      nextSettings: service.connectNightscout(
        settings: settings,
        baseUrl: baseUrl,
        token: token,
      ),
    );
  }

  @override
  Future<DataSourceConnectionResult> disconnect({
    required AppSettings settings,
  }) async {
    if (!_configured(settings)) {
      return const DataSourceConnectionResult.success(
        message: 'Nightscout API is already disconnected',
      );
    }
    return DataSourceConnectionResult.success(
      message: 'Nightscout API disconnected',
      nextSettings: settings.copyWith(clearNightscout: true),
    );
  }

  bool _configured(AppSettings settings) {
    final baseUrl = settings.nightscoutBaseUrl;
    return baseUrl != null && baseUrl.trim().isNotEmpty;
  }

  bool _isFresh(SourceSyncState? state) {
    final success = state?.lastSuccessAt;
    if (success == null) return false;
    return DateTime.now().difference(success).inMinutes <= 5;
  }
}

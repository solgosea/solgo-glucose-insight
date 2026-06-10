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

class XdripLocalDataSourceHandler implements DataSourceHandler {
  final DataSourceConnectionService service;

  const XdripLocalDataSourceHandler({
    this.service = const DataSourceConnectionService(),
  });

  @override
  DataSourceKind get kind => DataSourceKind.xdripLocal;

  @override
  Future<DataSourceConnectionSnapshot> snapshot({
    required AppSettings settings,
    SourceSyncState? syncState,
    required bool supported,
    DataSourceRuntimeSnapshot? runtime,
  }) async {
    if (!supported) {
      return const DataSourceConnectionSnapshot(
        kind: DataSourceKind.xdripLocal,
        status: DataSourceConnectionStatus.unsupported,
        action: DataSourceConnectionAction.none,
        strategyAction: DataSourceSyncStrategyAction.none,
        title: 'xDrip+ Local',
        subtitle: 'Android only',
        trailing: 'Unavailable',
        strategyTrailing: 'Off',
        active: false,
        detected: false,
        configured: false,
        strategyEnabled: false,
        supported: false,
      );
    }

    final configured = _configured(settings);
    final strategyEnabled = settings.xdripSyncEnabled;
    final active = strategyEnabled && configured;
    final detected = runtime?.reachable ?? false;
    if (active) {
      final fresh = _isFresh(syncState);
      return DataSourceConnectionSnapshot(
        kind: DataSourceKind.xdripLocal,
        status:
            !detected
                ? DataSourceConnectionStatus.failed
                : fresh
                ? DataSourceConnectionStatus.syncing
                : DataSourceConnectionStatus.connected,
        action: DataSourceConnectionAction.sync,
        strategyAction: DataSourceSyncStrategyAction.disable,
        title: 'xDrip+ Local',
        subtitle:
            detected
                ? 'Sync enabled'
                : 'Enabled, but local web service is not reachable',
        trailing: 'Sync',
        strategyTrailing: 'Disable',
        active: true,
        detected: detected,
        configured: true,
        strategyEnabled: true,
        supported: true,
        syncState: syncState,
      );
    }

    return DataSourceConnectionSnapshot(
      kind: DataSourceKind.xdripLocal,
      status:
          configured
              ? detected
                  ? DataSourceConnectionStatus.configured
                  : DataSourceConnectionStatus.failed
              : detected
              ? DataSourceConnectionStatus.detected
              : DataSourceConnectionStatus.notDetected,
      action:
          !strategyEnabled
              ? DataSourceConnectionAction.none
              : configured
              ? DataSourceConnectionAction.none
              : DataSourceConnectionAction.connect,
      strategyAction:
          strategyEnabled
              ? DataSourceSyncStrategyAction.disable
              : DataSourceSyncStrategyAction.enable,
      title: 'xDrip+ Local',
      subtitle:
          !strategyEnabled
              ? 'Strategy is off - enable before connecting'
              : configured
              ? detected
                  ? 'Connected - strategy is disabled'
                  : 'Configured, but local web service is not reachable'
              : detected
              ? 'Detected - connect to save this local endpoint'
              : 'Not detected - enable xDrip+ web service',
      trailing:
          !strategyEnabled
              ? 'Connect'
              : configured
              ? 'Connected'
              : 'Connect',
      strategyTrailing: strategyEnabled ? 'Disable' : 'Enable',
      active: false,
      detected: detected,
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
    final baseUrl =
        config.baseUrl ??
        settings.xdripBaseUrl ??
        DataSourceConnectionService.defaultXdripUrl;
    final apiSecret = config.apiSecret ?? settings.xdripApiSecret;
    final test = await service.testXdripLocal(
      baseUrl: baseUrl,
      apiSecret: apiSecret,
    );
    if (!test.success) return DataSourceConnectionResult.failure(test.message);
    return DataSourceConnectionResult.success(
      message: test.message,
      nextSettings: service.connectXdripLocal(
        settings: settings,
        baseUrl: baseUrl,
        apiSecret: apiSecret,
      ),
    );
  }

  @override
  Future<DataSourceConnectionResult> disconnect({
    required AppSettings settings,
  }) async {
    if (!_configured(settings)) {
      return const DataSourceConnectionResult.success(
        message: 'xDrip+ Local is already disconnected',
      );
    }
    return DataSourceConnectionResult.success(
      message: 'xDrip+ Local disconnected',
      nextSettings: settings.copyWith(clearXdrip: true),
    );
  }

  bool _configured(AppSettings settings) {
    final baseUrl = settings.xdripBaseUrl;
    return baseUrl != null && baseUrl.trim().isNotEmpty;
  }

  bool _isFresh(SourceSyncState? state) {
    final success = state?.lastSuccessAt;
    if (success == null) return false;
    return DateTime.now().difference(success).inMinutes <= 5;
  }
}

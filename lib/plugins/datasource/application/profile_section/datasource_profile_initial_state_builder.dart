import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

class DatasourceProfileInitialStateBuilder {
  const DatasourceProfileInitialStateBuilder();

  List<DataSourceConnectionSnapshot> build({
    required AppSettings settings,
    required bool xdripSupported,
  }) {
    return [
      _xdrip(settings: settings, supported: xdripSupported),
      _nightscout(settings),
    ];
  }

  DataSourceConnectionSnapshot _xdrip({
    required AppSettings settings,
    required bool supported,
  }) {
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

    final configured = _hasValue(settings.xdripBaseUrl);
    final strategyEnabled = settings.xdripSyncEnabled;
    final active = configured && strategyEnabled;
    return DataSourceConnectionSnapshot(
      kind: DataSourceKind.xdripLocal,
      status: active
          ? DataSourceConnectionStatus.connecting
          : configured
              ? DataSourceConnectionStatus.configured
              : DataSourceConnectionStatus.notDetected,
      action: !strategyEnabled
          ? DataSourceConnectionAction.none
          : configured
              ? DataSourceConnectionAction.none
              : DataSourceConnectionAction.connect,
      strategyAction: strategyEnabled
          ? DataSourceSyncStrategyAction.disable
          : DataSourceSyncStrategyAction.enable,
      title: 'xDrip+ Local',
      subtitle: active
          ? 'Checking local source'
          : configured
              ? 'Connected - strategy is disabled'
              : 'Not detected - enable xDrip+ web service',
      trailing: configured ? 'Connected' : 'Connect',
      strategyTrailing: strategyEnabled ? 'Disable' : 'Enable',
      active: active,
      detected: configured,
      configured: configured,
      strategyEnabled: strategyEnabled,
      supported: true,
    );
  }

  DataSourceConnectionSnapshot _nightscout(AppSettings settings) {
    final configured = _hasValue(settings.nightscoutBaseUrl);
    final strategyEnabled = settings.nightscoutSyncEnabled;
    final active = configured && strategyEnabled;
    return DataSourceConnectionSnapshot(
      kind: DataSourceKind.nightscout,
      status: active
          ? DataSourceConnectionStatus.connecting
          : configured
              ? DataSourceConnectionStatus.configured
              : DataSourceConnectionStatus.notConfigured,
      action: !strategyEnabled
          ? DataSourceConnectionAction.none
          : configured
              ? DataSourceConnectionAction.none
              : DataSourceConnectionAction.configure,
      strategyAction: strategyEnabled
          ? DataSourceSyncStrategyAction.disable
          : DataSourceSyncStrategyAction.enable,
      title: 'Nightscout API',
      subtitle: active
          ? 'Checking Nightscout'
          : !strategyEnabled
              ? 'Strategy is off - enable before setup'
              : configured
                  ? 'Configured - strategy is disabled'
                  : 'Not configured',
      trailing: configured ? 'Configured' : 'Set up',
      strategyTrailing: strategyEnabled ? 'Disable' : 'Enable',
      active: active,
      detected: configured,
      configured: configured,
      strategyEnabled: strategyEnabled,
      supported: true,
    );
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}

import 'package:smart_xdrip/application/data_source/data_source_connection_service.dart';
import 'package:smart_xdrip/data/sources/xdrip_http_source.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../data_source_sync_strategy.dart';

class XdripLocalSyncStrategy implements DataSourceSyncStrategy {
  const XdripLocalSyncStrategy();

  @override
  DataSourceKind get kind => DataSourceKind.xdripLocal;

  @override
  bool isConfigured(AppSettings settings) {
    final baseUrl = settings.xdripBaseUrl;
    return baseUrl != null && baseUrl.trim().isNotEmpty;
  }

  @override
  bool isEnabled(AppSettings settings) => settings.xdripSyncEnabled;

  @override
  bool canSync(AppSettings settings) =>
      isConfigured(settings) && isEnabled(settings);

  @override
  IGlucoseSource buildSource(AppSettings settings) {
    return XdripHttpSource(
      baseUrl:
          settings.xdripBaseUrl ?? DataSourceConnectionService.defaultXdripUrl,
      apiSecret: settings.xdripApiSecret,
    );
  }

  @override
  AppSettings enable(AppSettings settings) {
    return settings.copyWith(xdripSyncEnabled: true);
  }

  @override
  AppSettings disable(AppSettings settings) {
    return settings.copyWith(xdripSyncEnabled: false);
  }
}

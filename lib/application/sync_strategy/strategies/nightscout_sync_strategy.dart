import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../data_source_sync_strategy.dart';

class NightscoutSyncStrategy implements DataSourceSyncStrategy {
  const NightscoutSyncStrategy();

  @override
  DataSourceKind get kind => DataSourceKind.nightscout;

  @override
  bool isConfigured(AppSettings settings) {
    final baseUrl = settings.nightscoutBaseUrl;
    return baseUrl != null && baseUrl.trim().isNotEmpty;
  }

  @override
  bool isEnabled(AppSettings settings) => settings.nightscoutSyncEnabled;

  @override
  bool canSync(AppSettings settings) =>
      isConfigured(settings) && isEnabled(settings);

  @override
  IGlucoseSource buildSource(AppSettings settings) {
    return NightscoutApiSource(
      baseUrl: settings.nightscoutBaseUrl!,
      token: settings.nightscoutToken,
    );
  }

  @override
  AppSettings enable(AppSettings settings) {
    return settings.copyWith(nightscoutSyncEnabled: true);
  }

  @override
  AppSettings disable(AppSettings settings) {
    return settings.copyWith(nightscoutSyncEnabled: false);
  }
}

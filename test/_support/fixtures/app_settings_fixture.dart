import 'package:smart_xdrip/domain/entities/app_settings.dart';

class AppSettingsFixture {
  const AppSettingsFixture._();

  static const mock = AppSettings();

  static const xdrip = AppSettings(
    xdripBaseUrl: 'http://127.0.0.1:17580',
    xdripSyncEnabled: true,
  );

  static const nightscout = AppSettings(
    nightscoutBaseUrl: 'http://127.0.0.1:1337',
    nightscoutToken: 'test-token',
    nightscoutSyncEnabled: true,
  );

  static const mgDl = AppSettings(unit: GlucoseUnit.mgDl);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_selection_policy.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

void main() {
  test('source selection keeps Nightscout and xDrip configured together', () {
    final sources = const GlucoseSourceSelectionPolicy().sourcesFor(
      const AppSettings(
        nightscoutBaseUrl: 'http://localhost:1337',
        nightscoutSyncEnabled: true,
        xdripBaseUrl: 'http://127.0.0.1:17580',
        xdripSyncEnabled: true,
      ),
    );

    expect(sources.map((source) => source.source.type), [
      DataSource.nightscout,
      DataSource.xdripHttp,
    ]);
  });

  test('configured sources do not sync until their strategy is enabled', () {
    final sources = const GlucoseSourceSelectionPolicy().sourcesFor(
      const AppSettings(
        nightscoutBaseUrl: 'http://localhost:1337',
        xdripBaseUrl: 'http://127.0.0.1:17580',
      ),
    );

    expect(sources, isEmpty);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_strategy/data_source_sync_strategy_coordinator.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

void main() {
  group('DataSourceSyncStrategyCoordinator', () {
    const coordinator = DataSourceSyncStrategyCoordinator();

    test('enables and disables xDrip Local without touching Nightscout', () {
      const initial = AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        nightscoutBaseUrl: 'http://localhost:1337',
        nightscoutSyncEnabled: true,
      );

      final enabled = coordinator.enable(
        settings: initial,
        kind: DataSourceKind.xdripLocal,
      );
      expect(enabled.xdripSyncEnabled, isTrue);
      expect(enabled.nightscoutSyncEnabled, isTrue);

      final disabled = coordinator.disable(
        settings: enabled,
        kind: DataSourceKind.xdripLocal,
      );
      expect(disabled.xdripSyncEnabled, isFalse);
      expect(disabled.nightscoutSyncEnabled, isTrue);
    });

    test('enables and disables Nightscout without touching xDrip Local', () {
      const initial = AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        xdripSyncEnabled: true,
        nightscoutBaseUrl: 'http://localhost:1337',
      );

      final enabled = coordinator.enable(
        settings: initial,
        kind: DataSourceKind.nightscout,
      );
      expect(enabled.nightscoutSyncEnabled, isTrue);
      expect(enabled.xdripSyncEnabled, isTrue);

      final disabled = coordinator.disable(
        settings: enabled,
        kind: DataSourceKind.nightscout,
      );
      expect(disabled.nightscoutSyncEnabled, isFalse);
      expect(disabled.xdripSyncEnabled, isTrue);
    });

    test('requires a configured and enabled source before sync is allowed', () {
      expect(coordinator.hasEnabledStrategy(const AppSettings()), isFalse);
      expect(
        coordinator.hasEnabledStrategy(
          const AppSettings(
            nightscoutBaseUrl: 'http://localhost:1337',
            xdripBaseUrl: 'http://127.0.0.1:17580',
          ),
        ),
        isFalse,
      );
      expect(
        coordinator.hasEnabledStrategy(
          const AppSettings(
            nightscoutBaseUrl: 'http://localhost:1337',
            nightscoutSyncEnabled: true,
          ),
        ),
        isTrue,
      );
      expect(
        coordinator.hasEnabledStrategy(
          const AppSettings(
            xdripBaseUrl: 'http://127.0.0.1:17580',
            xdripSyncEnabled: true,
          ),
        ),
        isTrue,
      );
    });
  });
}

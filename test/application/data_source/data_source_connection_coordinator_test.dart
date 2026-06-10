import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/data_source/data_source_connection_coordinator.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/data_source_runtime/data_source_health_status.dart';
import 'package:smart_xdrip/domain/data_source_runtime/data_source_runtime_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';

void main() {
  group('DataSourceConnectionCoordinator', () {
    final coordinator = DataSourceConnectionCoordinator();

    test(
      'xDrip disconnect clears only local config and local strategy',
      () async {
        const settings = AppSettings(
          xdripBaseUrl: 'http://127.0.0.1:17580',
          xdripSyncEnabled: true,
          nightscoutBaseUrl: 'http://localhost:1337',
          nightscoutToken: 'token',
          nightscoutSyncEnabled: true,
        );

        final result = await coordinator.disconnect(
          kind: DataSourceKind.xdripLocal,
          settings: settings,
        );

        expect(result.success, isTrue);
        expect(result.nextSettings, isNotNull);
        expect(result.nextSettings!.xdripBaseUrl, isNull);
        expect(result.nextSettings!.xdripApiSecret, isNull);
        expect(result.nextSettings!.xdripSyncEnabled, isFalse);
        expect(
          result.nextSettings!.nightscoutBaseUrl,
          settings.nightscoutBaseUrl,
        );
        expect(result.nextSettings!.nightscoutToken, settings.nightscoutToken);
        expect(result.nextSettings!.nightscoutSyncEnabled, isTrue);
      },
    );

    test(
      'Nightscout disconnect clears only API config and API strategy',
      () async {
        const settings = AppSettings(
          xdripBaseUrl: 'http://127.0.0.1:17580',
          xdripApiSecret: 'secret',
          xdripSyncEnabled: true,
          nightscoutBaseUrl: 'http://localhost:1337',
          nightscoutToken: 'token',
          nightscoutSyncEnabled: true,
        );

        final result = await coordinator.disconnect(
          kind: DataSourceKind.nightscout,
          settings: settings,
        );

        expect(result.success, isTrue);
        expect(result.nextSettings, isNotNull);
        expect(result.nextSettings!.nightscoutBaseUrl, isNull);
        expect(result.nextSettings!.nightscoutToken, isNull);
        expect(result.nextSettings!.nightscoutSyncEnabled, isFalse);
        expect(result.nextSettings!.xdripBaseUrl, settings.xdripBaseUrl);
        expect(result.nextSettings!.xdripApiSecret, settings.xdripApiSecret);
        expect(result.nextSettings!.xdripSyncEnabled, isTrue);
      },
    );

    test('reachable but disabled source is visible but not active', () async {
      const settings = AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        nightscoutBaseUrl: 'http://localhost:1337',
      );

      final snapshots = await coordinator.snapshots(
        settings: settings,
        xdripState: null,
        nightscoutState: null,
        xdripSupported: true,
        xdripRuntime: const DataSourceRuntimeSnapshot(
          kind: DataSourceKind.xdripLocal,
          healthStatus: DataSourceHealthStatus.reachable,
          supported: true,
          configured: true,
          active: false,
        ),
        nightscoutRuntime: const DataSourceRuntimeSnapshot(
          kind: DataSourceKind.nightscout,
          healthStatus: DataSourceHealthStatus.reachable,
          supported: true,
          configured: true,
          active: false,
        ),
      );

      for (final snapshot in snapshots) {
        expect(snapshot.active, isFalse);
        expect(snapshot.strategyEnabled, isFalse);
        expect(snapshot.strategyAction, DataSourceSyncStrategyAction.enable);
      }
      expect(
        snapshots
            .firstWhere((entry) => entry.kind == DataSourceKind.xdripLocal)
            .status,
        DataSourceConnectionStatus.configured,
      );
      expect(
        snapshots
            .firstWhere((entry) => entry.kind == DataSourceKind.nightscout)
            .status,
        DataSourceConnectionStatus.configured,
      );
    });

    test(
      'active source leaves sync timing to shared status component',
      () async {
        const settings = AppSettings(
          nightscoutBaseUrl: 'http://localhost:1337',
          nightscoutSyncEnabled: true,
        );
        final syncedAt = DateTime.now().subtract(const Duration(minutes: 3));

        final snapshots = await coordinator.snapshots(
          settings: settings,
          xdripState: null,
          nightscoutState: SourceSyncState(
            sourceKey: 'nightscout',
            lastSuccessAt: syncedAt,
            lastAttemptAt: syncedAt,
            updatedAt: syncedAt,
          ),
          xdripSupported: false,
          nightscoutRuntime: const DataSourceRuntimeSnapshot(
            kind: DataSourceKind.nightscout,
            healthStatus: DataSourceHealthStatus.reachable,
            supported: true,
            configured: true,
            active: true,
          ),
        );

        final nightscout = snapshots.single;
        expect(nightscout.subtitle, 'Sync enabled');
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/data_source/connection_test_result.dart';
import 'package:smart_xdrip/application/data_source_runtime/data_source_runtime_coordinator.dart';
import 'package:smart_xdrip/application/data_source_runtime/handlers/data_source_health_handler.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source_runtime/data_source_health_status.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

void main() {
  group('DataSourceRuntimeCoordinator', () {
    test('marks configured enabled sources as reachable and active', () async {
      final coordinator = DataSourceRuntimeCoordinator(
        syncStateLoader: (_) async => null,
        xdripSupported: true,
        handlers: [
          _FakeHealthHandler(
            kind: DataSourceKind.xdripLocal,
            configured: true,
            result: const ConnectionTestResult.success('ok'),
          ),
          _FakeHealthHandler(
            kind: DataSourceKind.nightscout,
            configured: true,
            result: const ConnectionTestResult.success('ok'),
          ),
        ],
      );
      addTearDown(coordinator.dispose);

      const settings = AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        xdripSyncEnabled: true,
        nightscoutBaseUrl: 'http://localhost:1337',
        nightscoutSyncEnabled: true,
      );

      final xdrip = await coordinator.refreshOne(
        DataSourceKind.xdripLocal,
        settings: settings,
      );
      final nightscout = await coordinator.refreshOne(
        DataSourceKind.nightscout,
        settings: settings,
      );

      expect(xdrip.healthStatus, DataSourceHealthStatus.reachable);
      expect(xdrip.configured, isTrue);
      expect(xdrip.active, isTrue);
      expect(nightscout.healthStatus, DataSourceHealthStatus.reachable);
      expect(nightscout.configured, isTrue);
      expect(nightscout.active, isTrue);
    });

    test('keeps reachable but disabled sources inactive', () async {
      final coordinator = DataSourceRuntimeCoordinator(
        syncStateLoader: (_) async => null,
        xdripSupported: true,
        handlers: [
          _FakeHealthHandler(
            kind: DataSourceKind.xdripLocal,
            configured: true,
            result: const ConnectionTestResult.success('ok'),
          ),
          _FakeHealthHandler(
            kind: DataSourceKind.nightscout,
            configured: true,
            result: const ConnectionTestResult.success('ok'),
          ),
        ],
      );
      addTearDown(coordinator.dispose);

      const settings = AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        nightscoutBaseUrl: 'http://localhost:1337',
      );

      final xdrip = await coordinator.refreshOne(
        DataSourceKind.xdripLocal,
        settings: settings,
      );
      final nightscout = await coordinator.refreshOne(
        DataSourceKind.nightscout,
        settings: settings,
      );

      expect(xdrip.healthStatus, DataSourceHealthStatus.reachable);
      expect(xdrip.active, isFalse);
      expect(nightscout.healthStatus, DataSourceHealthStatus.reachable);
      expect(nightscout.active, isFalse);
    });

    test('downgrades source health when the backing endpoint fails', () async {
      final xdripHandler = _FakeHealthHandler(
        kind: DataSourceKind.xdripLocal,
        configured: true,
        result: const ConnectionTestResult.success('ok'),
      );
      final coordinator = DataSourceRuntimeCoordinator(
        syncStateLoader: (_) async => null,
        xdripSupported: true,
        handlers: [
          xdripHandler,
          _FakeHealthHandler(
            kind: DataSourceKind.nightscout,
            configured: false,
            result: const ConnectionTestResult.failure('missing'),
          ),
        ],
      );
      addTearDown(coordinator.dispose);

      const settings = AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        xdripSyncEnabled: true,
      );

      expect(
        (await coordinator.refreshOne(
          DataSourceKind.xdripLocal,
          settings: settings,
        )).healthStatus,
        DataSourceHealthStatus.reachable,
      );

      xdripHandler.result = const ConnectionTestResult.failure(
        'service closed',
      );

      final downgraded = await coordinator.refreshOne(
        DataSourceKind.xdripLocal,
        settings: settings,
      );

      expect(downgraded.healthStatus, DataSourceHealthStatus.unreachable);
      expect(downgraded.active, isTrue);
      expect(downgraded.lastHealthMessage, 'service closed');
    });
  });
}

class _FakeHealthHandler implements DataSourceHealthHandler {
  @override
  final DataSourceKind kind;
  bool configured;
  ConnectionTestResult result;

  _FakeHealthHandler({
    required this.kind,
    required this.configured,
    required this.result,
  });

  @override
  bool isConfigured(AppSettings settings) => configured;

  @override
  Future<ConnectionTestResult> check(AppSettings settings) async => result;
}

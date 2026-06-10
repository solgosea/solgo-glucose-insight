import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/data_source/connection_test_result.dart';
import 'package:smart_xdrip/application/data_source_runtime/data_source_runtime_coordinator.dart';
import 'package:smart_xdrip/application/data_source_runtime/handlers/data_source_health_handler.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source_runtime/data_source_health_status.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/runtime/data_source_plugin_runtime.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';

void main() {
  test(
    'datasource runtime starts through plugin manager and publishes snapshot',
    () async {
      final manager = PluginRuntimeManager.create(
        now: () => DateTime(2026, 6, 6, 12),
      );
      addTearDown(manager.dispose);

      final coordinator = DataSourceRuntimeCoordinator(
        xdripSupported: true,
        interval: const Duration(days: 1),
        syncStateLoader: (_) async => null,
        handlers: const [
          _FakeHealthHandler(DataSourceKind.xdripLocal),
          _FakeHealthHandler(DataSourceKind.nightscout),
        ],
      );

      final events = <Map<String, Object?>>[];
      final subscription = manager.eventBus.events.listen((event) {
        if (event.type == PluginRuntimeEventType.datasourceChanged) {
          events.add(event.payload);
        }
      });
      addTearDown(subscription.cancel);

      manager.register(
        DataSourcePluginRuntime(
          coordinator: coordinator,
          settingsProvider:
              () => const AppSettings(
                xdripBaseUrl: 'http://127.0.0.1:17580',
                xdripSyncEnabled: true,
                nightscoutBaseUrl: 'http://127.0.0.1:1337',
                nightscoutSyncEnabled: true,
              ),
        ),
        startPolicy: PluginRuntimeStartPolicy.appStart,
      );

      await manager.startAppRuntimes();
      await pumpEventQueue();

      expect(
        coordinator.snapshotFor(DataSourceKind.xdripLocal).healthStatus,
        DataSourceHealthStatus.reachable,
      );
      expect(
        coordinator.snapshotFor(DataSourceKind.nightscout).healthStatus,
        DataSourceHealthStatus.reachable,
      );
      expect(events, isNotEmpty);
      expect(events.last['snapshots'], isA<List<Object?>>());
    },
  );
}

class _FakeHealthHandler implements DataSourceHealthHandler {
  @override
  final DataSourceKind kind;

  const _FakeHealthHandler(this.kind);

  @override
  bool isConfigured(AppSettings settings) => true;

  @override
  Future<ConnectionTestResult> check(AppSettings settings) async {
    return const ConnectionTestResult.success();
  }
}

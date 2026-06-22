import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_payload.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_action.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_registry.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';
import 'package:smart_xdrip/data/platform/floating_surface/floating_surface_platform_bridge.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/floating/status_floating_service.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sqlite/sqlite_status_floating_settings_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database database;
  late _FakeFloatingSurfaceBridge bridge;
  late FloatingSurfaceRegistry registry;
  late StatusFloatingService service;

  setUp(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    bridge = _FakeFloatingSurfaceBridge();
    registry = FloatingSurfaceRegistry();
    service = StatusFloatingService(
      settingsRepository: SqliteStatusFloatingSettingsRepository(
        databaseProvider: () async => database,
      ),
      surfaceService: FloatingSurfaceService(
        registry: registry,
        bridge: bridge,
      ),
    );
  });

  tearDown(() => database.close());

  test('does not start overlay without permission', () async {
    bridge.permission = false;

    await service.update(_report());

    expect(registry.snapshot().segments, isEmpty);
    expect(bridge.stopCalls, 1);
  });

  test('updates overlay when enabled and permission is granted', () async {
    bridge.permission = true;

    await service.update(_report());

    expect(bridge.updateCalls, 1);
    expect(bridge.lastPayload?.segments.single.id, 'status_monitor');
    expect(bridge.lastPayload?.segments.single.primaryText, contains('Sensor'));
  });

  test('disabled floating status stops overlay', () async {
    bridge.permission = true;

    await service.setEnabled(false);
    await service.update(_report());

    expect(bridge.updateCalls, 0);
    expect(bridge.stopCalls, 1);
  });
}

class _FakeFloatingSurfaceBridge implements FloatingSurfacePlatformBridge {
  bool permission = true;
  int updateCalls = 0;
  int stopCalls = 0;
  FloatingSurfacePayload? lastPayload;

  @override
  bool get isSupported => true;

  @override
  Stream<FloatingSurfaceAction> get actions => const Stream.empty();

  @override
  Future<bool> hasOverlayPermission() async => permission;

  @override
  Future<void> requestOverlayPermission() async {
    permission = true;
  }

  @override
  Future<void> update(FloatingSurfacePayload payload) async {
    updateCalls += 1;
    lastPayload = payload;
  }

  @override
  Future<void> stop() async {
    stopCalls += 1;
  }
}

StatusReport _report() {
  final now = DateTime(2026, 1, 1, 12);
  return StatusReport(
    subjectId: 'self',
    sourceKind: 'nightscout',
    sourceLabel: 'Nightscout',
    generatedAt: now,
    hasConfiguredSource: true,
    summary: const StatusSummary(
      level: StatusLevel.healthy,
      headline: 'All links are healthy',
      body: 'Status summary',
      meta: '4 components',
      healthyCount: 4,
      totalCount: 4,
    ),
    components: [
      _component(StatusComponentKind.cgmSensor),
      _component(StatusComponentKind.xdrip),
      _component(StatusComponentKind.nightscout),
      _component(StatusComponentKind.aapsLoop),
    ],
    recentEvents: const [],
    capabilities: const StatusSourceCapabilities.nightscout(),
  );
}

ComponentHealth _component(StatusComponentKind kind) {
  return ComponentHealth(
    kind: kind,
    level: StatusLevel.healthy,
    title: kind.title,
    role: kind.role,
    takeaway: '${kind.title} Healthy',
    summary: '${kind.title} status',
    metrics: const [],
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_payload.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_action.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_registry.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment_kind.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';
import 'package:smart_xdrip/data/platform/floating_surface/floating_surface_platform_bridge.dart';

void main() {
  test('publishes merged payload when permission is granted', () async {
    final bridge = _FakeBridge()..permission = true;
    final service = FloatingSurfaceService(
      registry: FloatingSurfaceRegistry(),
      bridge: bridge,
    );

    await service.upsertSegment(_segment('status_monitor', 20));
    await service.upsertSegment(_segment('glance', 10));

    expect(bridge.stopCalls, 0);
    expect(bridge.updateCalls, 2);
    expect(
      bridge.lastPayload?.segments.map((segment) => segment.id),
      ['glance', 'status_monitor'],
    );
  });

  test('stops overlay when permission is missing or registry is empty',
      () async {
    final bridge = _FakeBridge()..permission = false;
    final service = FloatingSurfaceService(
      registry: FloatingSurfaceRegistry(),
      bridge: bridge,
    );

    await service.upsertSegment(_segment('glance', 10));

    expect(bridge.updateCalls, 0);
    expect(bridge.stopCalls, 1);

    bridge.permission = true;
    await service.removeSegment('glance');

    expect(bridge.stopCalls, 1);
  });

  test('does not republish unchanged payload', () async {
    final bridge = _FakeBridge()..permission = true;
    final service = FloatingSurfaceService(
      registry: FloatingSurfaceRegistry(),
      bridge: bridge,
    );

    await service.upsertSegment(_segment('glance', 10));
    await service.upsertSegment(_segment('glance', 10));
    await service.refresh();

    expect(bridge.updateCalls, 1);

    await service.upsertSegment(
      const FloatingSurfaceSegment(
        id: 'glance',
        kind: FloatingSurfaceSegmentKind.glucose,
        order: 10,
        primaryText: '7.3 mmol/L',
        level: 'healthy',
      ),
    );

    expect(bridge.updateCalls, 2);
  });
}

FloatingSurfaceSegment _segment(String id, int order) {
  return FloatingSurfaceSegment(
    id: id,
    kind: id == 'glance'
        ? FloatingSurfaceSegmentKind.glucose
        : FloatingSurfaceSegmentKind.status,
    order: order,
    primaryText: id,
    level: 'healthy',
  );
}

class _FakeBridge implements FloatingSurfacePlatformBridge {
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

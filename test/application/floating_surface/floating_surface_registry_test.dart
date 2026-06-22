import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_registry.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment_kind.dart';

void main() {
  test('orders enabled segments and removes disabled segments', () {
    final registry = FloatingSurfaceRegistry();

    registry.upsert(
      const FloatingSurfaceSegment(
        id: 'status_monitor',
        kind: FloatingSurfaceSegmentKind.status,
        order: 20,
        primaryText: 'status',
        level: 'healthy',
      ),
    );
    registry.upsert(
      const FloatingSurfaceSegment(
        id: 'glance',
        kind: FloatingSurfaceSegmentKind.glucose,
        order: 10,
        primaryText: '7.2 mmol/L',
        level: 'healthy',
      ),
    );

    expect(
      registry.snapshot().segments.map((segment) => segment.id),
      ['glance', 'status_monitor'],
    );

    registry.upsert(
      const FloatingSurfaceSegment(
        id: 'glance',
        kind: FloatingSurfaceSegmentKind.glucose,
        enabled: false,
        order: 10,
        primaryText: '',
        level: 'unknown',
      ),
    );

    expect(registry.snapshot().segments.single.id, 'status_monitor');
  });
}

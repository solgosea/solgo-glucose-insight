import 'floating_surface_layout.dart';
import 'floating_surface_payload.dart';
import 'floating_surface_segment.dart';

class FloatingSurfaceRegistry {
  final Map<String, FloatingSurfaceSegment> _segments = {};

  void upsert(FloatingSurfaceSegment segment) {
    if (!segment.enabled) {
      remove(segment.id);
      return;
    }
    _segments[segment.id] = segment;
  }

  void remove(String id) {
    _segments.remove(id);
  }

  FloatingSurfacePayload snapshot({
    FloatingSurfaceLayout layout = FloatingSurfaceLayout.stacked,
  }) {
    final segments = _segments.values.toList(growable: false)
      ..sort((a, b) => a.order.compareTo(b.order));
    return FloatingSurfacePayload(layout: layout, segments: segments);
  }

  void clear() {
    _segments.clear();
  }
}

import 'floating_surface_layout.dart';
import 'floating_surface_segment.dart';

class FloatingSurfacePayload {
  static const currentSchemaVersion = 2;

  final FloatingSurfaceLayout layout;
  final List<FloatingSurfaceSegment> segments;

  const FloatingSurfacePayload({
    this.layout = FloatingSurfaceLayout.stacked,
    required this.segments,
  });

  bool get isEmpty => segments.isEmpty;

  Map<String, Object?> toMap() {
    return {
      'schemaVersion': currentSchemaVersion,
      'layout': layout.code,
      'segments': segments.map((segment) => segment.toMap()).toList(),
    };
  }

  String get signature {
    return '${layout.code}|${segments.map((segment) => segment.signature).join('||')}';
  }
}

import 'floating_surface_segment_kind.dart';

class FloatingSurfaceSegment {
  final String id;
  final FloatingSurfaceSegmentKind kind;
  final bool enabled;
  final int order;
  final String primaryText;
  final String? secondaryText;
  final String? metaText;
  final String level;
  final Map<String, Object?> data;

  const FloatingSurfaceSegment({
    required this.id,
    required this.kind,
    this.enabled = true,
    required this.order,
    required this.primaryText,
    this.secondaryText,
    this.metaText,
    required this.level,
    this.data = const {},
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'kind': kind.code,
      'enabled': enabled,
      'order': order,
      'primaryText': primaryText,
      'secondaryText': secondaryText,
      'metaText': metaText,
      'level': level,
      'data': data,
    };
  }

  String get signature {
    final dataSignature = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return [
      id,
      kind.code,
      enabled.toString(),
      order.toString(),
      primaryText,
      secondaryText ?? '',
      metaText ?? '',
      level,
      dataSignature
          .map((entry) => '${entry.key}:${entry.value ?? ''}')
          .join(','),
    ].join('|');
  }
}

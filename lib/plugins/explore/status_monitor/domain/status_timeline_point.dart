import 'status_component_kind.dart';
import 'status_level.dart';

class StatusTimelinePoint {
  final DateTime at;
  final StatusComponentKind component;
  final StatusLevel level;
  final String summary;

  const StatusTimelinePoint({
    required this.at,
    required this.component,
    required this.level,
    required this.summary,
  });

  Map<String, Object?> toJson() => {
        'at': at.millisecondsSinceEpoch,
        'component': component.name,
        'level': level.name,
        'summary': summary,
      };
}

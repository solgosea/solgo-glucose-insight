import 'component_health.dart';
import 'status_component_kind.dart';
import 'status_level.dart';
import 'status_source_capabilities.dart';
import 'status_timeline_point.dart';

class StatusSummary {
  final StatusLevel level;
  final String headline;
  final String body;
  final String meta;
  final int healthyCount;
  final int totalCount;

  const StatusSummary({
    required this.level,
    required this.headline,
    required this.body,
    required this.meta,
    required this.healthyCount,
    required this.totalCount,
  });

  Map<String, Object?> toJson() => {
        'level': level.name,
        'headline': headline,
        'body': body,
        'meta': meta,
        'healthyCount': healthyCount,
        'totalCount': totalCount,
      };
}

class StatusReport {
  final String subjectId;
  final String? sourceTargetId;
  final String sourceKind;
  final String sourceLabel;
  final DateTime generatedAt;
  final StatusSummary summary;
  final List<ComponentHealth> components;
  final List<StatusTimelinePoint> recentEvents;
  final StatusSourceCapabilities capabilities;
  final bool hasConfiguredSource;
  final String? emptyReason;

  const StatusReport({
    required this.subjectId,
    this.sourceTargetId,
    required this.sourceKind,
    required this.sourceLabel,
    required this.generatedAt,
    required this.summary,
    required this.components,
    required this.recentEvents,
    required this.capabilities,
    required this.hasConfiguredSource,
    this.emptyReason,
  });

  ComponentHealth component(StatusComponentKind kind) {
    return components.firstWhere((component) => component.kind == kind);
  }

  Map<String, Object?> toJson() => {
        'subjectId': subjectId,
        'sourceTargetId': sourceTargetId,
        'sourceKind': sourceKind,
        'sourceLabel': sourceLabel,
        'generatedAt': generatedAt.millisecondsSinceEpoch,
        'summary': summary.toJson(),
        'components':
            components.map((component) => component.toJson()).toList(),
        'recentEvents': recentEvents.map((event) => event.toJson()).toList(),
        'capabilityMode': capabilities.modeLabel,
        'hasConfiguredSource': hasConfiguredSource,
        'emptyReason': emptyReason,
      };
}

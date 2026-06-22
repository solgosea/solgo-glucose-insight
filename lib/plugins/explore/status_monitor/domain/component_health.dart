import 'detail/status_component_detail_data.dart';
import 'scoring/status_component_score.dart';
import 'status_component_kind.dart';
import 'status_direction.dart';
import 'status_level.dart';
import 'status_metric.dart';
import 'status_timeline_point.dart';

class ComponentHealth {
  final StatusComponentKind kind;
  final StatusLevel level;
  final String title;
  final String role;
  final String takeaway;
  final String summary;
  final List<StatusMetric> metrics;
  final List<StatusDirection> directions;
  final List<StatusTimelinePoint> history;
  final StatusComponentScore? score;
  final StatusComponentDetailData? detailData;

  const ComponentHealth({
    required this.kind,
    required this.level,
    required this.title,
    required this.role,
    required this.takeaway,
    required this.summary,
    required this.metrics,
    this.directions = const [],
    this.history = const [],
    this.score,
    this.detailData,
  });

  static StatusLevel worstAvailableMetricLevel(List<StatusMetric> metrics) {
    final available = metrics.where((metric) => metric.available).toList();
    if (available.isEmpty) return StatusLevel.unknown;
    return available
        .map((metric) => metric.level)
        .reduce((a, b) => a.severity >= b.severity ? a : b);
  }

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'level': level.name,
        'title': title,
        'role': role,
        'takeaway': takeaway,
        'summary': summary,
        'metrics': metrics.map((metric) => metric.toJson()).toList(),
        'directions':
            directions.map((direction) => direction.toJson()).toList(),
        'history': history.map((point) => point.toJson()).toList(),
        'score': score == null
            ? null
            : {
                'value': score!.value,
                'label': score!.label,
                'confidence': score!.confidence,
                'availableSignals': score!.availableSignals,
                'totalSignals': score!.totalSignals,
              },
        'detailData': detailData?.toJson(),
      };
}

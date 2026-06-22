import 'status_level.dart';
import 'status_metric_source.dart';
import 'status_threshold.dart';

class StatusMetric {
  final String id;
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final StatusMetricSource source;
  final DateTime? observedAt;
  final bool available;
  final String? unavailableReason;
  final StatusThreshold? threshold;
  final String? note;
  final Map<String, Object?> metadata;

  const StatusMetric({
    required this.id,
    required this.label,
    required this.valueLabel,
    required this.level,
    required this.source,
    this.observedAt,
    this.available = true,
    this.unavailableReason,
    this.threshold,
    this.note,
    this.metadata = const {},
  });

  const StatusMetric.unknown({
    required this.id,
    required this.label,
    required this.source,
    required String reason,
    this.threshold,
    this.note,
    this.metadata = const {},
  })  : valueLabel = 'Unknown',
        level = StatusLevel.unknown,
        observedAt = null,
        available = false,
        unavailableReason = reason;

  Map<String, Object?> toJson() => {
        'id': id,
        'label': label,
        'valueLabel': valueLabel,
        'level': level.name,
        'source': source.name,
        'observedAt': observedAt?.millisecondsSinceEpoch,
        'available': available,
        'unavailableReason': unavailableReason,
        'threshold': threshold == null
            ? null
            : {
                'healthy': threshold!.healthyLabel,
                'watch': threshold!.watchLabel,
                'issue': threshold!.issueLabel,
              },
        'note': note,
        'metadata': metadata,
      };
}

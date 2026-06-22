import '../status_component_kind.dart';
import '../status_level.dart';
import 'status_history_sample_source.dart';

class StatusComponentHistorySample {
  final DateTime at;
  final StatusComponentKind component;
  final StatusLevel level;
  final int? score;
  final double? confidence;
  final String summary;
  final StatusHistorySampleSource source;

  const StatusComponentHistorySample({
    required this.at,
    required this.component,
    required this.level,
    this.score,
    this.confidence,
    required this.summary,
    required this.source,
  });
}

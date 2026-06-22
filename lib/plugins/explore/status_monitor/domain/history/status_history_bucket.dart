import '../status_component_kind.dart';
import '../status_level.dart';
import 'status_component_history_sample.dart';
import 'status_history_bucket_reason.dart';

class StatusHistoryBucket {
  final StatusComponentKind component;
  final DateTime start;
  final DateTime end;
  final StatusLevel level;
  final int? score;
  final String summary;
  final StatusHistoryBucketReason reason;
  final StatusComponentHistorySample? sample;

  const StatusHistoryBucket({
    required this.component,
    required this.start,
    required this.end,
    required this.level,
    this.score,
    required this.summary,
    required this.reason,
    this.sample,
  });
}

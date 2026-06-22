import '../status_component_kind.dart';
import '../status_level.dart';
import 'status_history_bucket.dart';

class StatusComponentHistoryResult {
  final StatusComponentKind component;
  final StatusLevel currentLevel;
  final List<StatusHistoryBucket> dailyBuckets;
  final List<List<StatusHistoryBucket>> hourlyBuckets;
  final double coverage;

  const StatusComponentHistoryResult({
    required this.component,
    required this.currentLevel,
    required this.dailyBuckets,
    required this.hourlyBuckets,
    required this.coverage,
  });
}

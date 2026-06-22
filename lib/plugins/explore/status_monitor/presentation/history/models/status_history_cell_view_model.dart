import '../../../domain/status_level.dart';
import '../../../domain/history/status_history_bucket_reason.dart';

class StatusHistoryCellViewModel {
  final DateTime at;
  final String label;
  final StatusLevel level;
  final int? score;
  final StatusHistoryBucketReason reason;
  final String reasonLabel;
  final String summary;

  const StatusHistoryCellViewModel({
    required this.at,
    required this.label,
    required this.level,
    this.score,
    this.reason = StatusHistoryBucketReason.noSample,
    required this.reasonLabel,
    this.summary = '',
  });
}

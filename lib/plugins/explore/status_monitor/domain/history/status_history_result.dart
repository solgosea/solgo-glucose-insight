import 'status_component_history_result.dart';
import 'status_history_query.dart';

class StatusHistoryResult {
  final StatusHistoryQuery query;
  final List<StatusComponentHistoryResult> components;

  const StatusHistoryResult({
    required this.query,
    required this.components,
  });
}

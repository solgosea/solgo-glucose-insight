import '../component_health.dart';
import 'status_component_history_load_state.dart';
import 'status_component_history_result.dart';

class StatusComponentHistoryLoadResult {
  final ComponentHealth component;
  final StatusComponentHistoryLoadState state;
  final StatusComponentHistoryResult? result;
  final Object? error;

  const StatusComponentHistoryLoadResult({
    required this.component,
    required this.state,
    this.result,
    this.error,
  });

  StatusComponentHistoryLoadResult copyWith({
    StatusComponentHistoryLoadState? state,
    StatusComponentHistoryResult? result,
    Object? error,
    bool clearError = false,
  }) {
    return StatusComponentHistoryLoadResult(
      component: component,
      state: state ?? this.state,
      result: result ?? this.result,
      error: clearError ? null : error ?? this.error,
    );
  }
}

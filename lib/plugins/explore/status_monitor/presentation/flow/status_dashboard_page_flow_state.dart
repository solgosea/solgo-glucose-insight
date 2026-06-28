import 'status_dashboard_page_flow_phase.dart';

class StatusDashboardPageFlowState {
  final StatusDashboardPageFlowPhase phase;
  final Object? error;

  const StatusDashboardPageFlowState({
    required this.phase,
    this.error,
  });

  const StatusDashboardPageFlowState.idle()
      : this(phase: StatusDashboardPageFlowPhase.idle);

  StatusDashboardPageFlowState copyWith({
    StatusDashboardPageFlowPhase? phase,
    Object? error,
    bool clearError = false,
  }) {
    return StatusDashboardPageFlowState(
      phase: phase ?? this.phase,
      error: clearError ? null : error ?? this.error,
    );
  }
}

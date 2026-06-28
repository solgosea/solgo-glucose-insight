import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import 'status_check_component_phase.dart';

class StatusCheckComponentState {
  final StatusComponentKind kind;
  final StatusCheckComponentPhase phase;
  final String stepLabel;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final ComponentHealth? health;
  final Object? error;

  const StatusCheckComponentState({
    required this.kind,
    required this.phase,
    this.stepLabel = '',
    this.startedAt,
    this.finishedAt,
    this.health,
    this.error,
  });

  const StatusCheckComponentState.queued({
    required StatusComponentKind kind,
    String stepLabel = '',
  }) : this(
          kind: kind,
          phase: StatusCheckComponentPhase.queued,
          stepLabel: stepLabel,
        );

  StatusCheckComponentState copyWith({
    StatusCheckComponentPhase? phase,
    String? stepLabel,
    DateTime? startedAt,
    DateTime? finishedAt,
    ComponentHealth? health,
    Object? error,
    bool clearError = false,
  }) {
    return StatusCheckComponentState(
      kind: kind,
      phase: phase ?? this.phase,
      stepLabel: stepLabel ?? this.stepLabel,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      health: health ?? this.health,
      error: clearError ? null : error ?? this.error,
    );
  }
}

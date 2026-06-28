import 'package:collection/collection.dart';

import '../../../domain/status_component_kind.dart';
import 'status_check_component_phase.dart';
import 'status_check_component_state.dart';
import 'status_check_session_id.dart';
import 'status_check_session_phase.dart';

class StatusCheckSessionState {
  final StatusCheckSessionId id;
  final String subjectId;
  final StatusCheckSessionPhase phase;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final List<StatusCheckComponentState> components;
  final Object? error;

  const StatusCheckSessionState({
    required this.id,
    required this.subjectId,
    required this.phase,
    required this.startedAt,
    required this.components,
    this.finishedAt,
    this.error,
  });

  int get totalCount => components.length;

  int get completedCount => components
      .where((state) =>
          state.phase == StatusCheckComponentPhase.completed ||
          state.phase == StatusCheckComponentPhase.failed ||
          state.phase == StatusCheckComponentPhase.skipped)
      .length;

  bool get isComplete => completedCount >= totalCount && totalCount > 0;

  StatusCheckComponentState? component(StatusComponentKind kind) {
    return components.firstWhereOrNull((state) => state.kind == kind);
  }

  StatusCheckSessionState copyWith({
    StatusCheckSessionPhase? phase,
    DateTime? finishedAt,
    List<StatusCheckComponentState>? components,
    Object? error,
    bool clearError = false,
  }) {
    return StatusCheckSessionState(
      id: id,
      subjectId: subjectId,
      phase: phase ?? this.phase,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      components: components ?? this.components,
      error: clearError ? null : error ?? this.error,
    );
  }
}

import 'dart:async';

import '../../domain/component_health.dart';
import '../../domain/status_component_kind.dart';
import '../shared/status_check_shared_context.dart';
import '../checking/contracts/status_check_step_context.dart';
import 'contracts/status_check_component_definition.dart';
import 'models/status_check_component_phase.dart';
import 'models/status_check_component_state.dart';
import 'models/status_check_session_id.dart';
import 'models/status_check_session_phase.dart';
import 'models/status_check_session_state.dart';
import 'status_check_component_registry.dart';

class StatusCheckSessionRunner {
  final StatusCheckComponentRegistry registry;
  final DateTime Function() now;

  const StatusCheckSessionRunner({
    required this.registry,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Stream<StatusCheckSessionState> run({
    required String subjectId,
    required StatusCheckSharedContext sharedContext,
  }) async* {
    final startedAt = now();
    final id = StatusCheckSessionId.now(startedAt);
    var components = registry.definitions
        .map(
          (definition) => StatusCheckComponentState.queued(
            kind: definition.kind,
            stepLabel: definition.initialStepLabel,
          ),
        )
        .toList(growable: false);
    var state = StatusCheckSessionState(
      id: id,
      subjectId: subjectId,
      phase: StatusCheckSessionPhase.starting,
      startedAt: startedAt,
      components: components,
    );
    yield state;

    state = state.copyWith(phase: StatusCheckSessionPhase.running);
    yield state;

    final completed = <StatusComponentKind, ComponentHealth>{};
    final finished = <StatusComponentKind>{};
    final definitions = List<StatusCheckComponentDefinition>.from(
      registry.definitions,
    )..sort((a, b) => a.priority.index.compareTo(b.priority.index));

    final controller = StreamController<StatusCheckComponentState>();
    final running = <Future<void>>[];

    Future<void> runDefinition(
        StatusCheckComponentDefinition definition) async {
      await _waitForDependencies(definition, finished);
      final current = now();
      controller.add(
        _replacePhase(
          state.components,
          definition.kind,
          StatusCheckComponentPhase.checking,
          stepLabel: definition.runningStepLabel,
          startedAt: current,
        ),
      );
      try {
        final health = await definition.run(
          StatusCheckStepContext(shared: sharedContext, now: startedAt),
        );
        completed[definition.kind] = health;
        finished.add(definition.kind);
        controller.add(
          _replacePhase(
            state.components,
            definition.kind,
            StatusCheckComponentPhase.completed,
            stepLabel: 'Checked just now',
            finishedAt: now(),
            health: health,
          ),
        );
      } catch (error) {
        finished.add(definition.kind);
        controller.add(
          _replacePhase(
            state.components,
            definition.kind,
            StatusCheckComponentPhase.failed,
            stepLabel: 'Could not check this component',
            finishedAt: now(),
            error: error,
          ),
        );
      }
    }

    for (final definition in definitions) {
      running.add(runDefinition(definition));
    }

    unawaited(
      Future.wait(running).whenComplete(() => controller.close()),
    );

    await for (final componentState in controller.stream) {
      components = components
          .map((state) =>
              state.kind == componentState.kind ? componentState : state)
          .toList(growable: false);
      final phase = components.every(
        (component) =>
            component.phase == StatusCheckComponentPhase.completed ||
            component.phase == StatusCheckComponentPhase.failed ||
            component.phase == StatusCheckComponentPhase.skipped,
      )
          ? StatusCheckSessionPhase.completed
          : StatusCheckSessionPhase.running;
      state = state.copyWith(
        phase: phase,
        components: components,
        finishedAt: phase == StatusCheckSessionPhase.completed ? now() : null,
      );
      yield state;
    }
  }

  Future<void> _waitForDependencies(
    StatusCheckComponentDefinition definition,
    Set<StatusComponentKind> finished,
  ) async {
    if (definition.dependencies.isEmpty) return;
    while (!definition.dependencies.every(finished.contains)) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  }

  StatusCheckComponentState _replacePhase(
    List<StatusCheckComponentState> states,
    StatusComponentKind kind,
    StatusCheckComponentPhase phase, {
    required String stepLabel,
    DateTime? startedAt,
    DateTime? finishedAt,
    ComponentHealth? health,
    Object? error,
  }) {
    final previous = states.firstWhere((state) => state.kind == kind);
    return previous.copyWith(
      phase: phase,
      stepLabel: stepLabel,
      startedAt: startedAt,
      finishedAt: finishedAt,
      health: health,
      error: error,
      clearError: error == null,
    );
  }
}

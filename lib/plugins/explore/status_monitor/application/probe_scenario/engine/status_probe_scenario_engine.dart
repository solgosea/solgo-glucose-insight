import 'dart:async';

import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_run_event.dart';
import '../../../domain/probe/status_probe_run_event_type.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_definition.dart';
import '../../../domain/probe_scenario/status_probe_scenario_result.dart';
import '../../probe/catalog/status_probe_catalog_service.dart';
import '../../probe/contracts/status_probe_driver.dart';
import '../../probe/history/status_probe_history_recorder.dart';
import '../../probe/runtime/status_probe_configured_suite.dart';
import '../../probe/runtime/status_probe_event_bus.dart';
import '../../probe/runtime/status_probe_registry.dart';
import '../../probe/runtime/status_probe_result_cache.dart';
import '../../probe/runtime/status_probe_suite_runner.dart';
import '../steps/build_scenario_evidence_bundle_step.dart';
import '../steps/build_scenario_plan_step.dart';
import '../steps/build_scenario_result_step.dart';
import '../steps/load_probe_catalog_step.dart';
import '../steps/persist_scenario_history_step.dart';
import '../steps/resolve_scenario_definition_step.dart';
import '../steps/score_scenario_step.dart';
import 'status_probe_scenario_engine_input.dart';
import 'status_probe_scenario_execution_state.dart';
import 'status_probe_scenario_step.dart';

class StatusProbeScenarioEngine {
  final StatusProbeRegistry registry;
  final StatusProbeCatalogService catalogService;
  final StatusProbeSuiteRunner suiteRunner;
  final StatusProbeResultCache cache;
  final StatusProbeEventBus eventBus;
  final StatusProbeHistoryRecorder? historyRecorder;
  final DateTime Function() now;

  const StatusProbeScenarioEngine({
    required this.registry,
    required this.catalogService,
    required this.cache,
    required this.eventBus,
    this.historyRecorder,
    this.suiteRunner = const StatusProbeSuiteRunner(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<StatusProbeScenarioResult> run(
    StatusProbeContext context,
    String scenarioId,
  ) async {
    StatusProbeScenarioResult? result;
    await for (final event in runStream(context, scenarioId)) {
      if (event.type == StatusProbeRunEventType.runCompleted) {
        result = event.scenarioResult;
      }
    }
    if (result == null) {
      throw StateError('Probe scenario $scenarioId did not complete.');
    }
    return result;
  }

  Stream<StatusProbeRunEvent> runStream(
    StatusProbeContext context,
    String scenarioId,
  ) async* {
    var state = StatusProbeScenarioExecutionState(
      input: StatusProbeScenarioEngineInput(
        context: context,
        scenarioId: scenarioId,
      ),
    );
    yield StatusProbeRunEvent(
      type: StatusProbeRunEventType.runStarted,
      scenarioId: scenarioId,
      occurredAt: now(),
    );
    try {
      for (final step in _preProbeSteps()) {
        state = await step.execute(state);
      }
      await for (final event in _runScenarioProbes(state)) {
        yield event;
        if (event.type == StatusProbeRunEventType.suiteCompleted &&
            event.suiteResult != null) {
          state = state.copyWith(
            suiteResults: [...state.suiteResults, event.suiteResult!],
          );
        }
      }
      for (final step in _postProbeSteps()) {
        state = await step.execute(state);
      }
      final bundle = state.bundle;
      if (bundle != null) {
        cache.update(bundle);
        eventBus.publish(bundle);
      }
      yield StatusProbeRunEvent(
        type: StatusProbeRunEventType.runCompleted,
        scenarioId: scenarioId,
        scenarioResult: state.result,
        occurredAt: now(),
      );
    } catch (error) {
      yield StatusProbeRunEvent(
        type: StatusProbeRunEventType.runFailed,
        scenarioId: scenarioId,
        error: error,
        occurredAt: now(),
      );
    }
  }

  List<StatusProbeScenarioStep> _preProbeSteps() {
    return [
      LoadProbeCatalogStep(catalogService: catalogService),
      const ResolveScenarioDefinitionStep(),
      const BuildScenarioPlanStep(),
    ];
  }

  List<StatusProbeScenarioStep> _postProbeSteps() {
    return [
      BuildScenarioEvidenceBundleStep(now: now),
      const ScoreScenarioStep(),
      PersistScenarioHistoryStep(historyRecorder: historyRecorder),
      const BuildScenarioResultStep(),
    ];
  }

  Stream<StatusProbeRunEvent> _runScenarioProbes(
    StatusProbeScenarioExecutionState state,
  ) async* {
    final plan = state.plan;
    if (plan == null) {
      throw StateError('Scenario plan must be built before running probes.');
    }
    final suites = _configuredSuites(state);
    if (suites.isEmpty) return;

    final controller = StreamController<StatusProbeRunEvent>();
    var remaining = suites.length;

    Future<void> runSuite(StatusProbeConfiguredSuite configuredSuite) async {
      try {
        await for (final event in _runSuite(
          configuredSuite,
          state.input.context,
          state.input.scenarioId,
        )) {
          controller.add(event);
        }
      } catch (error) {
        controller.add(
          StatusProbeRunEvent(
            type: StatusProbeRunEventType.runFailed,
            scenarioId: state.input.scenarioId,
            suiteId: configuredSuite.definition.id,
            error: error,
            occurredAt: now(),
          ),
        );
      } finally {
        remaining -= 1;
        if (remaining == 0) {
          await controller.close();
        }
      }
    }

    for (final configuredSuite in suites) {
      unawaited(runSuite(configuredSuite));
    }

    yield* controller.stream;
  }

  List<StatusProbeConfiguredSuite> _configuredSuites(
    StatusProbeScenarioExecutionState state,
  ) {
    final plan = state.plan!;
    final suites = <StatusProbeConfiguredSuite>[];
    for (final suiteId in plan.suiteIds) {
      final suite = registry.suite(suiteId);
      if (suite == null) continue;
      final items = plan.itemsForSuite(suiteId);
      final probeIds = {for (final item in items) item.probe.probeId};
      final drivers = suite.drivers
          .where((driver) => probeIds.contains(driver.definition.id.value))
          .toList(growable: false);
      suites.add(
        StatusProbeConfiguredSuite(
          definition: StatusProbeSuiteDefinition(
            id: suite.definition.id,
            label: suite.definition.label,
            kind: suite.definition.kind,
            probes: drivers.map((driver) => driver.definition).toList(),
          ),
          drivers: drivers,
          activationProbeIds: {
            for (final item in items)
              if (item.activationProbe) item.probe.probeId,
          },
          skipWhenInactive: items.any((item) => item.activationProbe),
        ),
      );
    }
    return suites;
  }

  Stream<StatusProbeRunEvent> _runSuite(
    StatusProbeConfiguredSuite suite,
    StatusProbeContext context,
    String scenarioId,
  ) async* {
    if (!suite.skipWhenInactive || suite.activationProbeIds.isEmpty) {
      yield* suiteRunner.runStream(suite, context, scenarioId);
      return;
    }

    yield StatusProbeRunEvent(
      type: StatusProbeRunEventType.suiteStarted,
      scenarioId: scenarioId,
      suiteId: suite.definition.id,
      occurredAt: now(),
    );
    final activationDrivers = suite.drivers
        .where((driver) =>
            suite.activationProbeIds.contains(driver.definition.id.value))
        .toList(growable: false);
    final remainingDrivers = suite.drivers
        .where((driver) =>
            !suite.activationProbeIds.contains(driver.definition.id.value))
        .toList(growable: false);
    final results = <StatusProbeResult>[];
    for (final driver in activationDrivers) {
      yield _startedEvent(scenarioId, suite.definition.id, driver);
      final result = await suiteRunner.runner.run(driver, context);
      results.add(result);
      yield _completedEvent(scenarioId, suite.definition.id, result);
    }
    final active =
        results.any((result) => result.state == StatusProbeState.healthy);
    if (!active) {
      for (final driver in remainingDrivers) {
        final result = _skippedProbe(driver, context.now);
        results.add(result);
        yield StatusProbeRunEvent(
          type: StatusProbeRunEventType.probeSkipped,
          scenarioId: scenarioId,
          suiteId: suite.definition.id,
          probeId: driver.definition.id.value,
          result: result,
          occurredAt: now(),
        );
      }
      yield _suiteCompleted(suite, scenarioId, results);
      return;
    }
    for (final driver in remainingDrivers) {
      yield _startedEvent(scenarioId, suite.definition.id, driver);
      final result = await suiteRunner.runner.run(driver, context);
      results.add(result);
      yield _completedEvent(scenarioId, suite.definition.id, result);
    }
    yield _suiteCompleted(suite, scenarioId, results);
  }

  StatusProbeRunEvent _startedEvent(
    String scenarioId,
    String suiteId,
    StatusProbeDriver driver,
  ) {
    return StatusProbeRunEvent(
      type: StatusProbeRunEventType.probeStarted,
      scenarioId: scenarioId,
      suiteId: suiteId,
      probeId: driver.definition.id.value,
      occurredAt: now(),
    );
  }

  StatusProbeRunEvent _completedEvent(
    String scenarioId,
    String suiteId,
    StatusProbeResult result,
  ) {
    return StatusProbeRunEvent(
      type: result.error == null
          ? StatusProbeRunEventType.probeCompleted
          : StatusProbeRunEventType.probeFailed,
      scenarioId: scenarioId,
      suiteId: suiteId,
      probeId: result.probeId,
      result: result,
      error: result.error,
      occurredAt: now(),
    );
  }

  StatusProbeRunEvent _suiteCompleted(
    StatusProbeConfiguredSuite suite,
    String scenarioId,
    List<StatusProbeResult> results,
  ) {
    return StatusProbeRunEvent(
      type: StatusProbeRunEventType.suiteCompleted,
      scenarioId: scenarioId,
      suiteId: suite.definition.id,
      suiteResult: suiteRunner.summaryPolicy.summarize(
        definition: suite.definition,
        results: results,
        observedAt: now(),
      ),
      occurredAt: now(),
    );
  }

  StatusProbeResult _skippedProbe(
    StatusProbeDriver driver,
    DateTime observedAt,
  ) {
    return StatusProbeResult(
      definition: driver.definition,
      state: StatusProbeState.notObserved,
      observedAt: observedAt,
      confidence: 0,
      runMode: driver.definition.runMode,
      summary: 'Not used for this detected setup.',
    );
  }
}

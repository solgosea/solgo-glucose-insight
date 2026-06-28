import 'package:smart_xdrip/application/subject/active_subject_service.dart';

import '../probe_scenario/scenarios/status_probe_scenario_ids.dart';
import '../probe_scenario/engine/status_probe_scenario_engine.dart';
import '../status_monitor_target_resolver.dart';
import '../../domain/probe/status_probe_context.dart';
import '../../domain/probe/status_probe_evidence_bundle.dart';
import '../../domain/probe/status_probe_run_event_type.dart';
import '../../domain/probe/status_probe_suite_result.dart';
import '../probe/builders/status_probe_evidence_bundle_builder.dart';
import '../probe/runtime/status_probe_result_cache.dart';
import 'facts/status_hub_probe_fact_adapter.dart';
import 'status_hub_engine.dart';
import 'status_hub_engine_input.dart';
import 'status_hub_engine_output.dart';

class StatusHubControllerFacade {
  final ActiveSubjectService activeSubjectService;
  final StatusMonitorTargetResolver targetResolver;
  final StatusProbeScenarioEngine scenarioEngine;
  final StatusProbeResultCache resultCache;
  final StatusProbeEvidenceBundleBuilder bundleBuilder;
  final StatusHubProbeFactAdapter factAdapter;
  final StatusHubEngine engine;
  final DateTime Function() now;

  const StatusHubControllerFacade({
    required this.activeSubjectService,
    required this.targetResolver,
    required this.scenarioEngine,
    required this.resultCache,
    this.bundleBuilder = const StatusProbeEvidenceBundleBuilder(),
    this.factAdapter = const StatusHubProbeFactAdapter(),
    this.engine = const StatusHubEngine(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  StatusHubEngineOutput buildInitialHub() {
    final cached = resultCache.latest;
    if (cached != null) {
      return _buildFromBundle(cached, now());
    }
    final subject = activeSubjectService.current;
    final effectiveNow = now();
    return _buildFromBundle(
      StatusProbeEvidenceBundle(
        subjectId: subject.id,
        generatedAt: effectiveNow,
        suites: const [],
      ),
      effectiveNow,
    );
  }

  Future<StatusHubEngineOutput> buildHub() async {
    final subject = activeSubjectService.current;
    final effectiveNow = now();
    final target = await targetResolver.resolve(subject);
    final probeResult = await scenarioEngine.run(
      StatusProbeContext(
        subjectId: subject.id,
        now: effectiveNow,
        target: target,
      ),
      StatusProbeScenarioIds.overview,
    );
    return _buildFromBundle(probeResult.bundle, effectiveNow);
  }

  Stream<StatusHubEngineOutput> watchHub() async* {
    final subject = activeSubjectService.current;
    final effectiveNow = now();
    final target = await targetResolver.resolve(subject);
    final suitesById = <String, StatusProbeSuiteResult>{};
    await for (final event in scenarioEngine.runStream(
      StatusProbeContext(
        subjectId: subject.id,
        now: effectiveNow,
        target: target,
      ),
      StatusProbeScenarioIds.overview,
    )) {
      if (event.type == StatusProbeRunEventType.runFailed) {
        throw event.error ?? StateError('Hub probe refresh failed.');
      }
      if (event.type == StatusProbeRunEventType.suiteCompleted &&
          event.suiteResult != null) {
        suitesById[event.suiteResult!.suiteId] = event.suiteResult!;
        yield _buildFromBundle(
          bundleBuilder.build(
            subjectId: subject.id,
            generatedAt: event.occurredAt,
            suites: suitesById.values.toList(growable: false),
          ),
          event.occurredAt,
        );
      }
      if (event.type == StatusProbeRunEventType.runCompleted &&
          event.scenarioResult != null) {
        yield _buildFromBundle(
          event.scenarioResult!.bundle,
          event.occurredAt,
        );
      }
    }
  }

  StatusHubEngineOutput _buildFromBundle(
    StatusProbeEvidenceBundle bundle,
    DateTime effectiveNow,
  ) {
    final facts = factAdapter.build(bundle, now: effectiveNow);
    return engine.run(StatusHubEngineInput(facts: facts, now: effectiveNow));
  }
}

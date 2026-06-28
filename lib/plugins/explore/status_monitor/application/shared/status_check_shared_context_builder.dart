import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';

import '../../domain/probe/status_probe_context.dart';
import '../../domain/probe/status_probe_evidence_bundle.dart';
import '../component_evidence/status_component_evidence_adapter.dart';
import '../component_evidence/status_component_evidence_bundle_builder.dart';
import '../probe_scenario/scenarios/status_probe_scenario_ids.dart';
import '../probe_scenario/engine/status_probe_scenario_engine.dart';
import '../component_evidence/loaders/status_component_evidence_plan.dart';
import '../status_monitor_target_resolver.dart';
import 'status_check_shared_context.dart';

class StatusCheckSharedContextBuilder {
  final GlucoseDatabase database;
  final ActiveSubjectService activeSubjectService;
  final StatusMonitorTargetResolver targetResolver;
  final StatusProbeScenarioEngine? probeScenarioEngine;
  final StatusComponentEvidenceBundleBuilder evidenceBuilder;
  final StatusComponentEvidenceAdapter componentEvidenceAdapter;

  const StatusCheckSharedContextBuilder({
    required this.database,
    required this.activeSubjectService,
    required this.targetResolver,
    this.probeScenarioEngine,
    this.evidenceBuilder = const StatusComponentEvidenceBundleBuilder(),
    this.componentEvidenceAdapter = const StatusComponentEvidenceAdapter(),
  });

  Future<StatusCheckSharedContext> build({required DateTime now}) async {
    final subject = activeSubjectService.snapshot().subject;
    final plan = StatusComponentEvidencePlan(
      subjectId: subject.id,
      xdripLocal: targetResolver.resolveSelfXdripLocal(subject),
      nightscout: await targetResolver.resolveEnabledNightscout(subject),
    );
    final seed = StatusCheckSharedContextSeed(
      subjectId: subject.id,
      now: now,
      database: database,
      plan: plan,
    );

    final probeFuture = _runProbeEvidence(subject.id, now);
    final statusEvidence = await evidenceBuilder.buildStatusEvidence(seed);
    final probeEvidence = await probeFuture;
    final componentEvidence = componentEvidenceAdapter.build(
      subjectId: subject.id,
      generatedAt: now,
      statusEvidence: statusEvidence,
      probeEvidence: probeEvidence,
    );

    return StatusCheckSharedContext(
      subjectId: subject.id,
      now: now,
      database: database,
      plan: plan,
      evidence: statusEvidence,
      probeEvidence: probeEvidence,
      componentEvidence: componentEvidence,
    );
  }

  Future<StatusProbeEvidenceBundle?> _runProbeEvidence(
    String subjectId,
    DateTime now,
  ) async {
    final engine = probeScenarioEngine;
    if (engine == null) return null;
    final target = await targetResolver.resolve(activeSubjectService.current);
    final result = await engine.run(
      StatusProbeContext(subjectId: subjectId, now: now, target: target),
      StatusProbeScenarioIds.overview,
    );
    return result.bundle;
  }
}

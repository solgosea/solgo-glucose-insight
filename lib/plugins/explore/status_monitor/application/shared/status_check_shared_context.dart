import 'package:smart_xdrip/data/local/glucose_database.dart';

import '../../domain/component_evidence/status_component_evidence_bundle.dart'
    as component;
import '../../domain/evidence/status_evidence_bundle.dart';
import '../../domain/probe/status_probe_evidence_bundle.dart';
import '../component_evidence/loaders/status_component_evidence_plan.dart';

class StatusCheckSharedContextSeed {
  final String subjectId;
  final DateTime now;
  final GlucoseDatabase database;
  final StatusComponentEvidencePlan plan;

  const StatusCheckSharedContextSeed({
    required this.subjectId,
    required this.now,
    required this.database,
    required this.plan,
  });
}

class StatusCheckSharedContext {
  final String subjectId;
  final DateTime now;
  final GlucoseDatabase database;
  final StatusComponentEvidencePlan plan;
  final StatusEvidenceBundle evidence;
  final StatusProbeEvidenceBundle? probeEvidence;
  final component.StatusComponentEvidenceBundle componentEvidence;

  const StatusCheckSharedContext({
    required this.subjectId,
    required this.now,
    required this.database,
    required this.plan,
    required this.evidence,
    this.probeEvidence,
    required this.componentEvidence,
  });
}

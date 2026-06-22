import '../evidence/status_evidence_bundle.dart';

class StatusAnalysisContext {
  final DateTime now;
  final StatusEvidenceBundle evidence;

  const StatusAnalysisContext({
    required this.now,
    required this.evidence,
  });
}

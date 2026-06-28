import '../../domain/evidence/status_evidence_bundle.dart';
import 'status_check_shared_context.dart';

class StatusReportSourceEvidenceBuilder {
  const StatusReportSourceEvidenceBuilder();

  StatusEvidenceBundle build(StatusCheckSharedContext context) {
    return context.evidence;
  }
}

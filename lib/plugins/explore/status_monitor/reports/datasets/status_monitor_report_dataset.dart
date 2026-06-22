import '../status_monitor_report_payloads.dart';

class StatusMonitorReportDataset {
  final StatusMonitorSupportTriagePayload supportTriage;
  final StatusMonitorLocalCloudPayload localCloud;
  final StatusMonitorChainPayload chain;
  final StatusMonitorComponentEvidencePayload componentEvidence;
  final StatusMonitorCapabilitiesPayload capabilities;
  final StatusMonitorFreshnessPayload freshness;
  final StatusMonitorTechnicalEvidencePayload technicalEvidence;
  final StatusMonitorFirstLookPayload firstLook;

  const StatusMonitorReportDataset({
    required this.supportTriage,
    required this.localCloud,
    required this.chain,
    required this.componentEvidence,
    required this.capabilities,
    required this.freshness,
    required this.technicalEvidence,
    required this.firstLook,
  });
}

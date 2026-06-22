import '../../domain/status_report.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import 'status_monitor_report_dataset.dart';
import 'status_report_capabilities_builder.dart';
import 'status_report_chain_builder.dart';
import 'status_report_component_table_builder.dart';
import 'status_report_evidence_builder.dart';
import 'status_report_first_look_builder.dart';
import 'status_report_freshness_builder.dart';
import 'status_report_local_cloud_builder.dart';
import 'status_report_support_triage_builder.dart';

class StatusMonitorReportDatasetBuilder {
  final StatusReportSupportTriageBuilder supportTriageBuilder;
  final StatusReportLocalCloudBuilder localCloudBuilder;
  final StatusReportChainBuilder chainBuilder;
  final StatusReportComponentTableBuilder componentTableBuilder;
  final StatusReportCapabilitiesBuilder capabilitiesBuilder;
  final StatusReportFreshnessBuilder freshnessBuilder;
  final StatusReportEvidenceBuilder evidenceBuilder;
  final StatusReportFirstLookBuilder firstLookBuilder;

  const StatusMonitorReportDatasetBuilder({
    this.supportTriageBuilder = const StatusReportSupportTriageBuilder(),
    this.localCloudBuilder = const StatusReportLocalCloudBuilder(),
    this.chainBuilder = const StatusReportChainBuilder(),
    this.componentTableBuilder = const StatusReportComponentTableBuilder(),
    this.capabilitiesBuilder = const StatusReportCapabilitiesBuilder(),
    this.freshnessBuilder = const StatusReportFreshnessBuilder(),
    this.evidenceBuilder = const StatusReportEvidenceBuilder(),
    this.firstLookBuilder = const StatusReportFirstLookBuilder(),
  });

  StatusMonitorReportDataset build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    return StatusMonitorReportDataset(
      supportTriage: supportTriageBuilder.build(report, l10n: l10n),
      localCloud: localCloudBuilder.build(report, l10n: l10n),
      chain: chainBuilder.build(report, l10n: l10n),
      componentEvidence: componentTableBuilder.build(report, l10n: l10n),
      capabilities: capabilitiesBuilder.build(report, l10n: l10n),
      freshness: freshnessBuilder.build(report, l10n: l10n),
      technicalEvidence: evidenceBuilder.build(report, l10n: l10n),
      firstLook: firstLookBuilder.build(report, l10n: l10n),
    );
  }
}

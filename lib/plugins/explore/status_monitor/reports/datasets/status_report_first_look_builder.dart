import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_support_facts.dart';

class StatusReportFirstLookBuilder {
  final StatusReportSupportFactsBuilder factsBuilder;

  const StatusReportFirstLookBuilder({
    this.factsBuilder = const StatusReportSupportFactsBuilder(),
  });

  StatusMonitorFirstLookPayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final facts = factsBuilder.build(report, l10n: strings);
    final findings = <StatusMonitorFindingPayload>[
      StatusMonitorFindingPayload(
        title: facts.firstLookTitle,
        body: facts.firstLookBody,
        tone: facts.firstLookTone,
      ),
      StatusMonitorFindingPayload(
        title: strings.reportFirstInspectionPathTitle,
        body: strings.reportFirstInspectionPathBody,
        tone: 'ok',
      ),
    ];
    return StatusMonitorFirstLookPayload(findings: findings);
  }
}

import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_privacy_sanitizer.dart';
import 'status_report_support_facts.dart';

class StatusReportCommunitySummaryBuilder {
  final StatusReportSupportFactsBuilder factsBuilder;
  final StatusReportPrivacySanitizer sanitizer;

  const StatusReportCommunitySummaryBuilder({
    this.factsBuilder = const StatusReportSupportFactsBuilder(),
    this.sanitizer = const StatusReportPrivacySanitizer(),
  });

  StatusMonitorCommunitySummaryPayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final facts = factsBuilder.build(report, l10n: strings);
    return StatusMonitorCommunitySummaryPayload(
      text: [
        '${strings.reportSourceModeCommunity}: ${facts.sourceMode}',
        '${strings.reportCurrentIssue}: ${facts.issuePhrase}',
        '${facts.localFreshness.label}: ${facts.localFreshness.value}',
        '${facts.serverFreshness.label}: ${facts.serverFreshness.value}',
        '${facts.localResponse.label}: ${facts.localResponse.value}',
        '${facts.serverResponse.label}: ${facts.serverResponse.value}',
        '${facts.completeness.label}: ${facts.completeness.value}',
        '${facts.largestGap.label}: ${facts.largestGap.value}',
        '${facts.aapsEvidence.label}: ${facts.aapsEvidence.value}',
        '${strings.reportCurrentIssue}: ${statusMonitorLevelLabel(report.summary.level, strings)}',
        strings.reportPrivacyCommunity,
        strings.reportCommunityQuestion,
      ]
          .map(
            (line) => sanitizer.text(
              line,
              replacement: strings.reportConfiguredSource,
            ),
          )
          .join('\n'),
    );
  }
}

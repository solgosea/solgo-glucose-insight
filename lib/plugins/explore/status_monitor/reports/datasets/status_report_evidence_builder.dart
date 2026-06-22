import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_privacy_sanitizer.dart';
import 'status_report_support_facts.dart';

class StatusReportEvidenceBuilder {
  final StatusReportSupportFactsBuilder factsBuilder;
  final StatusReportPrivacySanitizer sanitizer;

  const StatusReportEvidenceBuilder({
    this.factsBuilder = const StatusReportSupportFactsBuilder(),
    this.sanitizer = const StatusReportPrivacySanitizer(),
  });

  StatusMonitorTechnicalEvidencePayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final facts = factsBuilder.build(report, l10n: strings);
    final observed = <String>[
      '${facts.localFreshness.label}: ${facts.localFreshness.value}.',
      '${facts.serverFreshness.label}: ${facts.serverFreshness.value}.',
      '${facts.localResponse.label}: ${facts.localResponse.value}.',
      '${facts.serverResponse.label}: ${facts.serverResponse.value}.',
      '${facts.completeness.label}: ${facts.completeness.value}.',
      '${facts.largestGap.label}: ${facts.largestGap.value}.',
    ]
        .map(
          (fact) => sanitizer.text(
            fact,
            replacement: strings.reportConfiguredSource,
          ),
        )
        .toList();
    if (observed.every((fact) => fact.contains('Unknown'))) {
      observed
        ..clear()
        ..add(report.emptyReason ??
            strings.reportNoShareableStatusEvidenceVisible);
    }
    return StatusMonitorTechnicalEvidencePayload(
      observedTitle: strings.reportObservedFacts,
      limitsTitle: strings.reportLimitsOfReport,
      observedFacts: observed.take(6).toList(),
      limits: [
        strings.reportEvidenceLimitCloud,
        strings.reportEvidenceLimitDeviceLabels,
        strings.reportEvidenceLimitAaps,
        strings.reportEvidenceLimitNotAlarm,
      ],
    );
  }

  String issuePhrase(StatusReport report) {
    return factsBuilder.build(report).issuePhrase;
  }
}

import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_community_summary_builder.dart';
import 'status_report_support_facts.dart';

class StatusReportSupportTriageBuilder {
  final StatusReportSupportFactsBuilder factsBuilder;
  final StatusReportCommunitySummaryBuilder communitySummaryBuilder;

  const StatusReportSupportTriageBuilder({
    this.factsBuilder = const StatusReportSupportFactsBuilder(),
    this.communitySummaryBuilder = const StatusReportCommunitySummaryBuilder(),
  });

  StatusMonitorSupportTriagePayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final facts = factsBuilder.build(report, l10n: strings);
    return StatusMonitorSupportTriagePayload(
      label: strings.reportSuggestedFirstLookLabel,
      title: facts.firstLookTitle,
      body: facts.firstLookBody,
      evidenceScoreTitle: strings.reportEvidenceScoreTitle,
      communityCopyTitle: strings.reportCopyCommunityPost,
      privacySafeLabel: strings.reportPrivacySafe,
      reasons: [
        StatusMonitorSupportReasonPayload(
          title: strings.reportLocalReading,
          body: _freshnessReason(facts.localFreshness, strings),
          tone: facts.localFreshness.tone,
        ),
        StatusMonitorSupportReasonPayload(
          title: strings.reportCloudReading,
          body: _freshnessReason(facts.serverFreshness, strings),
          tone: facts.serverFreshness.tone,
        ),
        StatusMonitorSupportReasonPayload(
          title: strings.reportAapsContext,
          body: _aapsReason(facts.aapsEvidence, strings),
          tone: facts.aapsEvidence.tone,
        ),
      ],
      evidenceScore: _evidenceScore(report, strings),
      communityCopy: communitySummaryBuilder.build(report, l10n: strings),
    );
  }

  StatusMonitorScorePayload _evidenceScore(
    StatusReport report,
    StatusMonitorLocalizations strings,
  ) {
    final available =
        report.components.where((c) => c.level != StatusLevel.unknown).length;
    final passed = report.components.fold<int>(
      0,
      (sum, c) =>
          sum +
          c.metrics
              .where((m) => m.available && m.level == StatusLevel.healthy)
              .length,
    );
    final total = report.components.fold<int>(
      0,
      (sum, c) => sum + c.metrics.where((m) => m.available).length,
    );
    final score = total == 0 ? null : (passed / total * 100).round();
    return StatusMonitorScorePayload(
      value: score == null ? '--' : '$score',
      label: statusMonitorLevelLabel(report.summary.level, strings),
      body: strings.reportEvidenceScoreBody(
        available,
        report.components.length,
        passed,
        total,
      ),
      tone: _tone(report.summary.level),
    );
  }

  String _tone(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 'ok',
      StatusLevel.watch => 'watch',
      StatusLevel.issue => 'issue',
      StatusLevel.unknown => 'unknown',
    };
  }

  String _freshnessReason(
    StatusMonitorProbeRowPayload row,
    StatusMonitorLocalizations strings,
  ) {
    if (row.value == strings.reportUnknown) {
      return strings.reportProbeNotVisible(row.label);
    }
    return strings.reportProbeIsValue(row.label, row.value);
  }

  String _aapsReason(
    StatusMonitorProbeRowPayload row,
    StatusMonitorLocalizations strings,
  ) {
    if (row.value == strings.reportUnknown) {
      return strings.reportLoopContextNotVisible;
    }
    return strings.reportLoopContextEvidence(row.value.toLowerCase());
  }
}

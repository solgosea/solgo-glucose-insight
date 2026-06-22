import 'package:smart_xdrip/reporting/application/report_privacy_policy.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_data_quality_summary.dart';
import 'package:smart_xdrip/reporting/domain/report_disclaimer.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_section_type.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../domain/status_level.dart';
import '../domain/status_report.dart';
import '../application/i18n/status_monitor_l10n_resolver.dart';
import '../application/i18n/status_monitor_status_level_localizer.dart';
import '../l10n/generated/status_monitor_localizations.dart';
import 'datasets/status_monitor_report_dataset_builder.dart';
import 'status_monitor_report_payloads.dart';
import 'status_monitor_report_section_keys.dart';

class StatusMonitorReportAdapter {
  final ReportPrivacyPolicy privacyPolicy;
  final StatusMonitorReportDatasetBuilder datasetBuilder;
  final DateTime Function() now;

  const StatusMonitorReportAdapter({
    this.privacyPolicy = const ReportPrivacyPolicy(),
    this.datasetBuilder = const StatusMonitorReportDatasetBuilder(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  ReportSnapshot map({
    required StatusReport report,
    required ReportContext ctx,
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.resolve(ctx.locale);
    final generatedAt = now();
    final source = privacyPolicy.sourceLabel(
      ctx.sourceLabel ?? report.sourceLabel,
    );
    final dataset = datasetBuilder.build(report, l10n: strings);
    final availableMetrics =
        report.components.expand((c) => c.metrics).where((m) => m.available);
    return ReportSnapshot(
      reportId: 'status_monitor_${generatedAt.toIso8601String()}',
      title: strings.reportSupportTitle,
      range: ctx.range,
      generatedAt: generatedAt,
      sourceLabel: source,
      unit: ctx.unit,
      dataQuality: ReportDataQualitySummary(
        label: statusMonitorLevelLabel(report.summary.level, strings),
        coveragePercent: _componentCoverage(report),
        readingCount: availableMetrics.length,
        expectedReadingCount:
            report.components.fold<int>(0, (sum, c) => sum + c.metrics.length),
      ),
      findings: const [],
      disclaimer: ReportDisclaimer(strings.reportDisclaimer),
      sections: [
        ReportSection(
          id: 'hero',
          title: strings.reportTitle,
          type: ReportSectionType.summary,
          rendererKey: StatusMonitorReportSectionKeys.hero,
          payload: StatusMonitorReportHeroPayload(
            eyebrow: strings.reportEyebrow,
            title: strings.reportTitle,
            summary: strings.reportSummary,
          ),
        ),
        ReportSection(
          id: 'meta',
          title: strings.reportDetails,
          type: ReportSectionType.summary,
          rendererKey: StatusMonitorReportSectionKeys.meta,
          payload: StatusMonitorReportMetaPayload(
            windowTitle: strings.reportWindow,
            windowLabel: strings.reportWindowLiveProbe(
              _time(report.generatedAt),
            ),
            sourceModeTitle: strings.reportSourceMode,
            sourceMode:
                privacyPolicy.sourceLabel(report.capabilities.modeLabel),
            generatedTitle: strings.reportGenerated,
            generatedLabel: _dateTime(generatedAt, strings),
            privacyTitle: strings.reportPrivacy,
            privacyLabel: strings.reportPrivacyLabel,
          ),
        ),
        ReportSection(
          id: 'supportTriage',
          title: strings.reportSupportTriage,
          type: ReportSectionType.summary,
          rendererKey: StatusMonitorReportSectionKeys.supportTriage,
          payload: dataset.supportTriage,
        ),
        ReportSection(
          id: 'localCloud',
          title: strings.reportLocalCloudFreshness,
          type: ReportSectionType.metricGrid,
          rendererKey: StatusMonitorReportSectionKeys.localCloud,
          payload: dataset.localCloud,
        ),
        ReportSection(
          id: 'dataChain',
          title: strings.reportDataChainSnapshot,
          type: ReportSectionType.matrix,
          rendererKey: StatusMonitorReportSectionKeys.dataChain,
          payload: dataset.chain,
        ),
        ReportSection(
          id: 'componentEvidence',
          title: strings.reportComponentEvidence,
          type: ReportSectionType.matrix,
          rendererKey: StatusMonitorReportSectionKeys.componentEvidence,
          payload: StatusMonitorComponentEvidencePayload(
            rows: dataset.componentEvidence.rows,
            componentTitle: strings.reportComponentColumn,
            statusTitle: strings.reportStatusColumn,
            takeawayTitle: strings.reportTakeawayColumn,
            checksTitle: strings.reportChecksColumn,
            evidenceTitle: strings.reportUsefulEvidenceColumn,
          ),
        ),
        ReportSection(
          id: 'freshnessCompleteness',
          title: strings.reportFreshnessCompleteness,
          type: ReportSectionType.timeline,
          rendererKey: StatusMonitorReportSectionKeys.freshnessCompleteness,
          payload: dataset.freshness,
        ),
        ReportSection(
          id: 'sourceCapabilities',
          title: strings.reportSourceCapabilities,
          type: ReportSectionType.metricGrid,
          rendererKey: StatusMonitorReportSectionKeys.sourceCapabilities,
          payload: dataset.capabilities,
        ),
        ReportSection(
          id: 'technicalEvidence',
          title: strings.reportTechnicalEvidence,
          type: ReportSectionType.findingList,
          rendererKey: StatusMonitorReportSectionKeys.technicalEvidence,
          payload: dataset.technicalEvidence,
        ),
        ReportSection(
          id: 'firstLook',
          title: strings.reportSuggestedFirstLook,
          type: ReportSectionType.findingList,
          rendererKey: StatusMonitorReportSectionKeys.firstLook,
          payload: dataset.firstLook,
        ),
      ],
    );
  }

  double _componentCoverage(StatusReport report) {
    if (report.components.isEmpty) return 0;
    final known =
        report.components.where((c) => c.level != StatusLevel.unknown).length;
    return known / report.components.length * 100;
  }

  String _dateTime(DateTime value, StatusMonitorLocalizations l10n) {
    return '${_month(value.month, l10n)} ${value.day}, ${value.year} ${_two(value.hour)}:${_two(value.minute)}';
  }

  String _time(DateTime value) => '${_two(value.hour)}:${_two(value.minute)}';

  String _two(int value) => value.toString().padLeft(2, '0');

  String _month(int month, StatusMonitorLocalizations l10n) {
    return switch (month) {
      1 => l10n.pageMonthJan,
      2 => l10n.pageMonthFeb,
      3 => l10n.pageMonthMar,
      4 => l10n.pageMonthApr,
      5 => l10n.pageMonthMay,
      6 => l10n.pageMonthJun,
      7 => l10n.pageMonthJul,
      8 => l10n.pageMonthAug,
      9 => l10n.pageMonthSep,
      10 => l10n.pageMonthOct,
      11 => l10n.pageMonthNov,
      _ => l10n.pageMonthDec,
    };
  }
}

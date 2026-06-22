import 'package:smart_xdrip/reporting/application/report_privacy_policy.dart';
import 'package:smart_xdrip/reporting/domain/report_data_quality_summary.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_disclaimer.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_section_type.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../application/i18n/report_l10n_resolver.dart';
import '../engine/report_engine_output.dart';
import '../l10n/generated/report_localizations.dart';
import '../mappers/report_view_model_mapper.dart';
import '../models/report_section.dart' as plugin;
import '../models/report_view_model.dart';
import 'doctor_glucose_report_payloads.dart';
import 'doctor_glucose_report_section_keys.dart';

class DoctorGlucoseReportAdapter {
  final ReportViewModelMapper viewModelMapper;
  final ReportPrivacyPolicy privacyPolicy;
  final ReportLocalizations l10n;

  DoctorGlucoseReportAdapter({
    this.viewModelMapper = const ReportViewModelMapper(),
    this.privacyPolicy = const ReportPrivacyPolicy(),
    ReportLocalizations? l10n,
  }) : l10n = l10n ?? ReportL10nResolver.fallback;

  ReportSnapshot map({
    required ReportEngineOutput output,
    required List<plugin.ReportSectionToggle> sections,
    required String? sourceLabel,
  }) {
    final viewModel = viewModelMapper.map(output: output, sections: sections);
    return ReportSnapshot(
      reportId:
          'doctor_glucose_${output.period.label}_${output.generatedAt.toIso8601String()}',
      title: l10n.pluginTitle,
      range: _range(output),
      generatedAt: output.generatedAt,
      sourceLabel: privacyPolicy.sourceLabel(sourceLabel ?? _source(viewModel)),
      unit: output.settings.unit,
      dataQuality: _quality(output, viewModel),
      findings: const [],
      disclaimer: ReportDisclaimer(l10n.exportPrivacyNote),
      sections: [
        ReportSection(
          id: 'document',
          title: l10n.reportDocumentTitle,
          type: ReportSectionType.custom,
          rendererKey: DoctorGlucoseReportSectionKeys.document,
          enabledByDefault: false,
          payload: DoctorGlucoseReportDocumentPayload(
            output: output,
            viewModel: viewModel,
            sections: sections,
          ),
        ),
        for (final section in sections.where((section) => section.enabled))
          _sectionFor(output, section.key),
      ],
    );
  }

  ReportDateRange _range(ReportEngineOutput output) {
    final end = output.readings.isNotEmpty
        ? output.readings.last.timestamp
        : output.generatedAt;
    final start = end.subtract(Duration(days: output.period.days - 1));
    return ReportDateRange(start: start, end: end);
  }

  ReportDataQualitySummary _quality(
    ReportEngineOutput output,
    ReportViewModel viewModel,
  ) {
    final quality = output.metricsSection.quality;
    return ReportDataQualitySummary(
      label: l10n.reportWearLabel(quality.wearPercent.toStringAsFixed(0)),
      coveragePercent: quality.wearPercent,
      readingCount: output.readings.length,
      expectedReadingCount: viewModel.dataQuality.expectedMinutes,
      largestGapMinutes: quality.gapCount,
    );
  }

  ReportSection _sectionFor(
    ReportEngineOutput output,
    plugin.ReportSectionKey key,
  ) {
    return switch (key) {
      plugin.ReportSectionKey.keyMetrics => ReportSection(
          id: key.name,
          title: l10n.sectionKeyMetrics,
          type: ReportSectionType.metricGrid,
          rendererKey: DoctorGlucoseReportSectionKeys.keyMetrics,
          payload: DoctorGlucoseReportSectionPayload(
            key: key,
            section: output.metricsSection,
          ),
        ),
      plugin.ReportSectionKey.agpChart => ReportSection(
          id: key.name,
          title: l10n.sectionAgp,
          type: ReportSectionType.chart,
          rendererKey: DoctorGlucoseReportSectionKeys.agpChart,
          payload: DoctorGlucoseReportSectionPayload(
            key: key,
            section: output.agpSection,
          ),
        ),
      plugin.ReportSectionKey.dailyCurves => ReportSection(
          id: key.name,
          title: l10n.sectionDailyCurves,
          type: ReportSectionType.chart,
          rendererKey: DoctorGlucoseReportSectionKeys.dailyCurves,
          payload: DoctorGlucoseReportSectionPayload(
            key: key,
            section: output.dailyCurvesSection,
          ),
        ),
      plugin.ReportSectionKey.periodAnalysis => ReportSection(
          id: key.name,
          title: l10n.togglePeriodAnalysisTitle,
          type: ReportSectionType.matrix,
          rendererKey: DoctorGlucoseReportSectionKeys.periodAnalysis,
          payload: DoctorGlucoseReportSectionPayload(
            key: key,
            section: output.periodAnalysisSection,
          ),
        ),
      plugin.ReportSectionKey.episodesSummary => ReportSection(
          id: key.name,
          title: l10n.toggleEpisodesSummaryTitle,
          type: ReportSectionType.findingList,
          rendererKey: DoctorGlucoseReportSectionKeys.episodesSummary,
          payload: DoctorGlucoseReportSectionPayload(
            key: key,
            section: output.episodesSection,
          ),
        ),
    };
  }

  String _source(ReportViewModel viewModel) {
    return viewModel.header.dataSourceLabel;
  }
}

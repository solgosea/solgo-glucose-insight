import 'dart:ui';

import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_format.dart';
import 'package:smart_xdrip/reporting/domain/report_privacy_level.dart';
import 'package:smart_xdrip/reporting/domain/report_provider.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../application/report_default_sections.dart';
import '../application/report_service.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import 'doctor_glucose_report_adapter.dart';

class DoctorGlucoseReportProvider implements ReportProvider {
  static const optionPeriodDays = 'periodDays';
  static const optionSections = 'sections';

  final AnalysisFacade Function() facadeProvider;
  final ReportService service;
  final DoctorGlucoseReportAdapter adapter;

  DoctorGlucoseReportProvider({
    required this.facadeProvider,
    this.service = const ReportService(),
    DoctorGlucoseReportAdapter? adapter,
  }) : adapter = adapter ?? DoctorGlucoseReportAdapter();

  @override
  String get id => 'explore.report.doctor_glucose';

  @override
  String get title => 'Glucose Report';

  @override
  Set<ReportFormat> get supportedFormats => const {ReportFormat.pdf};

  @override
  ReportPrivacyLevel get defaultPrivacyLevel => ReportPrivacyLevel.standard;

  @override
  Future<ReportSnapshot> buildReport(ReportContext context) async {
    final period = _periodFromContext(context);
    final sections = _sectionsFromContext(context);
    final facade = facadeProvider();
    final output = service.buildOutput(
      readings: facade.readingsForLastDays(period.days),
      settings: facade.settings,
      period: period,
    );
    return adapter.map(
      output: output,
      sections: sections,
      sourceLabel: context.sourceLabel,
    );
  }

  ReportContext defaultContext({
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
    required String? sourceLabel,
  }) {
    final now = DateTime.now();
    return ReportContext(
      range: smartReportDateRange(now, period.days),
      unit: facadeProvider().settings.unit,
      privacyLevel: defaultPrivacyLevel,
      locale: PlatformDispatcher.instance.locale,
      sourceLabel: sourceLabel,
      options: {
        optionPeriodDays: period.days,
        optionSections: sections,
      },
    );
  }

  ReportPeriod _periodFromContext(ReportContext context) {
    final days = context.options[optionPeriodDays];
    if (days is int) {
      for (final period in ReportPeriod.values) {
        if (period.days == days) return period;
      }
    }
    return ReportPeriod.days30;
  }

  List<ReportSectionToggle> _sectionsFromContext(ReportContext context) {
    final sections = context.options[optionSections];
    if (sections is List<ReportSectionToggle>) return sections;
    return ReportDefaultSections.values;
  }
}

ReportContext smartDoctorGlucoseReportContext({
  required ReportPeriod period,
  required List<ReportSectionToggle> sections,
  required String? sourceLabel,
  required GlucoseUnit unit,
}) {
  final now = DateTime.now();
  return ReportContext(
    range: smartReportDateRange(now, period.days),
    unit: unit,
    privacyLevel: ReportPrivacyLevel.standard,
    locale: PlatformDispatcher.instance.locale,
    sourceLabel: sourceLabel,
    options: {
      DoctorGlucoseReportProvider.optionPeriodDays: period.days,
      DoctorGlucoseReportProvider.optionSections: sections,
    },
  );
}

ReportDateRange smartReportDateRange(DateTime end, int days) {
  return ReportDateRange(
    start: end.subtract(Duration(days: days - 1)),
    end: end,
  );
}

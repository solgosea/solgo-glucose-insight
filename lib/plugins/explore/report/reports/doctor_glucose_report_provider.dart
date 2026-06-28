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
  static const optionWindowKey = 'windowKey';
  static const optionStart = 'start';
  static const optionEnd = 'end';
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
      readings: facade.readings,
      settings: facade.settings,
      period: period,
      start: _dateOption(context, optionStart),
      end: _dateOption(context, optionEnd),
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
    DateTime? start,
    DateTime? end,
    String? windowKey,
  }) {
    final now = DateTime.now();
    return ReportContext(
      range: smartReportDateRange(
        now,
        period.days,
        start: start,
        rangeEnd: end,
      ),
      unit: facadeProvider().settings.unit,
      privacyLevel: defaultPrivacyLevel,
      locale: PlatformDispatcher.instance.locale,
      sourceLabel: sourceLabel,
      options: {
        optionPeriodDays: period.days,
        optionWindowKey: windowKey ?? period.label,
        if (start != null) optionStart: _dateKey(start),
        if (end != null) optionEnd: _dateKey(end),
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

  DateTime? _dateOption(ReportContext context, String key) {
    final value = context.options[key];
    if (value is DateTime) return DateTime(value.year, value.month, value.day);
    if (value is String) return _parseDate(value);
    return null;
  }

  DateTime? _parseDate(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }
}

ReportContext smartDoctorGlucoseReportContext({
  required ReportPeriod period,
  required List<ReportSectionToggle> sections,
  required String? sourceLabel,
  required GlucoseUnit unit,
  DateTime? start,
  DateTime? end,
  String? windowKey,
}) {
  final now = DateTime.now();
  return ReportContext(
    range: smartReportDateRange(
      now,
      period.days,
      start: start,
      rangeEnd: end,
    ),
    unit: unit,
    privacyLevel: ReportPrivacyLevel.standard,
    locale: PlatformDispatcher.instance.locale,
    sourceLabel: sourceLabel,
    options: {
      DoctorGlucoseReportProvider.optionPeriodDays: period.days,
      DoctorGlucoseReportProvider.optionWindowKey: windowKey ?? period.label,
      if (start != null)
        DoctorGlucoseReportProvider.optionStart: _dateKey(start),
      if (end != null) DoctorGlucoseReportProvider.optionEnd: _dateKey(end),
      DoctorGlucoseReportProvider.optionSections: sections,
    },
  );
}

ReportDateRange smartReportDateRange(
  DateTime end,
  int days, {
  DateTime? start,
  DateTime? rangeEnd,
}) {
  if (start != null && rangeEnd != null) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    return ReportDateRange(
      start: startDay.isAfter(endDay) ? endDay : startDay,
      end: startDay.isAfter(endDay) ? startDay : endDay,
    );
  }
  return ReportDateRange(
    start: end.subtract(Duration(days: days - 1)),
    end: end,
  );
}

String _dateKey(DateTime value) {
  return '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}

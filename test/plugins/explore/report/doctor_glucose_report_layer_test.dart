import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/report/application/report_service.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_period.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_section.dart';
import 'package:smart_xdrip/plugins/explore/report/reports/doctor_glucose_report_filename_builder.dart';
import 'package:smart_xdrip/plugins/explore/report/reports/doctor_glucose_report_provider.dart';
import 'package:smart_xdrip/plugins/explore/report/reports/doctor_glucose_report_section_keys.dart';
import 'package:smart_xdrip/plugins/explore/report/reports/rendering/doctor_glucose_report_pdf_renderer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(_resetStore);

  test('provider builds report snapshot through unified report layer',
      () async {
    final now = DateTime(2026, 6, 18, 11, 35);
    _seedAnalysisStore(now);
    final provider = DoctorGlucoseReportProvider(
      facadeProvider: AnalysisFacade.current,
      service: ReportService(now: () => now),
    );
    final sections = [
      const ReportSectionToggle(
        key: ReportSectionKey.keyMetrics,
        title: 'Key Metrics',
        subtitle: 'Core metrics',
        enabled: true,
      ),
      const ReportSectionToggle(
        key: ReportSectionKey.agpChart,
        title: 'AGP Chart',
        subtitle: 'Overlay',
        enabled: false,
      ),
    ];
    final context = smartDoctorGlucoseReportContext(
      period: ReportPeriod.days14,
      sections: sections,
      sourceLabel: 'https://example.com/api/v1?token=secret',
      unit: GlucoseUnit.mmolL,
    );

    final snapshot = await provider.buildReport(context);

    expect(snapshot.title, 'Glucose Report');
    expect(snapshot.sourceLabel, 'Configured source');
    expect(
        snapshot.sections.map((section) => section.rendererKey),
        contains(
          DoctorGlucoseReportSectionKeys.document,
        ));
    expect(
        snapshot.sections.map((section) => section.rendererKey),
        contains(
          DoctorGlucoseReportSectionKeys.keyMetrics,
        ));
    expect(
        snapshot.sections.map((section) => section.rendererKey),
        isNot(
          contains(DoctorGlucoseReportSectionKeys.agpChart),
        ));
  });

  test('renderer builds PDF output from ReportSnapshot', () async {
    final now = DateTime(2026, 6, 18, 11, 35);
    _seedAnalysisStore(now);
    final provider = DoctorGlucoseReportProvider(
      facadeProvider: AnalysisFacade.current,
      service: ReportService(now: () => now),
    );
    final snapshot = await provider.buildReport(
      smartDoctorGlucoseReportContext(
        period: ReportPeriod.days30,
        sections: const [
          ReportSectionToggle(
            key: ReportSectionKey.keyMetrics,
            title: 'Key Metrics',
            subtitle: 'Core metrics',
            enabled: true,
          ),
          ReportSectionToggle(
            key: ReportSectionKey.agpChart,
            title: 'AGP Chart',
            subtitle: 'Overlay',
            enabled: true,
          ),
          ReportSectionToggle(
            key: ReportSectionKey.dailyCurves,
            title: 'Daily Curves',
            subtitle: 'Curves',
            enabled: true,
          ),
        ],
        sourceLabel: 'xDrip+ Local',
        unit: GlucoseUnit.mmolL,
      ),
    );

    final bytes = await const DoctorGlucoseReportPdfRenderer().build(snapshot);
    final filename = const DoctorGlucoseReportFilenameBuilder().build(snapshot);

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    expect(filename, 'solgoinsight-glucose-report-30d-20260618-1135.pdf');
  });
}

void _seedAnalysisStore(DateTime now) {
  final readings = _readings(now, days: 30);
  AnalysisSessionStore.instance.update(
    AnalysisRefreshResult(
      snapshot: AnalysisSnapshot(
        generatedAt: now,
        windowStart: readings.first.timestamp,
        windowEnd: readings.last.timestamp,
        readings: readings,
        dailySummaries: const [],
        periodSummaries: const [],
        events: const [],
      ),
      insights: const [],
      subjectId: ActiveSubjectDefaults.self.id,
    ),
    settings: const AppSettings(xdripSyncEnabled: true),
    subject: ActiveSubjectDefaults.self,
  );
}

List<GlucoseReading> _readings(DateTime now, {required int days}) {
  final start =
      DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
  final readings = <GlucoseReading>[];
  for (var day = 0; day < days; day++) {
    final baseDay = start.add(Duration(days: day));
    for (var minute = 0; minute < 1440; minute += 5) {
      final hour = minute / 60;
      final value = 6.7 + 0.8 * math.sin(hour / 24 * math.pi * 2);
      readings.add(
        GlucoseReading(
          timestamp: baseDay.add(Duration(minutes: minute)),
          value: value,
        ),
      );
    }
  }
  return readings;
}

void _resetStore() {
  final store = AnalysisSessionStore.instance;
  store.clear();
  store.updateSettings(const AppSettings());
  store.setActiveSubject(ActiveSubjectDefaults.self);
}

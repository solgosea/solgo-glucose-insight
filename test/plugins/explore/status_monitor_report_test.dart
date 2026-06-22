import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/text/status_text_renderer.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/reports/status_monitor_report_adapter.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/reports/status_monitor_report_payloads.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/reports/status_monitor_report_section_keys.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/reports/rendering/status_monitor_report_pdf_renderer.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_report_factory.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_privacy_level.dart';

void main() {
  test('text renderer selects Chinese templates and falls back to English', () {
    const renderer = StatusTextRenderer(
      renderContext: PluginTextRenderContext(locale: 'zh'),
    );

    final localized = renderer.render(
      'status.xdrip.freshness.source.v1',
      const {},
    );
    final fallback = renderer.render(
      'status.nightscout.reachability.source.v1',
      const {},
    );

    expect(localized.body, '最新读数');
    expect(fallback.body, '/api/v1/status.json');
  });

  test('adapter maps StatusReport to privacy-safe report sections', () {
    const factory = FakeStatusReportFactory();
    const adapter = StatusMonitorReportAdapter();
    final report = factory.healthy(now: DateTime(2026, 6, 18, 9, 41));

    final snapshot = adapter.map(
      report: report,
      ctx: _context(
        sourceLabel: 'https://example.herokuapp.com?token=secret',
      ),
    );

    expect(snapshot.title, 'Status Monitor Support Report');
    expect(snapshot.sourceLabel, 'Configured source');
    expect(
      snapshot.sections.map((section) => section.rendererKey),
      containsAll([
        StatusMonitorReportSectionKeys.hero,
        StatusMonitorReportSectionKeys.meta,
        StatusMonitorReportSectionKeys.supportTriage,
        StatusMonitorReportSectionKeys.localCloud,
        StatusMonitorReportSectionKeys.dataChain,
        StatusMonitorReportSectionKeys.componentEvidence,
      ]),
    );
    final chain = snapshot.sections
        .singleWhere(
          (section) =>
              section.rendererKey == StatusMonitorReportSectionKeys.dataChain,
        )
        .payload as StatusMonitorChainPayload;
    expect(chain.nodes, hasLength(4));
    final supportTriage = snapshot.sections
        .singleWhere(
          (section) =>
              section.rendererKey ==
              StatusMonitorReportSectionKeys.supportTriage,
        )
        .payload as StatusMonitorSupportTriagePayload;
    final community = supportTriage.communityCopy;
    expect(community.text.toLowerCase(), isNot(contains('token')));
    expect(community.text.toLowerCase(), isNot(contains('secret')));
    expect(community.text.toLowerCase(), isNot(contains('https://')));
    expect(community.text, isNot(contains(report.subjectId)));
    final localCloud = snapshot.sections
        .singleWhere(
          (section) =>
              section.rendererKey == StatusMonitorReportSectionKeys.localCloud,
        )
        .payload as StatusMonitorLocalCloudPayload;
    expect(localCloud.rows.map((row) => row.label),
        containsAll(['24h completeness', 'Largest visible gap']));
  });

  test('adapter maps StatusReport report payloads using Chinese locale', () {
    const factory = FakeStatusReportFactory();
    const adapter = StatusMonitorReportAdapter();
    final report = factory.healthy(now: DateTime(2026, 6, 18, 9, 41));

    final snapshot = adapter.map(
      report: report,
      ctx: _context(
        locale: const Locale('zh'),
        sourceLabel: 'https://example.herokuapp.com?token=secret',
      ),
    );

    expect(snapshot.title, '状态监控支持报告');
    expect(snapshot.sourceLabel, 'Configured source');
    expect(snapshot.disclaimer.text, contains('隐私安全报告'));
    final componentEvidence = snapshot.sections
        .singleWhere(
          (section) =>
              section.rendererKey ==
              StatusMonitorReportSectionKeys.componentEvidence,
        )
        .payload as StatusMonitorComponentEvidencePayload;
    expect(componentEvidence.componentTitle, '组件');
    expect(componentEvidence.evidenceTitle, '有用证据');
    final supportTriage = snapshot.sections
        .singleWhere(
          (section) =>
              section.rendererKey ==
              StatusMonitorReportSectionKeys.supportTriage,
        )
        .payload as StatusMonitorSupportTriagePayload;
    expect(supportTriage.communityCopy.text, contains('数据源模式'));
    expect(supportTriage.communityCopy.text.toLowerCase(),
        isNot(contains('https://')));
  });

  test('renderer builds non-empty Status Monitor PDF', () async {
    const factory = FakeStatusReportFactory();
    const adapter = StatusMonitorReportAdapter();
    const renderer = StatusMonitorReportPdfRenderer();
    final report = factory.healthy(now: DateTime(2026, 6, 18, 9, 41));
    final snapshot = adapter.map(report: report, ctx: _context());

    final bytes = await renderer.build(snapshot);

    expect(bytes.length, greaterThan(1000));
    expect(
        snapshot.sections.map((section) => section.id), contains('dataChain'));
    expect(snapshot.sections.map((section) => section.id),
        contains('supportTriage'));
    expect(
        snapshot.sections.map((section) => section.id), contains('localCloud'));
    expect(snapshot.sections.map((section) => section.id),
        contains('componentEvidence'));
  });
}

ReportContext _context(
    {String? sourceLabel, Locale locale = const Locale('en')}) {
  return ReportContext(
    range: ReportDateRange(
      start: DateTime(2026, 6, 17, 9, 41),
      end: DateTime(2026, 6, 18, 9, 41),
    ),
    unit: GlucoseUnit.mmolL,
    privacyLevel: ReportPrivacyLevel.standard,
    locale: locale,
    sourceLabel: sourceLabel,
  );
}

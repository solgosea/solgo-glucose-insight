import 'dart:ui';

import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_format.dart';
import 'package:smart_xdrip/reporting/domain/report_privacy_level.dart';
import 'package:smart_xdrip/reporting/domain/report_provider.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../application/status_monitor_service.dart';
import '../application/i18n/status_monitor_l10n_resolver.dart';
import 'status_monitor_report_adapter.dart';

class StatusMonitorReportProvider implements ReportProvider {
  final StatusMonitorService service;
  final StatusMonitorReportAdapter adapter;

  const StatusMonitorReportProvider({
    required this.service,
    this.adapter = const StatusMonitorReportAdapter(),
  });

  @override
  String get id => 'explore.status_monitor.report';

  @override
  String get title => StatusMonitorL10nResolver.fallback.reportSupportTitle;

  @override
  Set<ReportFormat> get supportedFormats => const {ReportFormat.pdf};

  @override
  ReportPrivacyLevel get defaultPrivacyLevel => ReportPrivacyLevel.standard;

  @override
  Future<ReportSnapshot> buildReport(ReportContext context) async {
    final report = await service.evaluate();
    final l10n = StatusMonitorL10nResolver.resolve(context.locale);
    return adapter.map(report: report, ctx: context, l10n: l10n);
  }

  static ReportContext contextFor({
    required DateTime now,
    required GlucoseUnit unit,
    String? sourceLabel,
  }) {
    return ReportContext(
      range: ReportDateRange(
        start: now.subtract(const Duration(hours: 24)),
        end: now,
      ),
      unit: unit,
      privacyLevel: ReportPrivacyLevel.standard,
      locale: const Locale('en'),
      sourceLabel: sourceLabel,
    );
  }
}

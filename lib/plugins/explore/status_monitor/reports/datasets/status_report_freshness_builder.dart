import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import '../../domain/status_timeline_point.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_support_facts.dart';

class StatusReportFreshnessBuilder {
  final StatusReportSupportFactsBuilder factsBuilder;

  const StatusReportFreshnessBuilder({
    this.factsBuilder = const StatusReportSupportFactsBuilder(),
  });

  StatusMonitorFreshnessPayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    return StatusMonitorFreshnessPayload(
      trailing: strings.reportLast24h,
      currentLegendLabel: strings.reportTimelineCurrent,
      partialLegendLabel: strings.reportTimelinePartial,
      gapLegendLabel: strings.reportTimelineGap,
      ticks: _ticks(report.recentEvents, report.generatedAt),
      rows: _rows(report, strings),
    );
  }

  List<StatusMonitorTimelineTickPayload> _ticks(
    List<StatusTimelinePoint> events,
    DateTime now,
  ) {
    final start = now.subtract(const Duration(hours: 23));
    return [
      for (var hour = 0; hour < 24; hour++)
        StatusMonitorTimelineTickPayload(
          tone: _tone(_worstForHour(events, start.add(Duration(hours: hour)))),
        ),
    ];
  }

  StatusLevel _worstForHour(List<StatusTimelinePoint> events, DateTime hour) {
    final end = hour.add(const Duration(hours: 1));
    final matching =
        events.where((e) => !e.at.isBefore(hour) && e.at.isBefore(end));
    if (matching.isEmpty) return StatusLevel.unknown;
    return matching
        .map((e) => e.level)
        .reduce((a, b) => a.severity >= b.severity ? a : b);
  }

  List<StatusMonitorProbeRowPayload> _rows(
    StatusReport report,
    StatusMonitorLocalizations strings,
  ) {
    final facts = factsBuilder.build(report, l10n: strings);
    return [
      facts.localFreshness,
      facts.serverFreshness,
      facts.localResponse,
      facts.serverResponse,
      facts.completeness,
      facts.largestGap,
    ];
  }

  String _tone(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 'ok',
      StatusLevel.watch => 'watch',
      StatusLevel.issue => 'issue',
      StatusLevel.unknown => 'unknown',
    };
  }
}

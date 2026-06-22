import '../../domain/component_health.dart';
import '../../domain/status_level.dart';
import '../../domain/status_metric.dart';
import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../application/i18n/status_monitor_metric_label_localizer.dart';
import '../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_component_l10n.dart';
import 'status_report_privacy_sanitizer.dart';

class StatusReportComponentTableBuilder {
  final StatusReportPrivacySanitizer sanitizer;

  const StatusReportComponentTableBuilder({
    this.sanitizer = const StatusReportPrivacySanitizer(),
  });

  StatusMonitorComponentEvidencePayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    return StatusMonitorComponentEvidencePayload(
      rows: [
        for (final component in report.components) _row(component, strings),
      ],
    );
  }

  StatusMonitorComponentRowPayload _row(
    ComponentHealth component,
    StatusMonitorLocalizations strings,
  ) {
    final available = component.metrics.where((m) => m.available).toList();
    final passed =
        available.where((m) => m.level == StatusLevel.healthy).length;
    final evidence = available.take(2).map((metric) {
      final displayValue = _displayValue(metric, strings);
      final note = _displayNote(metric);
      final noteText = note == null ? '' : ' - $note';
      return sanitizer.text(
        '${statusMonitorMetricLabel(metric.label, strings)}: $displayValue$noteText',
        replacement: strings.reportConfiguredSource,
      );
    }).join('; ');
    return StatusMonitorComponentRowPayload(
      component: statusReportComponentTitle(component.kind, strings),
      role: statusReportComponentRole(component.kind, strings),
      status: statusMonitorLevelLabel(component.level, strings),
      tone: _tone(component.level),
      takeaway: sanitizer.text(
        statusReportComponentTakeaway(component, strings),
        replacement: strings.reportConfiguredSource,
      ),
      checks: strings.reportChecksPassed(passed, available.length),
      evidence: evidence.isEmpty ? strings.reportNoShareableEvidence : evidence,
    );
  }

  String _displayValue(
    StatusMetric metric,
    StatusMonitorLocalizations strings,
  ) {
    if (metric.id == 'completeness_24h') {
      final note = metric.note ?? '';
      final count = RegExp(r'\d+\s*/\s*\d+').firstMatch(note)?.group(0);
      if (count != null) {
        final parts = count.split('/');
        final observed = int.tryParse(parts.first.trim());
        final expected = int.tryParse(parts.last.trim());
        if (observed != null && expected != null && expected > 0) {
          if (observed >= expected) {
            return strings.reportMeetsExpected(metric.valueLabel, expected);
          }
          return strings.reportObservedExpected(
            metric.valueLabel,
            observed,
            expected,
          );
        }
      }
    }
    return metric.valueLabel;
  }

  String? _displayNote(StatusMetric metric) {
    final note = metric.note;
    if (note == null || note.trim().isEmpty) return null;
    if (metric.id == 'completeness_24h') return null;
    return note;
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

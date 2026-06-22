import '../../domain/component_health.dart';
import '../../domain/status_report.dart';
import '../../l10n/generated/status_monitor_localizations.dart';

class StatusComponentFreshness {
  final DateTime observedAt;
  final String label;

  const StatusComponentFreshness({
    required this.observedAt,
    required this.label,
  });
}

class StatusComponentFreshnessResolver {
  const StatusComponentFreshnessResolver();

  StatusComponentFreshness resolve({
    required StatusReport report,
    required ComponentHealth component,
    StatusMonitorLocalizations? l10n,
  }) {
    final observedAt = component.metrics
            .where((metric) => metric.observedAt != null)
            .map((metric) => metric.observedAt!)
            .fold<DateTime?>(
              null,
              (latest, value) =>
                  latest == null || value.isAfter(latest) ? value : latest,
            ) ??
        report.generatedAt;
    return StatusComponentFreshness(
      observedAt: observedAt,
      label: _relative(observedAt, report.generatedAt, l10n),
    );
  }

  String _relative(
    DateTime observedAt,
    DateTime now,
    StatusMonitorLocalizations? l10n,
  ) {
    final delta = now.difference(observedAt);
    if (delta.inSeconds < 45) {
      return l10n?.widgetUpdatedJustNow ?? '0s';
    }
    if (delta.inMinutes < 60) {
      final minutes = delta.inMinutes.clamp(1, 59);
      return l10n?.widgetUpdatedMinutesAgo(minutes) ?? '${minutes}m';
    }
    if (delta.inHours < 24) {
      return l10n?.widgetUpdatedHoursAgo(delta.inHours) ?? '${delta.inHours}h';
    }
    return l10n?.widgetUpdatedDaysAgo(delta.inDays) ?? '${delta.inDays}d';
  }
}

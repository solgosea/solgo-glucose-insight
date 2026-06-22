import '../../domain/component_health.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import '../../domain/widget/status_monitor_widget_display_mode.dart';
import '../../domain/widget/status_widget_settings.dart';
import '../../domain/widget/status_widget_snapshot.dart';
import '../../domain/widget/status_widget_template.dart';
import '../i18n/status_monitor_l10n_resolver.dart';
import '../i18n/status_monitor_status_level_localizer.dart';
import 'status_widget_connection_mapper.dart';
import 'status_widget_score_aggregator.dart';

class StatusWidgetSnapshotBuilder {
  static const staleAfter = Duration(minutes: 15);

  final StatusWidgetScoreAggregator scoreAggregator;
  final StatusWidgetConnectionMapper connectionMapper;

  const StatusWidgetSnapshotBuilder({
    this.scoreAggregator = const StatusWidgetScoreAggregator(),
    this.connectionMapper = const StatusWidgetConnectionMapper(),
  });

  StatusWidgetSnapshot build({
    required StatusReport report,
    required StatusWidgetSettings settings,
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();
    final age = effectiveNow.difference(report.generatedAt);
    final stale = age > staleAfter;
    final components =
        report.components.map(_component).toList(growable: false);
    final primary = _primaryComponent(report.components);
    final freshnessLabel = _freshnessLabel(age);
    final sensor = report.component(StatusComponentKind.cgmSensor);
    final uploader = report.component(StatusComponentKind.xdrip);
    final server = report.component(StatusComponentKind.nightscout);
    final score = scoreAggregator.aggregate(report.components);
    final privateMode = settings.notificationDisplayMode ==
            StatusMonitorWidgetDisplayMode.private &&
        settings.lockScreenDisplayMode ==
            StatusMonitorWidgetDisplayMode.private;

    return StatusWidgetSnapshot(
      subjectId: report.subjectId,
      template: StatusWidgetTemplate.flow,
      headline: _headline(report, stale),
      summary: _summary(report, stale),
      sourceLabel: report.sourceLabel,
      updatedLabel: _updatedLabel(age),
      freshnessLabel: freshnessLabel,
      notificationText: _surfaceText(
        report: report,
        stale: stale,
        primary: primary,
        compactAge: freshnessLabel,
        mode: settings.notificationDisplayMode,
      ),
      lockScreenText: _surfaceText(
        report: report,
        stale: stale,
        primary: primary,
        compactAge: freshnessLabel,
        mode: settings.lockScreenDisplayMode,
      ),
      primaryIssueLabel: primary?.title ?? 'Status',
      level: report.summary.level,
      score: score,
      scoreLabel: score == null ? '--' : '$score',
      hasConfiguredSource: report.hasConfiguredSource,
      isStale: stale,
      privateMode: privateMode,
      components: components,
      sensorToUploader: connectionMapper.between(sensor.level, uploader.level),
      uploaderToServer: connectionMapper.between(
        uploader.level,
        server.level,
      ),
    );
  }

  ComponentHealth? _primaryComponent(List<ComponentHealth> components) {
    final issue =
        components.where((component) => component.level == StatusLevel.issue);
    if (issue.isNotEmpty) return issue.first;
    final watch =
        components.where((component) => component.level == StatusLevel.watch);
    if (watch.isNotEmpty) return watch.first;
    final unknown =
        components.where((component) => component.level == StatusLevel.unknown);
    if (unknown.isNotEmpty) return unknown.first;
    return components.isEmpty ? null : components.first;
  }

  String _headline(StatusReport report, bool stale) {
    final strings = StatusMonitorL10nResolver.fallback;
    if (!report.hasConfiguredSource) return strings.widgetStatusUnavailable;
    if (stale) return strings.widgetNoRecentStatus;
    return report.summary.headline;
  }

  String _summary(StatusReport report, bool stale) {
    final strings = StatusMonitorL10nResolver.fallback;
    if (!report.hasConfiguredSource) {
      return strings.widgetConnectSourceSummary;
    }
    if (stale) {
      return strings.widgetOpenToRefresh;
    }
    return report.summary.body;
  }

  String _surfaceText({
    required StatusReport report,
    required bool stale,
    required ComponentHealth? primary,
    required String compactAge,
    required StatusMonitorWidgetDisplayMode mode,
  }) {
    final strings = StatusMonitorL10nResolver.fallback;
    if (mode == StatusMonitorWidgetDisplayMode.off) return '';
    if (mode == StatusMonitorWidgetDisplayMode.private) {
      return strings.widgetStatusAvailable;
    }
    if (!report.hasConfiguredSource) return strings.widgetStatusUnavailable;
    if (stale) return strings.widgetNoRecentStatus;
    final status = switch (report.summary.level) {
      StatusLevel.healthy => strings.widgetAllSystemsHealthy,
      StatusLevel.watch => strings.widgetWatchStatus(
          primary?.title ?? strings.widgetStatus,
        ),
      StatusLevel.issue => strings.widgetComponentIssue(
          primary?.title ?? strings.widgetStatus,
        ),
      StatusLevel.unknown => strings.widgetStatusUnavailable,
    };
    if (mode == StatusMonitorWidgetDisplayMode.rangeOnly) {
      return '${statusMonitorLevelLabel(report.summary.level, strings)} - $compactAge';
    }
    return '$status - $compactAge';
  }

  StatusWidgetComponentSnapshot _component(ComponentHealth component) {
    return StatusWidgetComponentSnapshot(
      title: component.title,
      levelLabel: statusMonitorLevelLabel(
        component.level,
        StatusMonitorL10nResolver.fallback,
      ),
      level: component.level,
      detail: component.takeaway.isNotEmpty
          ? component.takeaway
          : component.summary,
      score: component.score?.value,
      scoreLabel: component.score == null ? '--' : '${component.score!.value}',
    );
  }

  String _updatedLabel(Duration diff) {
    final strings = StatusMonitorL10nResolver.fallback;
    if (diff.inSeconds < 45) return strings.widgetUpdatedJustNow;
    if (diff.inMinutes < 60) {
      return strings.widgetUpdatedMinutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return strings.widgetUpdatedHoursAgo(diff.inHours);
    }
    return strings.widgetUpdatedDaysAgo(diff.inDays);
  }

  String _freshnessLabel(Duration diff) {
    if (diff.inSeconds < 45) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

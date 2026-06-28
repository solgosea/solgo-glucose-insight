import '../../domain/component_health.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../l10n/generated/status_monitor_localizations.dart';

String statusReportComponentTitle(
  StatusComponentKind kind,
  StatusMonitorLocalizations strings,
) {
  return switch (kind) {
    StatusComponentKind.cgmSensor => strings.pageComponentCgmSensor,
    StatusComponentKind.juggluco => 'Juggluco',
    StatusComponentKind.xdrip => strings.pageComponentXdrip,
    StatusComponentKind.nightscout => strings.pageComponentNightscout,
    StatusComponentKind.aapsLoop => strings.pageComponentAapsLoop,
    StatusComponentKind.watchDisplay => 'Watch display',
  };
}

String statusReportComponentRole(
  StatusComponentKind kind,
  StatusMonitorLocalizations strings,
) {
  return switch (kind) {
    StatusComponentKind.cgmSensor => strings.pageModeReadingsQuality,
    StatusComponentKind.juggluco => 'Primary broadcast path',
    StatusComponentKind.xdrip => strings.pageModeLocalService,
    StatusComponentKind.nightscout => strings.pageModeNightscoutApi,
    StatusComponentKind.aapsLoop => strings.pageModeNightscoutEvidence,
    StatusComponentKind.watchDisplay => 'Display bridge',
  };
}

String statusReportComponentTakeaway(
  ComponentHealth component,
  StatusMonitorLocalizations strings,
) {
  final title = statusReportComponentTitle(component.kind, strings);
  return switch (component.level) {
    StatusLevel.healthy => strings.reportNoMajorStatusIssueBody,
    StatusLevel.watch ||
    StatusLevel.issue =>
      strings.reportComponentStrongestIssueTakeaway(title),
    StatusLevel.unknown => strings.reportNoShareableEvidence,
  };
}

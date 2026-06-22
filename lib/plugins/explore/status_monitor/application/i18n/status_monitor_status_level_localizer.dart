import '../../domain/status_level.dart';
import '../../l10n/generated/status_monitor_localizations.dart';

String statusMonitorLevelLabel(
  StatusLevel level,
  StatusMonitorLocalizations l10n,
) {
  return switch (level) {
    StatusLevel.healthy => l10n.pageStatusHealthy,
    StatusLevel.watch => l10n.pageStatusWatch,
    StatusLevel.issue => l10n.pageStatusIssue,
    StatusLevel.unknown => l10n.pageStatusUnknown,
  };
}

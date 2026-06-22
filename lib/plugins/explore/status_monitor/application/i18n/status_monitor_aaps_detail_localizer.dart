import '../../l10n/generated/status_monitor_localizations.dart';
import 'status_monitor_age_label_localizer.dart';

String statusMonitorAapsLabel(
  String value,
  StatusMonitorLocalizations l10n,
) {
  return switch (value) {
    'Loop context' => l10n.metricLoopContext,
    'Pump context' => l10n.metricPumpContext,
    'IOB context' => l10n.metricIobContext,
    'COB context' => l10n.metricCobContext,
    'Profile / temp target' => l10n.metricProfileTempTarget,
    'Nightscout' => 'Nightscout',
    'AAPS sync' => l10n.pageAapsSync,
    'Pump' => l10n.pagePump,
    'IOB/COB' => 'IOB/COB',
    'Profile' => l10n.pageProfile,
    'Nightscout API' => 'Nightscout API',
    'openaps context' => l10n.pageOpenapsContext,
    'pump context' => l10n.metricPumpContext,
    'profile context' => l10n.metricProfileContext,
    _ => value,
  };
}

String statusMonitorAapsBody(
  String value,
  StatusMonitorLocalizations l10n,
) {
  return switch (value) {
    'OpenAPS context is not visible.' => l10n.pageOpenapsContextNotVisible,
    'Pump context is not visible in Nightscout.' =>
      l10n.pagePumpContextNotVisibleNightscout,
    'IOB context is not visible.' => l10n.pageIobContextNotVisible,
    'COB context is not visible.' => l10n.pageCobContextNotVisible,
    'Profile or temp target context is not visible.' =>
      l10n.pageProfileTempTargetNotVisible,
    'Reachable. Device status endpoint returned evidence.' =>
      l10n.pageNightscoutApiReachableEvidence,
    'Nightscout is configured but current evidence is unavailable.' =>
      l10n.pageNightscoutConfiguredEvidenceUnavailable,
    'No Nightscout target is configured.' =>
      l10n.pageNoNightscoutTargetConfigured,
    'No OpenAPS loop context is visible in sampled device status.' =>
      l10n.pageNoOpenapsLoopContextVisible,
    'No recent profile or temp target context in the sampled response.' =>
      l10n.pageNoRecentProfileTempTargetContext,
    _ => value,
  };
}

String statusMonitorAapsValue(
  String value,
  StatusMonitorLocalizations l10n,
) {
  final ageLocalizer = const StatusMonitorAgeLabelLocalizer();
  if (ageLocalizer.parse(value) != null) {
    return ageLocalizer.localize(value, l10n);
  }
  return switch (value) {
    'Unknown' => l10n.pageStatusUnknown,
    'Healthy' => l10n.pageStatusHealthy,
    'Watch' => l10n.pageStatusWatch,
    'Issue' => l10n.pageStatusIssue,
    'Partial' => l10n.pagePartial,
    'Visible' => l10n.pageVisible,
    'Fresh' => l10n.pageFresh,
    'Missing' => l10n.pageMissing,
    'No AAPS context' => l10n.pageNoAapsContext,
    _ => value,
  };
}

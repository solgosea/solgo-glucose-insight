import '../../l10n/generated/status_monitor_localizations.dart';

String statusMonitorMetricLabel(
  String label,
  StatusMonitorLocalizations l10n,
) {
  final text = label.trim();
  final readingsMatch = RegExp(r'^(\d+)\s+readings$').firstMatch(text);
  if (readingsMatch != null) {
    final count = int.tryParse(readingsMatch.group(1) ?? '');
    if (count != null) return l10n.metricReadingsCount(count);
  }
  return switch (text) {
    '24h completeness' => l10n.pageCompleteness24h,
    'Access token' => l10n.metricAccessToken,
    'API reachable' => l10n.metricApiReachable,
    'AAPS sync' => l10n.pageAapsSync,
    'COB context' => l10n.metricCobContext,
    'Collector context' => l10n.metricCollectorContext,
    'CV (24h)' => l10n.metricCv24h,
    'Device status' => l10n.metricDeviceStatus,
    'devicestatus' => l10n.metricDevicestatus,
    'Entries endpoint' => l10n.metricEntriesEndpoint,
    'entries' => l10n.metricEntriesEndpoint,
    'Flat-line periods' => l10n.metricFlatLinePeriods,
    'Fresh' => l10n.pageFresh,
    'Healthy' => l10n.pageStatusHealthy,
    'IOB / COB context' => l10n.metricIobCobContext,
    'IOB context' => l10n.metricIobContext,
    'Last reading freshness' => l10n.metricLastReadingFreshness,
    'Latest AAPS context' => l10n.metricLatestAapsContext,
    'Latest server reading' => l10n.metricLatestServerReading,
    'Local service' => l10n.metricLocalService,
    'local service' => l10n.metricLocalService,
    'Loop context' => l10n.metricLoopContext,
    'Missing' => l10n.pageMissing,
    'Nightscout evidence' => l10n.metricNightscoutEvidence,
    'No readings' => l10n.metricNoReadings,
    'Partial' => l10n.pagePartial,
    'P95 upload latency' => l10n.metricP95UploadLatency,
    'Profile' => l10n.pageProfile,
    'Profile / temp target' => l10n.metricProfileTempTarget,
    'Profile context' => l10n.metricProfileContext,
    'Pump context' => l10n.metricPumpContext,
    'Pump' => l10n.pagePump,
    'Response time' => l10n.metricResponseTime,
    'Sensor context' => l10n.metricSensorContext,
    'Sensor data freshness' => l10n.metricSensorDataFreshness,
    'Sensor lifetime' => l10n.metricSensorLifetime,
    'Sensor/collector context' => l10n.metricSensorCollectorContext,
    'Signal continuity' => l10n.metricSignalContinuity,
    'Status endpoint' => l10n.metricStatusEndpoint,
    'status.json' => 'status.json',
    'Sudden changes (24h)' => l10n.metricSuddenChanges24h,
    'Uploader battery' => l10n.metricUploaderBattery,
    'Unknown' => l10n.pageStatusUnknown,
    'Version context' => l10n.metricVersionContext,
    'Visible' => l10n.pageVisible,
    'Watch' => l10n.pageStatusWatch,
    'Issue' => l10n.pageStatusIssue,
    _ => label,
  };
}

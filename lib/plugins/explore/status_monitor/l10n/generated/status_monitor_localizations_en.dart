// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'status_monitor_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StatusMonitorLocalizationsEn extends StatusMonitorLocalizations {
  StatusMonitorLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Status Monitor';

  @override
  String get pluginSubtitle =>
      'Privacy-safe source, sync, and support diagnostics.';

  @override
  String get pluginDescription =>
      'Privacy-safe source, sync, and support diagnostics.';

  @override
  String get pluginExploreSection => 'SYSTEM STATUS';

  @override
  String get pluginReportTitle => 'Status Monitor Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get reportSupportTitle => 'Status Monitor Support Report';

  @override
  String get reportTitle => 'Status Monitor';

  @override
  String get reportEyebrow => 'Privacy-safe community support report';

  @override
  String get reportSummary =>
      'A shareable evidence report for troubleshooting the CGM data chain. It highlights what to inspect first, compares local and cloud freshness, and hides private URLs, credentials, subject identifiers, and exact server addresses.';

  @override
  String get reportDetails => 'Report details';

  @override
  String get reportSupportTriage => 'Support triage';

  @override
  String get reportLocalCloudFreshness => 'Local vs cloud freshness';

  @override
  String get reportDataChainSnapshot => 'Data chain snapshot';

  @override
  String get reportComponentEvidence => 'Component evidence';

  @override
  String get reportFreshnessCompleteness => 'Freshness and completeness';

  @override
  String get reportSourceCapabilities => 'Source capabilities';

  @override
  String get reportTechnicalEvidence => 'Technical evidence';

  @override
  String get reportSuggestedFirstLook => 'Suggested place to look first';

  @override
  String get reportPrivacyLabel => 'URLs, credentials, subject id hidden';

  @override
  String get reportDisclaimer =>
      'Privacy-safe report. Generated on device and shared only when the user chooses. URLs, credentials, subject identifiers, and exact server addresses are hidden. This report shows observable checks only; it is not a diagnosis tool, an alarm system, or medical advice.';

  @override
  String reportWindowLiveProbe(Object time) {
    return 'Last 24 hours, live probe $time';
  }

  @override
  String get reportPrint => 'Print';

  @override
  String get reportShare => 'Share';

  @override
  String get reportCouldNotExport => 'Could not export report';

  @override
  String get reportCouldNotBuildPreview => 'Could not build report preview';

  @override
  String get reportTryAgain => 'Try again';

  @override
  String get reportHeaderBrand => 'Solgo Insight';

  @override
  String get reportComponentColumn => 'COMPONENT';

  @override
  String get reportStatusColumn => 'STATUS';

  @override
  String get reportTakeawayColumn => 'TAKEAWAY';

  @override
  String get reportChecksColumn => 'CHECKS';

  @override
  String get reportUsefulEvidenceColumn => 'USEFUL EVIDENCE';

  @override
  String get reportMatchesComponents => 'matches StatusReport components';

  @override
  String get reportSafeToShare => 'safe to share';

  @override
  String get reportLast24h => 'last 24h';

  @override
  String get reportSourceMode => 'Source mode';

  @override
  String get reportGenerated => 'Generated';

  @override
  String get reportPrivacy => 'Privacy';

  @override
  String get reportWindow => 'Window';

  @override
  String get reportSuggestedFirstLookLabel => 'Suggested first look';

  @override
  String get reportLocalReading => 'Local reading';

  @override
  String get reportCloudReading => 'Cloud reading';

  @override
  String get reportAapsContext => 'AAPS context';

  @override
  String get reportLocalActiveStream => 'Local / active stream';

  @override
  String get reportNightscoutCloud => 'Nightscout cloud';

  @override
  String get reportLatestVisibleReading => 'latest visible reading';

  @override
  String get reportLatestServerReading => 'latest server reading';

  @override
  String get reportModeLabel => 'Mode label';

  @override
  String get reportAvailable => 'available';

  @override
  String get reportNotExposed => 'not exposed';

  @override
  String get reportFastTriage => 'fast triage';

  @override
  String get reportLatestLocalReading => 'Latest local reading';

  @override
  String get reportLatestNightscoutReading => 'Latest Nightscout reading';

  @override
  String get reportXdripLocalResponse => 'xDrip+ Local response';

  @override
  String get reportNightscoutResponse => 'Nightscout response';

  @override
  String get reportCompleteness24h => '24h completeness';

  @override
  String get reportLargestVisibleGap => 'Largest visible gap';

  @override
  String get reportAapsEvidence => 'AAPS evidence';

  @override
  String get reportUnknown => 'Unknown';

  @override
  String get reportNoShareableEvidence => 'No shareable evidence is available.';

  @override
  String get reportNoEvidence => 'No evidence';

  @override
  String get reportConfigureCgmSource => 'Start by configuring a CGM source.';

  @override
  String get reportConfigureCgmSourceBody =>
      'Status Monitor needs xDrip+ Local or Nightscout evidence before it can produce a useful support report.';

  @override
  String get reportConfigureCgmSourceTakeaway =>
      'No configured source is visible yet, so the first step is to connect xDrip+ Local or Nightscout.';

  @override
  String reportStartWithPath(Object path) {
    return 'Start with the $path.';
  }

  @override
  String get reportLocalFresherThanCloudBody =>
      'Local xDrip+ evidence looks fresher than the Nightscout stream. Check whether uploads are queued, blocked, rate-limited, or delayed by the Nightscout server or network.';

  @override
  String reportLocalFresherThanCloudTakeaway(Object path) {
    return 'Local readings look fresher than Nightscout, so the most useful first check is the $path.';
  }

  @override
  String reportStartWithComponent(Object component) {
    return 'Start with $component.';
  }

  @override
  String reportComponentStrongestIssueTakeaway(Object component) {
    return '$component has the strongest visible issue, so inspect the local acquisition path before cloud or loop context.';
  }

  @override
  String get reportStartWithNightscout => 'Start with Nightscout.';

  @override
  String get reportNightscoutFirstTakeaway =>
      'Nightscout is the most visible watch/issue component, so inspect the cloud server or upload path first.';

  @override
  String get reportAapsContextLimited =>
      'AAPS context is limited, not necessarily broken.';

  @override
  String get reportAapsContextLimitedBody =>
      'The CGM data chain has enough healthy evidence, but current loop context is not visible through the configured source.';

  @override
  String get reportAapsContextLimitedTakeaway =>
      'The glucose data chain looks usable; AAPS context is limited in the available source.';

  @override
  String reportAffectedComponentsTakeaway(
      Object affected, Object verb, Object component) {
    return '$affected $verb showing watch/issue evidence. Start with $component, then use the component evidence table to compare the visible checks.';
  }

  @override
  String get reportAndOthers => 'and others';

  @override
  String get reportUploadServerDelayPath => 'upload/server delay';

  @override
  String get reportCloudApiPath => 'cloud/API path';

  @override
  String reportComponentPair(Object first, Object second) {
    return '$first and $second';
  }

  @override
  String reportComponentPairAndOthers(
      Object first, Object second, Object others) {
    return '$first and $second $others';
  }

  @override
  String get reportVerbIs => 'is';

  @override
  String get reportVerbAre => 'are';

  @override
  String get reportNoMajorStatusIssue => 'No major status issue is visible.';

  @override
  String get reportNoMajorStatusIssueBody =>
      'Visible checks are currently in the healthy range. Keep this report as supporting context if the issue is intermittent.';

  @override
  String reportIssuePhraseIssue(Object component) {
    return '$component is in Issue';
  }

  @override
  String reportIssuePhraseWatch(Object component) {
    return '$component is in Watch';
  }

  @override
  String get reportNoDataSourceConfigured => 'No data source is configured';

  @override
  String get reportCurrentIssue => 'Current issue';

  @override
  String get reportSourceModeCommunity => 'Source mode';

  @override
  String get reportPrivacyCommunity =>
      'Privacy: URL/credentials/subject id hidden';

  @override
  String get reportCommunityQuestion =>
      'Question: which part of the CGM data chain should I inspect first?';

  @override
  String reportEvidenceScoreBody(
      Object available, Object components, Object passed, Object total) {
    return '$available of $components components have enough evidence. $passed of $total checks passed.';
  }

  @override
  String get reportEvidenceScoreTitle => 'Evidence score';

  @override
  String get reportCopyCommunityPost => 'Copy for community post';

  @override
  String get reportPrivacySafe => 'Privacy-safe';

  @override
  String get reportObservedFacts => 'Observed facts';

  @override
  String get reportLimitsOfReport => 'Limits of this report';

  @override
  String get reportTimelineCurrent => 'current';

  @override
  String get reportTimelinePartial => 'partial';

  @override
  String get reportTimelineGap => 'gap';

  @override
  String reportProbeNotVisible(Object label) {
    return '$label is not visible in this report.';
  }

  @override
  String reportProbeIsValue(Object label, Object value) {
    return '$label is $value.';
  }

  @override
  String get reportLoopContextNotVisible =>
      'Loop context is not visible through the configured source.';

  @override
  String reportLoopContextEvidence(Object value) {
    return 'Loop context evidence is $value; do not treat this as a loop decision evaluation.';
  }

  @override
  String get reportLocalFreshnessNotVisible =>
      'Local or active-stream freshness is not visible. Inspect the configured source path before assuming cloud delay.';

  @override
  String get reportXdripResponseIncomplete =>
      'Glucose data is visible, but direct xDrip+ Local response evidence is incomplete.';

  @override
  String get reportActiveSourceVisible =>
      'Glucose data is visible through the active source path.';

  @override
  String get reportNightscoutFreshnessNotVisible =>
      'Nightscout reading freshness is not visible in this report.';

  @override
  String get reportCloudEntriesBehind =>
      'Cloud entries are behind the active stream. Inspect upload, server, or network delay.';

  @override
  String get reportCloudEntriesCurrent =>
      'Cloud entries are current. If local xDrip+ is expected, inspect local service exposure first.';

  @override
  String get reportFirstInspectionPathTitle =>
      'Treat this as a first inspection path, not proof.';

  @override
  String get reportFirstInspectionPathBody =>
      'The report points to observable evidence. It does not prove the root cause or replace CGM alerts.';

  @override
  String get reportNoShareableStatusEvidenceVisible =>
      'No shareable status evidence is visible.';

  @override
  String get reportEvidenceLimitCloud =>
      'This report cannot prove CGM manufacturer cloud, Dexcom Share, pump radio, or phone OS behavior.';

  @override
  String get reportEvidenceLimitDeviceLabels =>
      'Nightscout device labels are clues, not device truth.';

  @override
  String get reportEvidenceLimitAaps =>
      'AAPS context depends on what is visible through the configured source.';

  @override
  String get reportEvidenceLimitNotAlarm =>
      'This report is not an alarm or diagnosis tool.';

  @override
  String get pageEyebrowStatusMonitor => 'Status monitor';

  @override
  String get pageHistoryTitle => 'Status History';

  @override
  String get pageLowBatterySubtitle =>
      'Reduces status refresh frequency to save power.';

  @override
  String get pageFloatingStatusBar => 'Floating status bar';

  @override
  String get pageDashboardSubtitle => 'CGM Sensor · xDrip+ · Nightscout';

  @override
  String get pageShowNotificationSubtitle =>
      'Silent, low-priority status monitor notification.';

  @override
  String get pageEyebrowLiveStatus => 'Live status';

  @override
  String get pageShowNotificationTitle => 'Show in notification bar';

  @override
  String get pageLockScreenStatus => 'Lock screen status';

  @override
  String get pageReportTooltip => 'Report';

  @override
  String get pageHistorySubtitle => '7-day component status';

  @override
  String get pageWidgetsSubtitle =>
      'Home screen and persistent status surfaces';

  @override
  String get pageStatusNotification => 'Status notification';

  @override
  String get pageLowBatteryTitle => 'Low-battery friendly mode';

  @override
  String get pageWidgetsTitle => 'Widgets & Notifications';

  @override
  String get pageWidgetTemplates => 'Widget templates';

  @override
  String get pageAddToHomeScreen => 'Add to home screen';

  @override
  String get pageComponents => 'Components';

  @override
  String get pageRefreshNow => 'Refresh now';

  @override
  String get pageAapsIobCobProfile => 'IOB / COB / profile';

  @override
  String get pageContextVisibility => 'Context visibility';

  @override
  String get pageProfileTempTarget => 'Profile / temp target';

  @override
  String get pageSourceNightscoutDeviceStatus =>
      'source: Nightscout device status';

  @override
  String get pageNoLocalAapsRestAssumed => 'no local AAPS REST assumed';

  @override
  String get pageMissingFieldsReduceConfidence =>
      'missing fields reduce confidence';

  @override
  String get pagePumpLoopContext => 'Pump and loop context';

  @override
  String get pageFactualChecksOnly => 'Factual checks only';

  @override
  String get pageStatusHealthy => 'Healthy';

  @override
  String get pageStatusWatch => 'Watch';

  @override
  String get pageStatusIssue => 'Issue';

  @override
  String get pageStatusUnknown => 'Unknown';

  @override
  String get pageStatusAvailable => 'Available';

  @override
  String get pageStatusHistory => 'History';

  @override
  String get pageStatusMixed => 'Mixed';

  @override
  String get pageStatusLive => 'Live';

  @override
  String get pageLatestProbe => 'Latest probe';

  @override
  String get pageLast3h => 'Last 3h';

  @override
  String get pageLast30m => 'Last 30m';

  @override
  String get pageNow => 'now';

  @override
  String get pageThreeHoursAgo => '3h ago';

  @override
  String get pageFresh => 'Fresh';

  @override
  String get pageStalePartial => 'Stale/partial';

  @override
  String get pageMissing => 'Missing';

  @override
  String get pageEvidenceMatrix => 'Evidence matrix';

  @override
  String get pageLoopEvidenceTimeline => 'Loop evidence timeline';

  @override
  String pageLatestContext(Object context) {
    return 'Latest $context';
  }

  @override
  String get pageNightscoutDeviceStatus => 'Nightscout device status';

  @override
  String get pageOpenapsContext => 'OpenAPS context';

  @override
  String get pageEndpointMatrix => 'Endpoint matrix';

  @override
  String get pageReachable => 'reachable';

  @override
  String get pageNotReachable => 'not reachable';

  @override
  String get pageCheckedRecently => 'checked recently';

  @override
  String get pageResponseTimeline => 'Response timeline';

  @override
  String get pageNoResponseSamples =>
      'No response samples yet. Open this page after the next refresh to build the timeline.';

  @override
  String pageMedianMs(Object ms) {
    return 'Median ${ms}ms';
  }

  @override
  String pageTimeouts(Object count) {
    return '$count timeouts';
  }

  @override
  String get dashboardWaitingForSource => 'Waiting for source';

  @override
  String get dashboardTemporarilyUnavailable =>
      'Status temporarily unavailable';

  @override
  String get dashboardRefreshFailedBody =>
      'SolgoInsight could not refresh this status view. Please try again or check your data source settings.';

  @override
  String get dashboardCheckingStatus => 'Checking status';

  @override
  String get dashboardPreparingLatest =>
      'SolgoInsight is preparing the latest dashboard state.';

  @override
  String get dashboardWaitingTakeaway =>
      'Waiting for a configured data source.';

  @override
  String get dashboardNoSourceSummary =>
      'No source configured for this subject.';

  @override
  String get dashboardSourceLabel => 'Source';

  @override
  String get dashboardNotConfigured => 'Not configured';

  @override
  String get dashboardNoSource => 'No source';

  @override
  String get dashboardNeedsSourceHeadline =>
      'Status needs a configured data source.';

  @override
  String get dashboardNeedsSourceBody =>
      'Connect Nightscout or xDrip+ Local to read CGM, uploader, and server status.';

  @override
  String get dashboardNeedsSourceMeta =>
      'No data source - status is not evaluated yet';

  @override
  String get dashboardNeedsSourceEmptyReason =>
      'Set up a data source in Profile to monitor CGM, uploader, and server status.';

  @override
  String get notificationChannelTitle => 'Status Monitor';

  @override
  String get notificationChannelDescription =>
      'Silent status monitor notification.';

  @override
  String get pageNoRecentTimeouts => 'No timeouts visible in recent probes';

  @override
  String get pageRecentTimeoutsVisible =>
      'Timeouts were visible in recent probes';

  @override
  String get pageSensorContext => 'Sensor context';

  @override
  String get pageOptionalSourceData => 'Optional source data';

  @override
  String get pageSessionAgeRemaining => 'Session age / remaining';

  @override
  String get pageCollectorContext => 'Collector context';

  @override
  String get pageCollectorHealthyCopy =>
      'No source-side collector warning was available during the last probe.';

  @override
  String get pageReadingSource => 'Reading source';

  @override
  String pageReadingSourceCopy(Object source) {
    return 'Recent readings came from $source, then fed into the CGM Sensor engine.';
  }

  @override
  String get pageSensorNotice =>
      'SolgoInsight shows observable sensor-data quality. It does not replace xDrip+ sensor handling, calibration, primary alerts, or clinical judgment.';

  @override
  String get pageLast24h => 'Last 24h';

  @override
  String get pageContinuous => 'continuous';

  @override
  String get pageSparse => 'sparse';

  @override
  String get pageGap => 'gap';

  @override
  String get pageUnknownLower => 'unknown';

  @override
  String pageLatestAge(Object age) {
    return 'Latest $age';
  }

  @override
  String get pageNoVisibleGap => 'No visible gap';

  @override
  String pageGapBuckets(Object count) {
    return '$count gap buckets';
  }

  @override
  String get pageSensorQualityTimeline => 'Sensor quality timeline';

  @override
  String get pageSuddenJumps => 'Sudden jumps';

  @override
  String pageMajorJumps(Object count) {
    return '$count major jumps';
  }

  @override
  String get pageQuietBaseline => 'quiet baseline';

  @override
  String get pageWatchJump => 'watch jump';

  @override
  String get pageIssueJump => 'issue jump';

  @override
  String get pageNoAbruptSensorJumps => 'No abrupt sensor jumps';

  @override
  String pageLargestJump(Object value) {
    return 'Largest jump $value mmol/L';
  }

  @override
  String get pageAdjacentReadingsOnly =>
      'Adjacent readings only | gap must be 10m or less';

  @override
  String get pageFlatPeriods => 'Flat periods';

  @override
  String pageLongestMinutes(Object minutes) {
    return 'Longest ${minutes}m';
  }

  @override
  String get pageWatch30m => '30m watch';

  @override
  String get pageIssue60m => '60m issue';

  @override
  String get pageFlatThresholdReached => 'Flat period threshold reached';

  @override
  String get pageNo30mFlatPeriod => 'No 30m flat period';

  @override
  String get pageFlatContextNote =>
      'Flat periods are context, not a root-cause label.';

  @override
  String get pageVariabilityNoise => 'Variability and noise';

  @override
  String get pageReadings24h => '24h readings';

  @override
  String get pageCvNoise => 'CV / noise';

  @override
  String get pageContinuity => 'Continuity';

  @override
  String get pageCvWatchBody =>
      'Watch range below 36%. This is variability context, not a diagnosis.';

  @override
  String get pageObservedCadenceBody =>
      'Observed readings compared with expected 5 minute cadence.';

  @override
  String pageCadenceFreshnessBody(Object age) {
    return 'Cadence plus latest sensor freshness ($age).';
  }

  @override
  String get pageServerDataFreshness => 'Server data freshness';

  @override
  String get pageFromEntriesEndpoint => 'From entries endpoint';

  @override
  String get pageLatestServerReading => 'Latest server reading';

  @override
  String get pageAvailableEndpoints => 'Available endpoints';

  @override
  String get pageMeasuredLatestEntry =>
      'Measured from the latest entry returned by Nightscout.';

  @override
  String get pageRecentNightscoutEndpoints =>
      'Recent Nightscout endpoints parsed from API probes.';

  @override
  String get pageDataFreshnessTimeline => 'Data freshness timeline';

  @override
  String get pageHealthyCadence => 'healthy cadence';

  @override
  String get pageDelayed => 'delayed';

  @override
  String get pageCompleteness24h => '24h completeness';

  @override
  String pageExpectedReadings(Object observed, Object expected) {
    return '$observed / $expected expected';
  }

  @override
  String pageCoveragePercent(Object percent) {
    return '$percent% coverage';
  }

  @override
  String get pageExpectedFiveMinuteCadence => 'Expected 5 minute cadence';

  @override
  String get pageServiceAndBattery => 'Service and battery';

  @override
  String get pageLocalService => 'Local service';

  @override
  String get pageXdripLocalModeNote =>
      '/status.json available only in xDrip+ local mode';

  @override
  String get pageUploaderBattery => 'Uploader battery';

  @override
  String get pageBatteryPebbleNote => 'Battery signal from /pebble endpoint';

  @override
  String get pageSensorCollectorContext => 'Sensor and collector context';

  @override
  String get pageOptionalChecks => 'Optional checks';

  @override
  String get pageUploadLatency => 'Upload latency';

  @override
  String get pageUploadLatencyUnavailable =>
      'Unavailable in local mode because server receipt timestamps are not present.';

  @override
  String get pageObservedActiveXdripSource =>
      'Observed from active xDrip+ source context.';

  @override
  String get pageDetectedNightscoutMarkers => 'Detected Nightscout markers';

  @override
  String get pageMarkerEvidenceNote => 'Evidence, not device truth';

  @override
  String get pageCapabilityContext => 'Capability context';

  @override
  String get pageWhatSiteExposes => 'What this site exposes';

  @override
  String get pageObservedNightscoutApiProbes =>
      'Observed from Nightscout API probes.';

  @override
  String get pageFloatingPermissionReady => 'Floating permission is ready.';

  @override
  String get pageEnableFloatingPermission => 'Enable floating permission';

  @override
  String get pageSevenDayHistory => '7-Day History';

  @override
  String get pageSevenDayHistorySubtitle =>
      'Each row is one day - 24 cells per row, one per hour - Unknown means not enough recorded status samples to judge';

  @override
  String get pageToday => 'Today';

  @override
  String get pageMonthJan => 'Jan';

  @override
  String get pageMonthFeb => 'Feb';

  @override
  String get pageMonthMar => 'Mar';

  @override
  String get pageMonthApr => 'Apr';

  @override
  String get pageMonthMay => 'May';

  @override
  String get pageMonthJun => 'Jun';

  @override
  String get pageMonthJul => 'Jul';

  @override
  String get pageMonthAug => 'Aug';

  @override
  String get pageMonthSep => 'Sep';

  @override
  String get pageMonthOct => 'Oct';

  @override
  String get pageMonthNov => 'Nov';

  @override
  String get pageMonthDec => 'Dec';

  @override
  String get pageXdripSignalMissingReason =>
      'This xDrip+ signal was not included in the latest report';

  @override
  String get pageConnectNightscout => 'Connect Nightscout';

  @override
  String get pageSetupSourceBody =>
      'Set up a data source in Profile to monitor CGM, uploader, and server status for this subject.';

  @override
  String get pageSetUp => 'Set up';

  @override
  String get reportCapabilityEntries => 'Entries';

  @override
  String get reportCapabilityRangeQuery => 'Range query';

  @override
  String get reportCapabilityPebble => 'Pebble';

  @override
  String get reportCapabilityUploaderBattery => 'Uploader battery';

  @override
  String get reportCapabilityDeviceStatus => 'Device status';

  @override
  String get reportCapabilityNightscoutStatus => 'Nightscout status';

  @override
  String get reportCapabilityUploadLatency => 'Upload latency';

  @override
  String get reportConfiguredSource => 'Configured source';

  @override
  String reportChecksPassed(Object passed, Object total) {
    return '$passed/$total passed';
  }

  @override
  String reportMeetsExpected(Object value, Object expected) {
    return '$value (meets $expected expected)';
  }

  @override
  String reportObservedExpected(
      Object value, Object observed, Object expected) {
    return '$value ($observed/$expected expected)';
  }

  @override
  String reportGapsOver15m(Object value, Object count) {
    return '$value, $count gaps >15m';
  }

  @override
  String get widgetStatus => 'Status';

  @override
  String get widgetStatusUnavailable => 'Status unavailable';

  @override
  String get widgetNoRecentStatus => 'No recent status';

  @override
  String get widgetConnectSourceSummary =>
      'Connect a Nightscout source to monitor CGM, uploader, and server status.';

  @override
  String get widgetOpenToRefresh =>
      'Open SolgoInsight to refresh the latest status snapshot.';

  @override
  String get widgetStatusAvailable => 'Status available';

  @override
  String get widgetAllSystemsHealthy => 'All systems healthy';

  @override
  String widgetWatchStatus(Object component) {
    return 'Watch $component';
  }

  @override
  String widgetComponentIssue(Object component) {
    return '$component issue';
  }

  @override
  String get widgetUpdatedJustNow => 'Updated just now';

  @override
  String widgetUpdatedMinutesAgo(Object minutes) {
    return 'Updated $minutes min ago';
  }

  @override
  String widgetUpdatedHoursAgo(Object hours) {
    return 'Updated ${hours}h ago';
  }

  @override
  String widgetUpdatedDaysAgo(Object days) {
    return 'Updated ${days}d ago';
  }

  @override
  String get metricAccessToken => 'Access token';

  @override
  String get metricApiReachable => 'API reachable';

  @override
  String get metricCobContext => 'COB context';

  @override
  String get metricCollectorContext => 'Collector context';

  @override
  String get metricCv24h => 'CV (24h)';

  @override
  String get metricDeviceStatus => 'Device status';

  @override
  String get metricDevicestatus => 'devicestatus';

  @override
  String get metricEntriesEndpoint => 'Entries endpoint';

  @override
  String get metricFlatLinePeriods => 'Flat-line periods';

  @override
  String get metricIobCobContext => 'IOB / COB context';

  @override
  String get metricIobContext => 'IOB context';

  @override
  String get metricLastReadingFreshness => 'Last reading freshness';

  @override
  String get metricLatestAapsContext => 'Latest AAPS context';

  @override
  String get metricLatestServerReading => 'Latest server reading';

  @override
  String get metricLocalService => 'Local service';

  @override
  String get metricLoopContext => 'Loop context';

  @override
  String get metricNightscoutEvidence => 'Nightscout evidence';

  @override
  String get metricNoReadings => 'No readings';

  @override
  String get metricP95UploadLatency => 'P95 upload latency';

  @override
  String get metricProfileTempTarget => 'Profile / temp target';

  @override
  String get metricProfileContext => 'Profile context';

  @override
  String get metricPumpContext => 'Pump context';

  @override
  String get metricResponseTime => 'Response time';

  @override
  String get metricSensorContext => 'Sensor context';

  @override
  String get metricSensorDataFreshness => 'Sensor data freshness';

  @override
  String get metricSensorLifetime => 'Sensor lifetime';

  @override
  String get metricSensorCollectorContext => 'Sensor/collector context';

  @override
  String get metricSignalContinuity => 'Signal continuity';

  @override
  String get metricStatusEndpoint => 'Status endpoint';

  @override
  String get metricSuddenChanges24h => 'Sudden changes (24h)';

  @override
  String get metricUploaderBattery => 'Uploader battery';

  @override
  String get metricVersionContext => 'Version context';

  @override
  String metricReadingsCount(Object count) {
    return '$count readings';
  }

  @override
  String get metricNotAvailable => 'Not available';

  @override
  String get pageAapsSync => 'AAPS sync';

  @override
  String get pagePump => 'Pump';

  @override
  String get pageProfile => 'Profile';

  @override
  String get pageNoAapsContext => 'No AAPS context';

  @override
  String get pageJustNow => 'just now';

  @override
  String pageMinutesAgoShort(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String pageHoursAgoShort(Object hours) {
    return '${hours}h ago';
  }

  @override
  String pageDaysAgoShort(Object days) {
    return '${days}d ago';
  }

  @override
  String get pageOpenapsContextNotVisible => 'OpenAPS context is not visible.';

  @override
  String get pagePumpContextNotVisibleNightscout =>
      'Pump context is not visible in Nightscout.';

  @override
  String get pageIobContextNotVisible => 'IOB context is not visible.';

  @override
  String get pageCobContextNotVisible => 'COB context is not visible.';

  @override
  String get pageProfileTempTargetNotVisible =>
      'Profile or temp target context is not visible.';

  @override
  String get pageNightscoutApiReachableEvidence =>
      'Reachable. Device status endpoint returned evidence.';

  @override
  String get pageNightscoutConfiguredEvidenceUnavailable =>
      'Nightscout is configured but current evidence is unavailable.';

  @override
  String get pageNoNightscoutTargetConfigured =>
      'No Nightscout target is configured.';

  @override
  String get pageNoOpenapsLoopContextVisible =>
      'No OpenAPS loop context is visible in sampled device status.';

  @override
  String get pageNoRecentProfileTempTargetContext =>
      'No recent profile or temp target context in the sampled response.';

  @override
  String get pagePartial => 'Partial';

  @override
  String get pageVisible => 'Visible';

  @override
  String get pageNoTimelineData => 'No timeline data';

  @override
  String pageLatestTimelineLabel(Object label) {
    return 'Latest $label';
  }

  @override
  String get pageNoVisibleIssueCluster => 'No visible issue cluster';

  @override
  String pageIssueBucketsInView(Object count) {
    return '$count issue buckets in view';
  }

  @override
  String get pageOlder => 'Older';

  @override
  String get pageMid => 'Mid';

  @override
  String get pageCurrentReadings => 'Current readings';

  @override
  String get pagePossibleDirections => 'Possible directions';

  @override
  String get pageModeReadingsQuality => 'READINGS QUALITY';

  @override
  String get pageModeLocalService => 'LOCAL SERVICE';

  @override
  String get pageModeNightscoutApi => 'NIGHTSCOUT API';

  @override
  String get pageModeNightscoutEvidence => 'NIGHTSCOUT EVIDENCE';

  @override
  String get pageComponentCgmSensor => 'CGM Sensor';

  @override
  String get pageComponentXdrip => 'xDrip+';

  @override
  String get pageComponentNightscout => 'Nightscout';

  @override
  String get pageComponentAapsLoop => 'AAPS Loop';

  @override
  String get pageLatestSensorReadingObserved =>
      'Latest sensor reading observed';

  @override
  String get pageConfidenceAvailableMetrics =>
      'Confidence based on available metrics';

  @override
  String get pageConfidenceAvailableEndpoints =>
      'Confidence based on available endpoints';

  @override
  String get pageConfidenceAvailableContext =>
      'Confidence based on available context';

  @override
  String get pageConfidenceNightscoutEvidence =>
      'Confidence based on Nightscout evidence';

  @override
  String pageChecksPassedShort(Object available, Object total) {
    return '$available/$total checks passed';
  }

  @override
  String get pageLockScreenDisabled => 'Lock screen disabled';

  @override
  String get pageNotificationLowPriorityNote =>
      'Low-priority status only. No sound, vibration, snooze, or dismiss.';

  @override
  String get pageHowToPlaceWidget => 'How to place a widget';

  @override
  String get pageWidgetStepLongPress =>
      'Long-press any empty area of your home screen';

  @override
  String get pageWidgetStepTapWidgets =>
      'Tap Widgets, then scroll to SolgoInsight Status Monitor';

  @override
  String get pageWidgetStepDragTemplate =>
      'Drag one status template onto the screen';

  @override
  String get pageStatusDataNotReady =>
      'Status data is not ready yet. Open Status Monitor after configuring a data source.';

  @override
  String pageSamplesRecorded(Object percent) {
    return '$percent% samples recorded';
  }

  @override
  String get pageDailySummary7Days => 'Daily summary - 7 days';

  @override
  String get pageHourlyDetail => 'Hourly detail';

  @override
  String get pageHistoryScopeNote =>
      'History is scoped to the current subject and data source. It records component snapshots from Status Monitor refreshes; Unknown means there was not enough recorded sample data for that hour.';

  @override
  String get pageHistoryReasonRecordedSample => 'Recorded sample';

  @override
  String get pageHistoryReasonCarriedForward => 'Carried forward';

  @override
  String get pageHistoryReasonNoSample => 'No sample';

  @override
  String get pageHistoryReasonFuture => 'Future hour';
}

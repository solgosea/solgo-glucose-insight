import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'status_monitor_localizations_en.dart';
import 'status_monitor_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StatusMonitorLocalizations
/// returned by `StatusMonitorLocalizations.of(context)`.
///
/// Applications need to include `StatusMonitorLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/status_monitor_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StatusMonitorLocalizations.localizationsDelegates,
///   supportedLocales: StatusMonitorLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the StatusMonitorLocalizations.supportedLocales
/// property.
abstract class StatusMonitorLocalizations {
  StatusMonitorLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StatusMonitorLocalizations of(BuildContext context) {
    return Localizations.of<StatusMonitorLocalizations>(
        context, StatusMonitorLocalizations)!;
  }

  static const LocalizationsDelegate<StatusMonitorLocalizations> delegate =
      _StatusMonitorLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Monitor'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy-safe source, sync, and support diagnostics.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Privacy-safe source, sync, and support diagnostics.'**
  String get pluginDescription;

  /// No description provided for @pluginExploreSection.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM STATUS'**
  String get pluginExploreSection;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Monitor Report'**
  String get pluginReportTitle;

  /// No description provided for @pluginLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get pluginLoading;

  /// No description provided for @pluginNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available yet.'**
  String get pluginNoData;

  /// No description provided for @pluginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pluginUnavailable;

  /// No description provided for @reportSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Monitor Support Report'**
  String get reportSupportTitle;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Monitor'**
  String get reportTitle;

  /// No description provided for @reportEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Privacy-safe community support report'**
  String get reportEyebrow;

  /// No description provided for @reportSummary.
  ///
  /// In en, this message translates to:
  /// **'A shareable evidence report for troubleshooting the CGM data chain. It highlights what to inspect first, compares local and cloud freshness, and hides private URLs, credentials, subject identifiers, and exact server addresses.'**
  String get reportSummary;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report details'**
  String get reportDetails;

  /// No description provided for @reportSupportTriage.
  ///
  /// In en, this message translates to:
  /// **'Support triage'**
  String get reportSupportTriage;

  /// No description provided for @reportLocalCloudFreshness.
  ///
  /// In en, this message translates to:
  /// **'Local vs cloud freshness'**
  String get reportLocalCloudFreshness;

  /// No description provided for @reportDataChainSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Data chain snapshot'**
  String get reportDataChainSnapshot;

  /// No description provided for @reportComponentEvidence.
  ///
  /// In en, this message translates to:
  /// **'Component evidence'**
  String get reportComponentEvidence;

  /// No description provided for @reportFreshnessCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Freshness and completeness'**
  String get reportFreshnessCompleteness;

  /// No description provided for @reportSourceCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Source capabilities'**
  String get reportSourceCapabilities;

  /// No description provided for @reportTechnicalEvidence.
  ///
  /// In en, this message translates to:
  /// **'Technical evidence'**
  String get reportTechnicalEvidence;

  /// No description provided for @reportSuggestedFirstLook.
  ///
  /// In en, this message translates to:
  /// **'Suggested place to look first'**
  String get reportSuggestedFirstLook;

  /// No description provided for @reportPrivacyLabel.
  ///
  /// In en, this message translates to:
  /// **'URLs, credentials, subject id hidden'**
  String get reportPrivacyLabel;

  /// No description provided for @reportDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Privacy-safe report. Generated on device and shared only when the user chooses. URLs, credentials, subject identifiers, and exact server addresses are hidden. This report shows observable checks only; it is not a diagnosis tool, an alarm system, or medical advice.'**
  String get reportDisclaimer;

  /// No description provided for @reportWindowLiveProbe.
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours, live probe {time}'**
  String reportWindowLiveProbe(Object time);

  /// No description provided for @reportPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get reportPrint;

  /// No description provided for @reportShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get reportShare;

  /// No description provided for @reportCouldNotExport.
  ///
  /// In en, this message translates to:
  /// **'Could not export report'**
  String get reportCouldNotExport;

  /// No description provided for @reportCouldNotBuildPreview.
  ///
  /// In en, this message translates to:
  /// **'Could not build report preview'**
  String get reportCouldNotBuildPreview;

  /// No description provided for @reportTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get reportTryAgain;

  /// No description provided for @reportHeaderBrand.
  ///
  /// In en, this message translates to:
  /// **'Solgo Insight'**
  String get reportHeaderBrand;

  /// No description provided for @reportComponentColumn.
  ///
  /// In en, this message translates to:
  /// **'COMPONENT'**
  String get reportComponentColumn;

  /// No description provided for @reportStatusColumn.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get reportStatusColumn;

  /// No description provided for @reportTakeawayColumn.
  ///
  /// In en, this message translates to:
  /// **'TAKEAWAY'**
  String get reportTakeawayColumn;

  /// No description provided for @reportChecksColumn.
  ///
  /// In en, this message translates to:
  /// **'CHECKS'**
  String get reportChecksColumn;

  /// No description provided for @reportUsefulEvidenceColumn.
  ///
  /// In en, this message translates to:
  /// **'USEFUL EVIDENCE'**
  String get reportUsefulEvidenceColumn;

  /// No description provided for @reportMatchesComponents.
  ///
  /// In en, this message translates to:
  /// **'matches StatusReport components'**
  String get reportMatchesComponents;

  /// No description provided for @reportSafeToShare.
  ///
  /// In en, this message translates to:
  /// **'safe to share'**
  String get reportSafeToShare;

  /// No description provided for @reportLast24h.
  ///
  /// In en, this message translates to:
  /// **'last 24h'**
  String get reportLast24h;

  /// No description provided for @reportSourceMode.
  ///
  /// In en, this message translates to:
  /// **'Source mode'**
  String get reportSourceMode;

  /// No description provided for @reportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get reportGenerated;

  /// No description provided for @reportPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get reportPrivacy;

  /// No description provided for @reportWindow.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get reportWindow;

  /// No description provided for @reportSuggestedFirstLookLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested first look'**
  String get reportSuggestedFirstLookLabel;

  /// No description provided for @reportLocalReading.
  ///
  /// In en, this message translates to:
  /// **'Local reading'**
  String get reportLocalReading;

  /// No description provided for @reportCloudReading.
  ///
  /// In en, this message translates to:
  /// **'Cloud reading'**
  String get reportCloudReading;

  /// No description provided for @reportAapsContext.
  ///
  /// In en, this message translates to:
  /// **'AAPS context'**
  String get reportAapsContext;

  /// No description provided for @reportLocalActiveStream.
  ///
  /// In en, this message translates to:
  /// **'Local / active stream'**
  String get reportLocalActiveStream;

  /// No description provided for @reportNightscoutCloud.
  ///
  /// In en, this message translates to:
  /// **'Nightscout cloud'**
  String get reportNightscoutCloud;

  /// No description provided for @reportLatestVisibleReading.
  ///
  /// In en, this message translates to:
  /// **'latest visible reading'**
  String get reportLatestVisibleReading;

  /// No description provided for @reportLatestServerReading.
  ///
  /// In en, this message translates to:
  /// **'latest server reading'**
  String get reportLatestServerReading;

  /// No description provided for @reportModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode label'**
  String get reportModeLabel;

  /// No description provided for @reportAvailable.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get reportAvailable;

  /// No description provided for @reportNotExposed.
  ///
  /// In en, this message translates to:
  /// **'not exposed'**
  String get reportNotExposed;

  /// No description provided for @reportFastTriage.
  ///
  /// In en, this message translates to:
  /// **'fast triage'**
  String get reportFastTriage;

  /// No description provided for @reportLatestLocalReading.
  ///
  /// In en, this message translates to:
  /// **'Latest local reading'**
  String get reportLatestLocalReading;

  /// No description provided for @reportLatestNightscoutReading.
  ///
  /// In en, this message translates to:
  /// **'Latest Nightscout reading'**
  String get reportLatestNightscoutReading;

  /// No description provided for @reportXdripLocalResponse.
  ///
  /// In en, this message translates to:
  /// **'xDrip+ Local response'**
  String get reportXdripLocalResponse;

  /// No description provided for @reportNightscoutResponse.
  ///
  /// In en, this message translates to:
  /// **'Nightscout response'**
  String get reportNightscoutResponse;

  /// No description provided for @reportCompleteness24h.
  ///
  /// In en, this message translates to:
  /// **'24h completeness'**
  String get reportCompleteness24h;

  /// No description provided for @reportLargestVisibleGap.
  ///
  /// In en, this message translates to:
  /// **'Largest visible gap'**
  String get reportLargestVisibleGap;

  /// No description provided for @reportAapsEvidence.
  ///
  /// In en, this message translates to:
  /// **'AAPS evidence'**
  String get reportAapsEvidence;

  /// No description provided for @reportUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get reportUnknown;

  /// No description provided for @reportNoShareableEvidence.
  ///
  /// In en, this message translates to:
  /// **'No shareable evidence is available.'**
  String get reportNoShareableEvidence;

  /// No description provided for @reportNoEvidence.
  ///
  /// In en, this message translates to:
  /// **'No evidence'**
  String get reportNoEvidence;

  /// No description provided for @reportConfigureCgmSource.
  ///
  /// In en, this message translates to:
  /// **'Start by configuring a CGM source.'**
  String get reportConfigureCgmSource;

  /// No description provided for @reportConfigureCgmSourceBody.
  ///
  /// In en, this message translates to:
  /// **'Status Monitor needs xDrip+ Local or Nightscout evidence before it can produce a useful support report.'**
  String get reportConfigureCgmSourceBody;

  /// No description provided for @reportConfigureCgmSourceTakeaway.
  ///
  /// In en, this message translates to:
  /// **'No configured source is visible yet, so the first step is to connect xDrip+ Local or Nightscout.'**
  String get reportConfigureCgmSourceTakeaway;

  /// No description provided for @reportStartWithPath.
  ///
  /// In en, this message translates to:
  /// **'Start with the {path}.'**
  String reportStartWithPath(Object path);

  /// No description provided for @reportLocalFresherThanCloudBody.
  ///
  /// In en, this message translates to:
  /// **'Local xDrip+ evidence looks fresher than the Nightscout stream. Check whether uploads are queued, blocked, rate-limited, or delayed by the Nightscout server or network.'**
  String get reportLocalFresherThanCloudBody;

  /// No description provided for @reportLocalFresherThanCloudTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Local readings look fresher than Nightscout, so the most useful first check is the {path}.'**
  String reportLocalFresherThanCloudTakeaway(Object path);

  /// No description provided for @reportStartWithComponent.
  ///
  /// In en, this message translates to:
  /// **'Start with {component}.'**
  String reportStartWithComponent(Object component);

  /// No description provided for @reportComponentStrongestIssueTakeaway.
  ///
  /// In en, this message translates to:
  /// **'{component} has the strongest visible issue, so inspect the local acquisition path before cloud or loop context.'**
  String reportComponentStrongestIssueTakeaway(Object component);

  /// No description provided for @reportStartWithNightscout.
  ///
  /// In en, this message translates to:
  /// **'Start with Nightscout.'**
  String get reportStartWithNightscout;

  /// No description provided for @reportNightscoutFirstTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Nightscout is the most visible watch/issue component, so inspect the cloud server or upload path first.'**
  String get reportNightscoutFirstTakeaway;

  /// No description provided for @reportAapsContextLimited.
  ///
  /// In en, this message translates to:
  /// **'AAPS context is limited, not necessarily broken.'**
  String get reportAapsContextLimited;

  /// No description provided for @reportAapsContextLimitedBody.
  ///
  /// In en, this message translates to:
  /// **'The CGM data chain has enough healthy evidence, but current loop context is not visible through the configured source.'**
  String get reportAapsContextLimitedBody;

  /// No description provided for @reportAapsContextLimitedTakeaway.
  ///
  /// In en, this message translates to:
  /// **'The glucose data chain looks usable; AAPS context is limited in the available source.'**
  String get reportAapsContextLimitedTakeaway;

  /// No description provided for @reportAffectedComponentsTakeaway.
  ///
  /// In en, this message translates to:
  /// **'{affected} {verb} showing watch/issue evidence. Start with {component}, then use the component evidence table to compare the visible checks.'**
  String reportAffectedComponentsTakeaway(
      Object affected, Object verb, Object component);

  /// No description provided for @reportAndOthers.
  ///
  /// In en, this message translates to:
  /// **'and others'**
  String get reportAndOthers;

  /// No description provided for @reportUploadServerDelayPath.
  ///
  /// In en, this message translates to:
  /// **'upload/server delay'**
  String get reportUploadServerDelayPath;

  /// No description provided for @reportCloudApiPath.
  ///
  /// In en, this message translates to:
  /// **'cloud/API path'**
  String get reportCloudApiPath;

  /// No description provided for @reportComponentPair.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second}'**
  String reportComponentPair(Object first, Object second);

  /// No description provided for @reportComponentPairAndOthers.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second} {others}'**
  String reportComponentPairAndOthers(
      Object first, Object second, Object others);

  /// No description provided for @reportVerbIs.
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get reportVerbIs;

  /// No description provided for @reportVerbAre.
  ///
  /// In en, this message translates to:
  /// **'are'**
  String get reportVerbAre;

  /// No description provided for @reportNoMajorStatusIssue.
  ///
  /// In en, this message translates to:
  /// **'No major status issue is visible.'**
  String get reportNoMajorStatusIssue;

  /// No description provided for @reportNoMajorStatusIssueBody.
  ///
  /// In en, this message translates to:
  /// **'Visible checks are currently in the healthy range. Keep this report as supporting context if the issue is intermittent.'**
  String get reportNoMajorStatusIssueBody;

  /// No description provided for @reportIssuePhraseIssue.
  ///
  /// In en, this message translates to:
  /// **'{component} is in Issue'**
  String reportIssuePhraseIssue(Object component);

  /// No description provided for @reportIssuePhraseWatch.
  ///
  /// In en, this message translates to:
  /// **'{component} is in Watch'**
  String reportIssuePhraseWatch(Object component);

  /// No description provided for @reportNoDataSourceConfigured.
  ///
  /// In en, this message translates to:
  /// **'No data source is configured'**
  String get reportNoDataSourceConfigured;

  /// No description provided for @reportCurrentIssue.
  ///
  /// In en, this message translates to:
  /// **'Current issue'**
  String get reportCurrentIssue;

  /// No description provided for @reportSourceModeCommunity.
  ///
  /// In en, this message translates to:
  /// **'Source mode'**
  String get reportSourceModeCommunity;

  /// No description provided for @reportPrivacyCommunity.
  ///
  /// In en, this message translates to:
  /// **'Privacy: URL/credentials/subject id hidden'**
  String get reportPrivacyCommunity;

  /// No description provided for @reportCommunityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question: which part of the CGM data chain should I inspect first?'**
  String get reportCommunityQuestion;

  /// No description provided for @reportEvidenceScoreBody.
  ///
  /// In en, this message translates to:
  /// **'{available} of {components} components have enough evidence. {passed} of {total} checks passed.'**
  String reportEvidenceScoreBody(
      Object available, Object components, Object passed, Object total);

  /// No description provided for @reportEvidenceScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence score'**
  String get reportEvidenceScoreTitle;

  /// No description provided for @reportCopyCommunityPost.
  ///
  /// In en, this message translates to:
  /// **'Copy for community post'**
  String get reportCopyCommunityPost;

  /// No description provided for @reportPrivacySafe.
  ///
  /// In en, this message translates to:
  /// **'Privacy-safe'**
  String get reportPrivacySafe;

  /// No description provided for @reportObservedFacts.
  ///
  /// In en, this message translates to:
  /// **'Observed facts'**
  String get reportObservedFacts;

  /// No description provided for @reportLimitsOfReport.
  ///
  /// In en, this message translates to:
  /// **'Limits of this report'**
  String get reportLimitsOfReport;

  /// No description provided for @reportTimelineCurrent.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get reportTimelineCurrent;

  /// No description provided for @reportTimelinePartial.
  ///
  /// In en, this message translates to:
  /// **'partial'**
  String get reportTimelinePartial;

  /// No description provided for @reportTimelineGap.
  ///
  /// In en, this message translates to:
  /// **'gap'**
  String get reportTimelineGap;

  /// No description provided for @reportProbeNotVisible.
  ///
  /// In en, this message translates to:
  /// **'{label} is not visible in this report.'**
  String reportProbeNotVisible(Object label);

  /// No description provided for @reportProbeIsValue.
  ///
  /// In en, this message translates to:
  /// **'{label} is {value}.'**
  String reportProbeIsValue(Object label, Object value);

  /// No description provided for @reportLoopContextNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Loop context is not visible through the configured source.'**
  String get reportLoopContextNotVisible;

  /// No description provided for @reportLoopContextEvidence.
  ///
  /// In en, this message translates to:
  /// **'Loop context evidence is {value}; do not treat this as a loop decision evaluation.'**
  String reportLoopContextEvidence(Object value);

  /// No description provided for @reportLocalFreshnessNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Local or active-stream freshness is not visible. Inspect the configured source path before assuming cloud delay.'**
  String get reportLocalFreshnessNotVisible;

  /// No description provided for @reportXdripResponseIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Glucose data is visible, but direct xDrip+ Local response evidence is incomplete.'**
  String get reportXdripResponseIncomplete;

  /// No description provided for @reportActiveSourceVisible.
  ///
  /// In en, this message translates to:
  /// **'Glucose data is visible through the active source path.'**
  String get reportActiveSourceVisible;

  /// No description provided for @reportNightscoutFreshnessNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Nightscout reading freshness is not visible in this report.'**
  String get reportNightscoutFreshnessNotVisible;

  /// No description provided for @reportCloudEntriesBehind.
  ///
  /// In en, this message translates to:
  /// **'Cloud entries are behind the active stream. Inspect upload, server, or network delay.'**
  String get reportCloudEntriesBehind;

  /// No description provided for @reportCloudEntriesCurrent.
  ///
  /// In en, this message translates to:
  /// **'Cloud entries are current. If local xDrip+ is expected, inspect local service exposure first.'**
  String get reportCloudEntriesCurrent;

  /// No description provided for @reportFirstInspectionPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Treat this as a first inspection path, not proof.'**
  String get reportFirstInspectionPathTitle;

  /// No description provided for @reportFirstInspectionPathBody.
  ///
  /// In en, this message translates to:
  /// **'The report points to observable evidence. It does not prove the root cause or replace CGM alerts.'**
  String get reportFirstInspectionPathBody;

  /// No description provided for @reportNoShareableStatusEvidenceVisible.
  ///
  /// In en, this message translates to:
  /// **'No shareable status evidence is visible.'**
  String get reportNoShareableStatusEvidenceVisible;

  /// No description provided for @reportEvidenceLimitCloud.
  ///
  /// In en, this message translates to:
  /// **'This report cannot prove CGM manufacturer cloud, Dexcom Share, pump radio, or phone OS behavior.'**
  String get reportEvidenceLimitCloud;

  /// No description provided for @reportEvidenceLimitDeviceLabels.
  ///
  /// In en, this message translates to:
  /// **'Nightscout device labels are clues, not device truth.'**
  String get reportEvidenceLimitDeviceLabels;

  /// No description provided for @reportEvidenceLimitAaps.
  ///
  /// In en, this message translates to:
  /// **'AAPS context depends on what is visible through the configured source.'**
  String get reportEvidenceLimitAaps;

  /// No description provided for @reportEvidenceLimitNotAlarm.
  ///
  /// In en, this message translates to:
  /// **'This report is not an alarm or diagnosis tool.'**
  String get reportEvidenceLimitNotAlarm;

  /// No description provided for @pageEyebrowStatusMonitor.
  ///
  /// In en, this message translates to:
  /// **'Status monitor'**
  String get pageEyebrowStatusMonitor;

  /// No description provided for @pageHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Status History'**
  String get pageHistoryTitle;

  /// No description provided for @pageLowBatterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduces status refresh frequency to save power.'**
  String get pageLowBatterySubtitle;

  /// No description provided for @pageFloatingStatusBar.
  ///
  /// In en, this message translates to:
  /// **'Floating status bar'**
  String get pageFloatingStatusBar;

  /// No description provided for @pageDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CGM Sensor · xDrip+ · Nightscout'**
  String get pageDashboardSubtitle;

  /// No description provided for @pageShowNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Silent, low-priority status monitor notification.'**
  String get pageShowNotificationSubtitle;

  /// No description provided for @pageEyebrowLiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Live status'**
  String get pageEyebrowLiveStatus;

  /// No description provided for @pageShowNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Show in notification bar'**
  String get pageShowNotificationTitle;

  /// No description provided for @pageLockScreenStatus.
  ///
  /// In en, this message translates to:
  /// **'Lock screen status'**
  String get pageLockScreenStatus;

  /// No description provided for @pageReportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get pageReportTooltip;

  /// No description provided for @pageHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'7-day component status'**
  String get pageHistorySubtitle;

  /// No description provided for @pageWidgetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Home screen and persistent status surfaces'**
  String get pageWidgetsSubtitle;

  /// No description provided for @pageStatusNotification.
  ///
  /// In en, this message translates to:
  /// **'Status notification'**
  String get pageStatusNotification;

  /// No description provided for @pageLowBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Low-battery friendly mode'**
  String get pageLowBatteryTitle;

  /// No description provided for @pageWidgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets & Notifications'**
  String get pageWidgetsTitle;

  /// No description provided for @pageWidgetTemplates.
  ///
  /// In en, this message translates to:
  /// **'Widget templates'**
  String get pageWidgetTemplates;

  /// No description provided for @pageAddToHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'Add to home screen'**
  String get pageAddToHomeScreen;

  /// No description provided for @pageComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get pageComponents;

  /// No description provided for @pageRefreshNow.
  ///
  /// In en, this message translates to:
  /// **'Refresh now'**
  String get pageRefreshNow;

  /// No description provided for @pageAapsIobCobProfile.
  ///
  /// In en, this message translates to:
  /// **'IOB / COB / profile'**
  String get pageAapsIobCobProfile;

  /// No description provided for @pageContextVisibility.
  ///
  /// In en, this message translates to:
  /// **'Context visibility'**
  String get pageContextVisibility;

  /// No description provided for @pageProfileTempTarget.
  ///
  /// In en, this message translates to:
  /// **'Profile / temp target'**
  String get pageProfileTempTarget;

  /// No description provided for @pageSourceNightscoutDeviceStatus.
  ///
  /// In en, this message translates to:
  /// **'source: Nightscout device status'**
  String get pageSourceNightscoutDeviceStatus;

  /// No description provided for @pageNoLocalAapsRestAssumed.
  ///
  /// In en, this message translates to:
  /// **'no local AAPS REST assumed'**
  String get pageNoLocalAapsRestAssumed;

  /// No description provided for @pageMissingFieldsReduceConfidence.
  ///
  /// In en, this message translates to:
  /// **'missing fields reduce confidence'**
  String get pageMissingFieldsReduceConfidence;

  /// No description provided for @pagePumpLoopContext.
  ///
  /// In en, this message translates to:
  /// **'Pump and loop context'**
  String get pagePumpLoopContext;

  /// No description provided for @pageFactualChecksOnly.
  ///
  /// In en, this message translates to:
  /// **'Factual checks only'**
  String get pageFactualChecksOnly;

  /// No description provided for @pageStatusHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get pageStatusHealthy;

  /// No description provided for @pageStatusWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get pageStatusWatch;

  /// No description provided for @pageStatusIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get pageStatusIssue;

  /// No description provided for @pageStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get pageStatusUnknown;

  /// No description provided for @pageStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get pageStatusAvailable;

  /// No description provided for @pageStatusHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get pageStatusHistory;

  /// No description provided for @pageStatusMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get pageStatusMixed;

  /// No description provided for @pageStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get pageStatusLive;

  /// No description provided for @pageLatestProbe.
  ///
  /// In en, this message translates to:
  /// **'Latest probe'**
  String get pageLatestProbe;

  /// No description provided for @pageLast3h.
  ///
  /// In en, this message translates to:
  /// **'Last 3h'**
  String get pageLast3h;

  /// No description provided for @pageLast30m.
  ///
  /// In en, this message translates to:
  /// **'Last 30m'**
  String get pageLast30m;

  /// No description provided for @pageNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get pageNow;

  /// No description provided for @pageThreeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'3h ago'**
  String get pageThreeHoursAgo;

  /// No description provided for @pageFresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh'**
  String get pageFresh;

  /// No description provided for @pageStalePartial.
  ///
  /// In en, this message translates to:
  /// **'Stale/partial'**
  String get pageStalePartial;

  /// No description provided for @pageMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get pageMissing;

  /// No description provided for @pageEvidenceMatrix.
  ///
  /// In en, this message translates to:
  /// **'Evidence matrix'**
  String get pageEvidenceMatrix;

  /// No description provided for @pageLoopEvidenceTimeline.
  ///
  /// In en, this message translates to:
  /// **'Loop evidence timeline'**
  String get pageLoopEvidenceTimeline;

  /// No description provided for @pageLatestContext.
  ///
  /// In en, this message translates to:
  /// **'Latest {context}'**
  String pageLatestContext(Object context);

  /// No description provided for @pageNightscoutDeviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Nightscout device status'**
  String get pageNightscoutDeviceStatus;

  /// No description provided for @pageOpenapsContext.
  ///
  /// In en, this message translates to:
  /// **'OpenAPS context'**
  String get pageOpenapsContext;

  /// No description provided for @pageEndpointMatrix.
  ///
  /// In en, this message translates to:
  /// **'Endpoint matrix'**
  String get pageEndpointMatrix;

  /// No description provided for @pageReachable.
  ///
  /// In en, this message translates to:
  /// **'reachable'**
  String get pageReachable;

  /// No description provided for @pageNotReachable.
  ///
  /// In en, this message translates to:
  /// **'not reachable'**
  String get pageNotReachable;

  /// No description provided for @pageCheckedRecently.
  ///
  /// In en, this message translates to:
  /// **'checked recently'**
  String get pageCheckedRecently;

  /// No description provided for @pageResponseTimeline.
  ///
  /// In en, this message translates to:
  /// **'Response timeline'**
  String get pageResponseTimeline;

  /// No description provided for @pageNoResponseSamples.
  ///
  /// In en, this message translates to:
  /// **'No response samples yet. Open this page after the next refresh to build the timeline.'**
  String get pageNoResponseSamples;

  /// No description provided for @pageMedianMs.
  ///
  /// In en, this message translates to:
  /// **'Median {ms}ms'**
  String pageMedianMs(Object ms);

  /// No description provided for @pageTimeouts.
  ///
  /// In en, this message translates to:
  /// **'{count} timeouts'**
  String pageTimeouts(Object count);

  /// No description provided for @dashboardWaitingForSource.
  ///
  /// In en, this message translates to:
  /// **'Waiting for source'**
  String get dashboardWaitingForSource;

  /// No description provided for @dashboardTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Status temporarily unavailable'**
  String get dashboardTemporarilyUnavailable;

  /// No description provided for @dashboardRefreshFailedBody.
  ///
  /// In en, this message translates to:
  /// **'SolgoInsight could not refresh this status view. Please try again or check your data source settings.'**
  String get dashboardRefreshFailedBody;

  /// No description provided for @dashboardCheckingStatus.
  ///
  /// In en, this message translates to:
  /// **'Checking status'**
  String get dashboardCheckingStatus;

  /// No description provided for @dashboardPreparingLatest.
  ///
  /// In en, this message translates to:
  /// **'SolgoInsight is preparing the latest dashboard state.'**
  String get dashboardPreparingLatest;

  /// No description provided for @dashboardWaitingTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a configured data source.'**
  String get dashboardWaitingTakeaway;

  /// No description provided for @dashboardNoSourceSummary.
  ///
  /// In en, this message translates to:
  /// **'No source configured for this subject.'**
  String get dashboardNoSourceSummary;

  /// No description provided for @dashboardSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get dashboardSourceLabel;

  /// No description provided for @dashboardNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get dashboardNotConfigured;

  /// No description provided for @dashboardNoSource.
  ///
  /// In en, this message translates to:
  /// **'No source'**
  String get dashboardNoSource;

  /// No description provided for @dashboardNeedsSourceHeadline.
  ///
  /// In en, this message translates to:
  /// **'Status needs a configured data source.'**
  String get dashboardNeedsSourceHeadline;

  /// No description provided for @dashboardNeedsSourceBody.
  ///
  /// In en, this message translates to:
  /// **'Connect Nightscout or xDrip+ Local to read CGM, uploader, and server status.'**
  String get dashboardNeedsSourceBody;

  /// No description provided for @dashboardNeedsSourceMeta.
  ///
  /// In en, this message translates to:
  /// **'No data source - status is not evaluated yet'**
  String get dashboardNeedsSourceMeta;

  /// No description provided for @dashboardNeedsSourceEmptyReason.
  ///
  /// In en, this message translates to:
  /// **'Set up a data source in Profile to monitor CGM, uploader, and server status.'**
  String get dashboardNeedsSourceEmptyReason;

  /// No description provided for @notificationChannelTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Monitor'**
  String get notificationChannelTitle;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Silent status monitor notification.'**
  String get notificationChannelDescription;

  /// No description provided for @pageNoRecentTimeouts.
  ///
  /// In en, this message translates to:
  /// **'No timeouts visible in recent probes'**
  String get pageNoRecentTimeouts;

  /// No description provided for @pageRecentTimeoutsVisible.
  ///
  /// In en, this message translates to:
  /// **'Timeouts were visible in recent probes'**
  String get pageRecentTimeoutsVisible;

  /// No description provided for @pageSensorContext.
  ///
  /// In en, this message translates to:
  /// **'Sensor context'**
  String get pageSensorContext;

  /// No description provided for @pageOptionalSourceData.
  ///
  /// In en, this message translates to:
  /// **'Optional source data'**
  String get pageOptionalSourceData;

  /// No description provided for @pageSessionAgeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Session age / remaining'**
  String get pageSessionAgeRemaining;

  /// No description provided for @pageCollectorContext.
  ///
  /// In en, this message translates to:
  /// **'Collector context'**
  String get pageCollectorContext;

  /// No description provided for @pageCollectorHealthyCopy.
  ///
  /// In en, this message translates to:
  /// **'No source-side collector warning was available during the last probe.'**
  String get pageCollectorHealthyCopy;

  /// No description provided for @pageReadingSource.
  ///
  /// In en, this message translates to:
  /// **'Reading source'**
  String get pageReadingSource;

  /// No description provided for @pageReadingSourceCopy.
  ///
  /// In en, this message translates to:
  /// **'Recent readings came from {source}, then fed into the CGM Sensor engine.'**
  String pageReadingSourceCopy(Object source);

  /// No description provided for @pageSensorNotice.
  ///
  /// In en, this message translates to:
  /// **'SolgoInsight shows observable sensor-data quality. It does not replace xDrip+ sensor handling, calibration, primary alerts, or clinical judgment.'**
  String get pageSensorNotice;

  /// No description provided for @pageLast24h.
  ///
  /// In en, this message translates to:
  /// **'Last 24h'**
  String get pageLast24h;

  /// No description provided for @pageContinuous.
  ///
  /// In en, this message translates to:
  /// **'continuous'**
  String get pageContinuous;

  /// No description provided for @pageSparse.
  ///
  /// In en, this message translates to:
  /// **'sparse'**
  String get pageSparse;

  /// No description provided for @pageGap.
  ///
  /// In en, this message translates to:
  /// **'gap'**
  String get pageGap;

  /// No description provided for @pageUnknownLower.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get pageUnknownLower;

  /// No description provided for @pageLatestAge.
  ///
  /// In en, this message translates to:
  /// **'Latest {age}'**
  String pageLatestAge(Object age);

  /// No description provided for @pageNoVisibleGap.
  ///
  /// In en, this message translates to:
  /// **'No visible gap'**
  String get pageNoVisibleGap;

  /// No description provided for @pageGapBuckets.
  ///
  /// In en, this message translates to:
  /// **'{count} gap buckets'**
  String pageGapBuckets(Object count);

  /// No description provided for @pageSensorQualityTimeline.
  ///
  /// In en, this message translates to:
  /// **'Sensor quality timeline'**
  String get pageSensorQualityTimeline;

  /// No description provided for @pageSuddenJumps.
  ///
  /// In en, this message translates to:
  /// **'Sudden jumps'**
  String get pageSuddenJumps;

  /// No description provided for @pageMajorJumps.
  ///
  /// In en, this message translates to:
  /// **'{count} major jumps'**
  String pageMajorJumps(Object count);

  /// No description provided for @pageQuietBaseline.
  ///
  /// In en, this message translates to:
  /// **'quiet baseline'**
  String get pageQuietBaseline;

  /// No description provided for @pageWatchJump.
  ///
  /// In en, this message translates to:
  /// **'watch jump'**
  String get pageWatchJump;

  /// No description provided for @pageIssueJump.
  ///
  /// In en, this message translates to:
  /// **'issue jump'**
  String get pageIssueJump;

  /// No description provided for @pageNoAbruptSensorJumps.
  ///
  /// In en, this message translates to:
  /// **'No abrupt sensor jumps'**
  String get pageNoAbruptSensorJumps;

  /// No description provided for @pageLargestJump.
  ///
  /// In en, this message translates to:
  /// **'Largest jump {value} mmol/L'**
  String pageLargestJump(Object value);

  /// No description provided for @pageAdjacentReadingsOnly.
  ///
  /// In en, this message translates to:
  /// **'Adjacent readings only | gap must be 10m or less'**
  String get pageAdjacentReadingsOnly;

  /// No description provided for @pageFlatPeriods.
  ///
  /// In en, this message translates to:
  /// **'Flat periods'**
  String get pageFlatPeriods;

  /// No description provided for @pageLongestMinutes.
  ///
  /// In en, this message translates to:
  /// **'Longest {minutes}m'**
  String pageLongestMinutes(Object minutes);

  /// No description provided for @pageWatch30m.
  ///
  /// In en, this message translates to:
  /// **'30m watch'**
  String get pageWatch30m;

  /// No description provided for @pageIssue60m.
  ///
  /// In en, this message translates to:
  /// **'60m issue'**
  String get pageIssue60m;

  /// No description provided for @pageFlatThresholdReached.
  ///
  /// In en, this message translates to:
  /// **'Flat period threshold reached'**
  String get pageFlatThresholdReached;

  /// No description provided for @pageNo30mFlatPeriod.
  ///
  /// In en, this message translates to:
  /// **'No 30m flat period'**
  String get pageNo30mFlatPeriod;

  /// No description provided for @pageFlatContextNote.
  ///
  /// In en, this message translates to:
  /// **'Flat periods are context, not a root-cause label.'**
  String get pageFlatContextNote;

  /// No description provided for @pageVariabilityNoise.
  ///
  /// In en, this message translates to:
  /// **'Variability and noise'**
  String get pageVariabilityNoise;

  /// No description provided for @pageReadings24h.
  ///
  /// In en, this message translates to:
  /// **'24h readings'**
  String get pageReadings24h;

  /// No description provided for @pageCvNoise.
  ///
  /// In en, this message translates to:
  /// **'CV / noise'**
  String get pageCvNoise;

  /// No description provided for @pageContinuity.
  ///
  /// In en, this message translates to:
  /// **'Continuity'**
  String get pageContinuity;

  /// No description provided for @pageCvWatchBody.
  ///
  /// In en, this message translates to:
  /// **'Watch range below 36%. This is variability context, not a diagnosis.'**
  String get pageCvWatchBody;

  /// No description provided for @pageObservedCadenceBody.
  ///
  /// In en, this message translates to:
  /// **'Observed readings compared with expected 5 minute cadence.'**
  String get pageObservedCadenceBody;

  /// No description provided for @pageCadenceFreshnessBody.
  ///
  /// In en, this message translates to:
  /// **'Cadence plus latest sensor freshness ({age}).'**
  String pageCadenceFreshnessBody(Object age);

  /// No description provided for @pageServerDataFreshness.
  ///
  /// In en, this message translates to:
  /// **'Server data freshness'**
  String get pageServerDataFreshness;

  /// No description provided for @pageFromEntriesEndpoint.
  ///
  /// In en, this message translates to:
  /// **'From entries endpoint'**
  String get pageFromEntriesEndpoint;

  /// No description provided for @pageLatestServerReading.
  ///
  /// In en, this message translates to:
  /// **'Latest server reading'**
  String get pageLatestServerReading;

  /// No description provided for @pageAvailableEndpoints.
  ///
  /// In en, this message translates to:
  /// **'Available endpoints'**
  String get pageAvailableEndpoints;

  /// No description provided for @pageMeasuredLatestEntry.
  ///
  /// In en, this message translates to:
  /// **'Measured from the latest entry returned by Nightscout.'**
  String get pageMeasuredLatestEntry;

  /// No description provided for @pageRecentNightscoutEndpoints.
  ///
  /// In en, this message translates to:
  /// **'Recent Nightscout endpoints parsed from API probes.'**
  String get pageRecentNightscoutEndpoints;

  /// No description provided for @pageDataFreshnessTimeline.
  ///
  /// In en, this message translates to:
  /// **'Data freshness timeline'**
  String get pageDataFreshnessTimeline;

  /// No description provided for @pageHealthyCadence.
  ///
  /// In en, this message translates to:
  /// **'healthy cadence'**
  String get pageHealthyCadence;

  /// No description provided for @pageDelayed.
  ///
  /// In en, this message translates to:
  /// **'delayed'**
  String get pageDelayed;

  /// No description provided for @pageCompleteness24h.
  ///
  /// In en, this message translates to:
  /// **'24h completeness'**
  String get pageCompleteness24h;

  /// No description provided for @pageExpectedReadings.
  ///
  /// In en, this message translates to:
  /// **'{observed} / {expected} expected'**
  String pageExpectedReadings(Object observed, Object expected);

  /// No description provided for @pageCoveragePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% coverage'**
  String pageCoveragePercent(Object percent);

  /// No description provided for @pageExpectedFiveMinuteCadence.
  ///
  /// In en, this message translates to:
  /// **'Expected 5 minute cadence'**
  String get pageExpectedFiveMinuteCadence;

  /// No description provided for @pageServiceAndBattery.
  ///
  /// In en, this message translates to:
  /// **'Service and battery'**
  String get pageServiceAndBattery;

  /// No description provided for @pageLocalService.
  ///
  /// In en, this message translates to:
  /// **'Local service'**
  String get pageLocalService;

  /// No description provided for @pageXdripLocalModeNote.
  ///
  /// In en, this message translates to:
  /// **'/status.json available only in xDrip+ local mode'**
  String get pageXdripLocalModeNote;

  /// No description provided for @pageUploaderBattery.
  ///
  /// In en, this message translates to:
  /// **'Uploader battery'**
  String get pageUploaderBattery;

  /// No description provided for @pageBatteryPebbleNote.
  ///
  /// In en, this message translates to:
  /// **'Battery signal from /pebble endpoint'**
  String get pageBatteryPebbleNote;

  /// No description provided for @pageSensorCollectorContext.
  ///
  /// In en, this message translates to:
  /// **'Sensor and collector context'**
  String get pageSensorCollectorContext;

  /// No description provided for @pageOptionalChecks.
  ///
  /// In en, this message translates to:
  /// **'Optional checks'**
  String get pageOptionalChecks;

  /// No description provided for @pageUploadLatency.
  ///
  /// In en, this message translates to:
  /// **'Upload latency'**
  String get pageUploadLatency;

  /// No description provided for @pageUploadLatencyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable in local mode because server receipt timestamps are not present.'**
  String get pageUploadLatencyUnavailable;

  /// No description provided for @pageObservedActiveXdripSource.
  ///
  /// In en, this message translates to:
  /// **'Observed from active xDrip+ source context.'**
  String get pageObservedActiveXdripSource;

  /// No description provided for @pageDetectedNightscoutMarkers.
  ///
  /// In en, this message translates to:
  /// **'Detected Nightscout markers'**
  String get pageDetectedNightscoutMarkers;

  /// No description provided for @pageMarkerEvidenceNote.
  ///
  /// In en, this message translates to:
  /// **'Evidence, not device truth'**
  String get pageMarkerEvidenceNote;

  /// No description provided for @pageCapabilityContext.
  ///
  /// In en, this message translates to:
  /// **'Capability context'**
  String get pageCapabilityContext;

  /// No description provided for @pageWhatSiteExposes.
  ///
  /// In en, this message translates to:
  /// **'What this site exposes'**
  String get pageWhatSiteExposes;

  /// No description provided for @pageObservedNightscoutApiProbes.
  ///
  /// In en, this message translates to:
  /// **'Observed from Nightscout API probes.'**
  String get pageObservedNightscoutApiProbes;

  /// No description provided for @pageFloatingPermissionReady.
  ///
  /// In en, this message translates to:
  /// **'Floating permission is ready.'**
  String get pageFloatingPermissionReady;

  /// No description provided for @pageEnableFloatingPermission.
  ///
  /// In en, this message translates to:
  /// **'Enable floating permission'**
  String get pageEnableFloatingPermission;

  /// No description provided for @pageSevenDayHistory.
  ///
  /// In en, this message translates to:
  /// **'7-Day History'**
  String get pageSevenDayHistory;

  /// No description provided for @pageSevenDayHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'See when each component changed state.'**
  String get pageSevenDayHistorySubtitle;

  /// No description provided for @pageToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get pageToday;

  /// No description provided for @pageMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get pageMonthJan;

  /// No description provided for @pageMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get pageMonthFeb;

  /// No description provided for @pageMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get pageMonthMar;

  /// No description provided for @pageMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get pageMonthApr;

  /// No description provided for @pageMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get pageMonthMay;

  /// No description provided for @pageMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get pageMonthJun;

  /// No description provided for @pageMonthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get pageMonthJul;

  /// No description provided for @pageMonthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get pageMonthAug;

  /// No description provided for @pageMonthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get pageMonthSep;

  /// No description provided for @pageMonthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get pageMonthOct;

  /// No description provided for @pageMonthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get pageMonthNov;

  /// No description provided for @pageMonthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get pageMonthDec;

  /// No description provided for @pageXdripSignalMissingReason.
  ///
  /// In en, this message translates to:
  /// **'This xDrip+ signal was not included in the latest report'**
  String get pageXdripSignalMissingReason;

  /// No description provided for @pageConnectNightscout.
  ///
  /// In en, this message translates to:
  /// **'Connect Nightscout'**
  String get pageConnectNightscout;

  /// No description provided for @pageSetupSourceBody.
  ///
  /// In en, this message translates to:
  /// **'Set up a data source in Profile to monitor CGM, uploader, and server status for this subject.'**
  String get pageSetupSourceBody;

  /// No description provided for @pageSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get pageSetUp;

  /// No description provided for @reportCapabilityEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get reportCapabilityEntries;

  /// No description provided for @reportCapabilityRangeQuery.
  ///
  /// In en, this message translates to:
  /// **'Range query'**
  String get reportCapabilityRangeQuery;

  /// No description provided for @reportCapabilityPebble.
  ///
  /// In en, this message translates to:
  /// **'Pebble'**
  String get reportCapabilityPebble;

  /// No description provided for @reportCapabilityUploaderBattery.
  ///
  /// In en, this message translates to:
  /// **'Uploader battery'**
  String get reportCapabilityUploaderBattery;

  /// No description provided for @reportCapabilityDeviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device status'**
  String get reportCapabilityDeviceStatus;

  /// No description provided for @reportCapabilityNightscoutStatus.
  ///
  /// In en, this message translates to:
  /// **'Nightscout status'**
  String get reportCapabilityNightscoutStatus;

  /// No description provided for @reportCapabilityUploadLatency.
  ///
  /// In en, this message translates to:
  /// **'Upload latency'**
  String get reportCapabilityUploadLatency;

  /// No description provided for @reportConfiguredSource.
  ///
  /// In en, this message translates to:
  /// **'Configured source'**
  String get reportConfiguredSource;

  /// No description provided for @reportChecksPassed.
  ///
  /// In en, this message translates to:
  /// **'{passed}/{total} passed'**
  String reportChecksPassed(Object passed, Object total);

  /// No description provided for @reportMeetsExpected.
  ///
  /// In en, this message translates to:
  /// **'{value} (meets {expected} expected)'**
  String reportMeetsExpected(Object value, Object expected);

  /// No description provided for @reportObservedExpected.
  ///
  /// In en, this message translates to:
  /// **'{value} ({observed}/{expected} expected)'**
  String reportObservedExpected(Object value, Object observed, Object expected);

  /// No description provided for @reportGapsOver15m.
  ///
  /// In en, this message translates to:
  /// **'{value}, {count} gaps >15m'**
  String reportGapsOver15m(Object value, Object count);

  /// No description provided for @widgetStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get widgetStatus;

  /// No description provided for @widgetStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable'**
  String get widgetStatusUnavailable;

  /// No description provided for @widgetNoRecentStatus.
  ///
  /// In en, this message translates to:
  /// **'No recent status'**
  String get widgetNoRecentStatus;

  /// No description provided for @widgetConnectSourceSummary.
  ///
  /// In en, this message translates to:
  /// **'Connect a Nightscout source to monitor CGM, uploader, and server status.'**
  String get widgetConnectSourceSummary;

  /// No description provided for @widgetOpenToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Open SolgoInsight to refresh the latest status snapshot.'**
  String get widgetOpenToRefresh;

  /// No description provided for @widgetStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Status available'**
  String get widgetStatusAvailable;

  /// No description provided for @widgetAllSystemsHealthy.
  ///
  /// In en, this message translates to:
  /// **'All systems healthy'**
  String get widgetAllSystemsHealthy;

  /// No description provided for @widgetWatchStatus.
  ///
  /// In en, this message translates to:
  /// **'Watch {component}'**
  String widgetWatchStatus(Object component);

  /// No description provided for @widgetComponentIssue.
  ///
  /// In en, this message translates to:
  /// **'{component} issue'**
  String widgetComponentIssue(Object component);

  /// No description provided for @widgetUpdatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get widgetUpdatedJustNow;

  /// No description provided for @widgetUpdatedMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {minutes} min ago'**
  String widgetUpdatedMinutesAgo(Object minutes);

  /// No description provided for @widgetUpdatedHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {hours}h ago'**
  String widgetUpdatedHoursAgo(Object hours);

  /// No description provided for @widgetUpdatedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {days}d ago'**
  String widgetUpdatedDaysAgo(Object days);

  /// No description provided for @metricAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get metricAccessToken;

  /// No description provided for @metricApiReachable.
  ///
  /// In en, this message translates to:
  /// **'API reachable'**
  String get metricApiReachable;

  /// No description provided for @metricCobContext.
  ///
  /// In en, this message translates to:
  /// **'COB context'**
  String get metricCobContext;

  /// No description provided for @metricCollectorContext.
  ///
  /// In en, this message translates to:
  /// **'Collector context'**
  String get metricCollectorContext;

  /// No description provided for @metricCv24h.
  ///
  /// In en, this message translates to:
  /// **'CV (24h)'**
  String get metricCv24h;

  /// No description provided for @metricDeviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device status'**
  String get metricDeviceStatus;

  /// No description provided for @metricDevicestatus.
  ///
  /// In en, this message translates to:
  /// **'devicestatus'**
  String get metricDevicestatus;

  /// No description provided for @metricEntriesEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Entries endpoint'**
  String get metricEntriesEndpoint;

  /// No description provided for @metricFlatLinePeriods.
  ///
  /// In en, this message translates to:
  /// **'Flat-line periods'**
  String get metricFlatLinePeriods;

  /// No description provided for @metricIobCobContext.
  ///
  /// In en, this message translates to:
  /// **'IOB / COB context'**
  String get metricIobCobContext;

  /// No description provided for @metricIobContext.
  ///
  /// In en, this message translates to:
  /// **'IOB context'**
  String get metricIobContext;

  /// No description provided for @metricLastReadingFreshness.
  ///
  /// In en, this message translates to:
  /// **'Last reading freshness'**
  String get metricLastReadingFreshness;

  /// No description provided for @metricLatestAapsContext.
  ///
  /// In en, this message translates to:
  /// **'Latest AAPS context'**
  String get metricLatestAapsContext;

  /// No description provided for @metricLatestServerReading.
  ///
  /// In en, this message translates to:
  /// **'Latest server reading'**
  String get metricLatestServerReading;

  /// No description provided for @metricLocalService.
  ///
  /// In en, this message translates to:
  /// **'Local service'**
  String get metricLocalService;

  /// No description provided for @metricLoopContext.
  ///
  /// In en, this message translates to:
  /// **'Loop context'**
  String get metricLoopContext;

  /// No description provided for @metricNightscoutEvidence.
  ///
  /// In en, this message translates to:
  /// **'Nightscout evidence'**
  String get metricNightscoutEvidence;

  /// No description provided for @metricNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings'**
  String get metricNoReadings;

  /// No description provided for @metricP95UploadLatency.
  ///
  /// In en, this message translates to:
  /// **'P95 upload latency'**
  String get metricP95UploadLatency;

  /// No description provided for @metricProfileTempTarget.
  ///
  /// In en, this message translates to:
  /// **'Profile / temp target'**
  String get metricProfileTempTarget;

  /// No description provided for @metricProfileContext.
  ///
  /// In en, this message translates to:
  /// **'Profile context'**
  String get metricProfileContext;

  /// No description provided for @metricPumpContext.
  ///
  /// In en, this message translates to:
  /// **'Pump context'**
  String get metricPumpContext;

  /// No description provided for @metricResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Response time'**
  String get metricResponseTime;

  /// No description provided for @metricSensorContext.
  ///
  /// In en, this message translates to:
  /// **'Sensor context'**
  String get metricSensorContext;

  /// No description provided for @metricSensorDataFreshness.
  ///
  /// In en, this message translates to:
  /// **'Sensor data freshness'**
  String get metricSensorDataFreshness;

  /// No description provided for @metricSensorLifetime.
  ///
  /// In en, this message translates to:
  /// **'Sensor lifetime'**
  String get metricSensorLifetime;

  /// No description provided for @metricSensorCollectorContext.
  ///
  /// In en, this message translates to:
  /// **'Sensor/collector context'**
  String get metricSensorCollectorContext;

  /// No description provided for @metricSignalContinuity.
  ///
  /// In en, this message translates to:
  /// **'Signal continuity'**
  String get metricSignalContinuity;

  /// No description provided for @metricStatusEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Status endpoint'**
  String get metricStatusEndpoint;

  /// No description provided for @metricSuddenChanges24h.
  ///
  /// In en, this message translates to:
  /// **'Sudden changes (24h)'**
  String get metricSuddenChanges24h;

  /// No description provided for @metricUploaderBattery.
  ///
  /// In en, this message translates to:
  /// **'Uploader battery'**
  String get metricUploaderBattery;

  /// No description provided for @metricVersionContext.
  ///
  /// In en, this message translates to:
  /// **'Version context'**
  String get metricVersionContext;

  /// No description provided for @metricReadingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} readings'**
  String metricReadingsCount(Object count);

  /// No description provided for @metricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get metricNotAvailable;

  /// No description provided for @pageAapsSync.
  ///
  /// In en, this message translates to:
  /// **'AAPS sync'**
  String get pageAapsSync;

  /// No description provided for @pagePump.
  ///
  /// In en, this message translates to:
  /// **'Pump'**
  String get pagePump;

  /// No description provided for @pageProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get pageProfile;

  /// No description provided for @pageNoAapsContext.
  ///
  /// In en, this message translates to:
  /// **'No AAPS context'**
  String get pageNoAapsContext;

  /// No description provided for @pageJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get pageJustNow;

  /// No description provided for @pageMinutesAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String pageMinutesAgoShort(Object minutes);

  /// No description provided for @pageHoursAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String pageHoursAgoShort(Object hours);

  /// No description provided for @pageDaysAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String pageDaysAgoShort(Object days);

  /// No description provided for @pageOpenapsContextNotVisible.
  ///
  /// In en, this message translates to:
  /// **'OpenAPS context is not visible.'**
  String get pageOpenapsContextNotVisible;

  /// No description provided for @pagePumpContextNotVisibleNightscout.
  ///
  /// In en, this message translates to:
  /// **'Pump context is not visible in Nightscout.'**
  String get pagePumpContextNotVisibleNightscout;

  /// No description provided for @pageIobContextNotVisible.
  ///
  /// In en, this message translates to:
  /// **'IOB context is not visible.'**
  String get pageIobContextNotVisible;

  /// No description provided for @pageCobContextNotVisible.
  ///
  /// In en, this message translates to:
  /// **'COB context is not visible.'**
  String get pageCobContextNotVisible;

  /// No description provided for @pageProfileTempTargetNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Profile or temp target context is not visible.'**
  String get pageProfileTempTargetNotVisible;

  /// No description provided for @pageNightscoutApiReachableEvidence.
  ///
  /// In en, this message translates to:
  /// **'Reachable. Device status endpoint returned evidence.'**
  String get pageNightscoutApiReachableEvidence;

  /// No description provided for @pageNightscoutConfiguredEvidenceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Nightscout is configured but current evidence is unavailable.'**
  String get pageNightscoutConfiguredEvidenceUnavailable;

  /// No description provided for @pageNoNightscoutTargetConfigured.
  ///
  /// In en, this message translates to:
  /// **'No Nightscout target is configured.'**
  String get pageNoNightscoutTargetConfigured;

  /// No description provided for @pageNoOpenapsLoopContextVisible.
  ///
  /// In en, this message translates to:
  /// **'No OpenAPS loop context is visible in sampled device status.'**
  String get pageNoOpenapsLoopContextVisible;

  /// No description provided for @pageNoRecentProfileTempTargetContext.
  ///
  /// In en, this message translates to:
  /// **'No recent profile or temp target context in the sampled response.'**
  String get pageNoRecentProfileTempTargetContext;

  /// No description provided for @pagePartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get pagePartial;

  /// No description provided for @pageVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get pageVisible;

  /// No description provided for @pageNoTimelineData.
  ///
  /// In en, this message translates to:
  /// **'No timeline data'**
  String get pageNoTimelineData;

  /// No description provided for @pageLatestTimelineLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest {label}'**
  String pageLatestTimelineLabel(Object label);

  /// No description provided for @pageNoVisibleIssueCluster.
  ///
  /// In en, this message translates to:
  /// **'No visible issue cluster'**
  String get pageNoVisibleIssueCluster;

  /// No description provided for @pageIssueBucketsInView.
  ///
  /// In en, this message translates to:
  /// **'{count} issue buckets in view'**
  String pageIssueBucketsInView(Object count);

  /// No description provided for @pageOlder.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get pageOlder;

  /// No description provided for @pageMid.
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get pageMid;

  /// No description provided for @pageCurrentReadings.
  ///
  /// In en, this message translates to:
  /// **'Current readings'**
  String get pageCurrentReadings;

  /// No description provided for @pagePossibleDirections.
  ///
  /// In en, this message translates to:
  /// **'Possible directions'**
  String get pagePossibleDirections;

  /// No description provided for @pageModeReadingsQuality.
  ///
  /// In en, this message translates to:
  /// **'READINGS QUALITY'**
  String get pageModeReadingsQuality;

  /// No description provided for @pageModeLocalService.
  ///
  /// In en, this message translates to:
  /// **'LOCAL SERVICE'**
  String get pageModeLocalService;

  /// No description provided for @pageModeNightscoutApi.
  ///
  /// In en, this message translates to:
  /// **'NIGHTSCOUT API'**
  String get pageModeNightscoutApi;

  /// No description provided for @pageModeNightscoutEvidence.
  ///
  /// In en, this message translates to:
  /// **'NIGHTSCOUT EVIDENCE'**
  String get pageModeNightscoutEvidence;

  /// No description provided for @pageComponentCgmSensor.
  ///
  /// In en, this message translates to:
  /// **'CGM Sensor'**
  String get pageComponentCgmSensor;

  /// No description provided for @pageComponentXdrip.
  ///
  /// In en, this message translates to:
  /// **'xDrip+'**
  String get pageComponentXdrip;

  /// No description provided for @pageComponentNightscout.
  ///
  /// In en, this message translates to:
  /// **'Nightscout'**
  String get pageComponentNightscout;

  /// No description provided for @pageComponentAapsLoop.
  ///
  /// In en, this message translates to:
  /// **'AAPS Loop'**
  String get pageComponentAapsLoop;

  /// No description provided for @pageLatestSensorReadingObserved.
  ///
  /// In en, this message translates to:
  /// **'Latest sensor reading observed'**
  String get pageLatestSensorReadingObserved;

  /// No description provided for @pageConfidenceAvailableMetrics.
  ///
  /// In en, this message translates to:
  /// **'Confidence based on available metrics'**
  String get pageConfidenceAvailableMetrics;

  /// No description provided for @pageConfidenceAvailableEndpoints.
  ///
  /// In en, this message translates to:
  /// **'Confidence based on available endpoints'**
  String get pageConfidenceAvailableEndpoints;

  /// No description provided for @pageConfidenceAvailableContext.
  ///
  /// In en, this message translates to:
  /// **'Confidence based on available context'**
  String get pageConfidenceAvailableContext;

  /// No description provided for @pageConfidenceNightscoutEvidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence based on Nightscout evidence'**
  String get pageConfidenceNightscoutEvidence;

  /// No description provided for @pageChecksPassedShort.
  ///
  /// In en, this message translates to:
  /// **'{available}/{total} checks passed'**
  String pageChecksPassedShort(Object available, Object total);

  /// No description provided for @pageLockScreenDisabled.
  ///
  /// In en, this message translates to:
  /// **'Lock screen disabled'**
  String get pageLockScreenDisabled;

  /// No description provided for @pageNotificationLowPriorityNote.
  ///
  /// In en, this message translates to:
  /// **'Low-priority status only. No sound, vibration, snooze, or dismiss.'**
  String get pageNotificationLowPriorityNote;

  /// No description provided for @pageHowToPlaceWidget.
  ///
  /// In en, this message translates to:
  /// **'How to place a widget'**
  String get pageHowToPlaceWidget;

  /// No description provided for @pageWidgetStepLongPress.
  ///
  /// In en, this message translates to:
  /// **'Long-press any empty area of your home screen'**
  String get pageWidgetStepLongPress;

  /// No description provided for @pageWidgetStepTapWidgets.
  ///
  /// In en, this message translates to:
  /// **'Tap Widgets, then scroll to SolgoInsight Status Monitor'**
  String get pageWidgetStepTapWidgets;

  /// No description provided for @pageWidgetStepDragTemplate.
  ///
  /// In en, this message translates to:
  /// **'Drag one status template onto the screen'**
  String get pageWidgetStepDragTemplate;

  /// No description provided for @pageStatusDataNotReady.
  ///
  /// In en, this message translates to:
  /// **'Status data is not ready yet. Open Status Monitor after configuring a data source.'**
  String get pageStatusDataNotReady;

  /// No description provided for @pageSamplesRecorded.
  ///
  /// In en, this message translates to:
  /// **'{percent}% samples recorded'**
  String pageSamplesRecorded(Object percent);

  /// No description provided for @pageDailySummary7Days.
  ///
  /// In en, this message translates to:
  /// **'Daily summary - 7 days'**
  String get pageDailySummary7Days;

  /// No description provided for @pageHourlyDetail.
  ///
  /// In en, this message translates to:
  /// **'Hourly detail'**
  String get pageHourlyDetail;

  /// No description provided for @pageHistoryScopeNote.
  ///
  /// In en, this message translates to:
  /// **'History is scoped to the current subject and data source. It records component snapshots from Status Monitor refreshes; Unknown means there was not enough recorded sample data for that hour.'**
  String get pageHistoryScopeNote;

  /// No description provided for @pageHistoryLoadingComponent.
  ///
  /// In en, this message translates to:
  /// **'Loading history for this component...'**
  String get pageHistoryLoadingComponent;

  /// No description provided for @pageHistoryNoComponentData.
  ///
  /// In en, this message translates to:
  /// **'No recorded history for this component yet.'**
  String get pageHistoryNoComponentData;

  /// No description provided for @pageHistoryComponentFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this component history.'**
  String get pageHistoryComponentFailed;

  /// No description provided for @pageHistoryReasonRecordedSample.
  ///
  /// In en, this message translates to:
  /// **'Recorded sample'**
  String get pageHistoryReasonRecordedSample;

  /// No description provided for @pageHistoryReasonCarriedForward.
  ///
  /// In en, this message translates to:
  /// **'Carried forward'**
  String get pageHistoryReasonCarriedForward;

  /// No description provided for @pageHistoryReasonNoSample.
  ///
  /// In en, this message translates to:
  /// **'No sample'**
  String get pageHistoryReasonNoSample;

  /// No description provided for @pageHistoryReasonFuture.
  ///
  /// In en, this message translates to:
  /// **'Future hour'**
  String get pageHistoryReasonFuture;

  /// No description provided for @pageDashboardNavDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get pageDashboardNavDashboard;

  /// No description provided for @pageDashboardNavHub.
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get pageDashboardNavHub;

  /// No description provided for @pageDashboardNavChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get pageDashboardNavChecklist;
}

class _StatusMonitorLocalizationsDelegate
    extends LocalizationsDelegate<StatusMonitorLocalizations> {
  const _StatusMonitorLocalizationsDelegate();

  @override
  Future<StatusMonitorLocalizations> load(Locale locale) {
    return SynchronousFuture<StatusMonitorLocalizations>(
        lookupStatusMonitorLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_StatusMonitorLocalizationsDelegate old) => false;
}

StatusMonitorLocalizations lookupStatusMonitorLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return StatusMonitorLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return StatusMonitorLocalizationsEn();
    case 'zh':
      return StatusMonitorLocalizationsZh();
  }

  throw FlutterError(
      'StatusMonitorLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

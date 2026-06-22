import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'alerting_localizations_en.dart';
import 'alerting_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AlertingLocalizations
/// returned by `AlertingLocalizations.of(context)`.
///
/// Applications need to include `AlertingLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/alerting_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AlertingLocalizations.localizationsDelegates,
///   supportedLocales: AlertingLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AlertingLocalizations.supportedLocales
/// property.
abstract class AlertingLocalizations {
  AlertingLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AlertingLocalizations of(BuildContext context) {
    return Localizations.of<AlertingLocalizations>(context, AlertingLocalizations)!;
  }

  static const LocalizationsDelegate<AlertingLocalizations> delegate = _AlertingLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @alertingTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert Settings'**
  String get alertingTitle;

  /// No description provided for @alertingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure notification, sound, vibration, and in-app behavior.'**
  String get alertingSubtitle;

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerting'**
  String get pluginTitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Configurable alert delivery strategies.'**
  String get pluginDescription;

  /// No description provided for @settingsEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sound, vibration, notification strategies'**
  String get settingsEntrySubtitle;

  /// No description provided for @alertSystemSection.
  ///
  /// In en, this message translates to:
  /// **'Alert System'**
  String get alertSystemSection;

  /// No description provided for @deliveryStrategiesSection.
  ///
  /// In en, this message translates to:
  /// **'Delivery Strategies'**
  String get deliveryStrategiesSection;

  /// No description provided for @enableAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable alerts'**
  String get enableAlertsTitle;

  /// No description provided for @enableAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Master switch for glucose safety alerts and future alert sources.'**
  String get enableAlertsSubtitle;

  /// No description provided for @criticalOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Critical only'**
  String get criticalOnlyTitle;

  /// No description provided for @criticalOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only urgent events can trigger delivery strategies.'**
  String get criticalOnlySubtitle;

  /// No description provided for @detailCriticalOnly.
  ///
  /// In en, this message translates to:
  /// **'Critical only'**
  String get detailCriticalOnly;

  /// No description provided for @detailAllSeverities.
  ///
  /// In en, this message translates to:
  /// **'All severities'**
  String get detailAllSeverities;

  /// No description provided for @inAppAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app alert'**
  String get inAppAlertTitle;

  /// No description provided for @inAppAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a visible alert card while the app is open.'**
  String get inAppAlertSubtitle;

  /// No description provided for @detailCriticalFullScreenReady.
  ///
  /// In en, this message translates to:
  /// **'Critical full screen ready'**
  String get detailCriticalFullScreenReady;

  /// No description provided for @detailCompactMode.
  ///
  /// In en, this message translates to:
  /// **'Compact mode'**
  String get detailCompactMode;

  /// No description provided for @systemNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'System notification'**
  String get systemNotificationTitle;

  /// No description provided for @systemNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the operating system notification channel.'**
  String get systemNotificationSubtitle;

  /// No description provided for @detailHighPriorityChannel.
  ///
  /// In en, this message translates to:
  /// **'High priority channel'**
  String get detailHighPriorityChannel;

  /// No description provided for @soundAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound alert'**
  String get soundAlertTitle;

  /// No description provided for @soundAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose system, built-in, custom, or silent sound behavior.'**
  String get soundAlertSubtitle;

  /// No description provided for @soundMaxDuration.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s max'**
  String soundMaxDuration(int seconds);

  /// No description provided for @detailRepeatCritical.
  ///
  /// In en, this message translates to:
  /// **'Repeat critical'**
  String get detailRepeatCritical;

  /// No description provided for @detailSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get detailSingle;

  /// No description provided for @vibrationAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration alert'**
  String get vibrationAlertTitle;

  /// No description provided for @vibrationAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use vibration patterns for warning and critical events.'**
  String get vibrationAlertSubtitle;

  /// No description provided for @vibrationCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical: {label}'**
  String vibrationCritical(String label);

  /// No description provided for @vibrationWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: {label}'**
  String vibrationWarning(String label);

  /// No description provided for @configureTooltip.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configureTooltip;

  /// No description provided for @alertSettingsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert Settings'**
  String get alertSettingsEntryTitle;

  /// No description provided for @alertSettingsEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sound, vibration, notifications, and in-app alert behavior'**
  String get alertSettingsEntrySubtitle;

  /// No description provided for @alertRuntimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert runtime'**
  String get alertRuntimeTitle;

  /// No description provided for @runtimeAndroidHelperAlerts.
  ///
  /// In en, this message translates to:
  /// **'Android alerts can run through the foreground service, but SolgoInsight still treats them as helper alerts.'**
  String get runtimeAndroidHelperAlerts;

  /// No description provided for @runtimeIosBestEffort.
  ///
  /// In en, this message translates to:
  /// **'iOS can evaluate helper alerts during best-effort background refresh when the system allows it. It is not real-time.'**
  String get runtimeIosBestEffort;

  /// No description provided for @runtimePlatformLimited.
  ///
  /// In en, this message translates to:
  /// **'This platform does not provide reliable background alerts.'**
  String get runtimePlatformLimited;

  /// No description provided for @runtimeForegroundAlerts.
  ///
  /// In en, this message translates to:
  /// **'Foreground alerts'**
  String get runtimeForegroundAlerts;

  /// No description provided for @runtimeForegroundOff.
  ///
  /// In en, this message translates to:
  /// **'Foreground off'**
  String get runtimeForegroundOff;

  /// No description provided for @runtimeBackgroundEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Background evaluation'**
  String get runtimeBackgroundEvaluation;

  /// No description provided for @runtimeBackgroundLimited.
  ///
  /// In en, this message translates to:
  /// **'Background limited'**
  String get runtimeBackgroundLimited;

  /// No description provided for @runtimeRealtimeGuaranteed.
  ///
  /// In en, this message translates to:
  /// **'Realtime guaranteed'**
  String get runtimeRealtimeGuaranteed;

  /// No description provided for @runtimeNoRealtimeGuarantee.
  ///
  /// In en, this message translates to:
  /// **'No realtime guarantee'**
  String get runtimeNoRealtimeGuarantee;

  /// No description provided for @chooseSoundSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose sound source'**
  String get chooseSoundSourceTitle;

  /// No description provided for @chooseSoundSourceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The selected sound is saved globally and used whenever an alert rule requests Sound.'**
  String get chooseSoundSourceSubtitle;

  /// No description provided for @builtInSoundsSection.
  ///
  /// In en, this message translates to:
  /// **'Built-in sounds'**
  String get builtInSoundsSection;

  /// No description provided for @quietSection.
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get quietSection;

  /// No description provided for @customSection.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customSection;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @chooseAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Choose audio file'**
  String get chooseAudioFile;

  /// No description provided for @previewingSound.
  ///
  /// In en, this message translates to:
  /// **'Previewing {name}'**
  String previewingSound(String name);

  /// No description provided for @couldNotPreviewSound.
  ///
  /// In en, this message translates to:
  /// **'Could not preview this sound'**
  String get couldNotPreviewSound;

  /// No description provided for @couldNotImportAudioTrySmaller.
  ///
  /// In en, this message translates to:
  /// **'Could not import this audio file. Try a smaller local file.'**
  String get couldNotImportAudioTrySmaller;

  /// No description provided for @couldNotImportAudio.
  ///
  /// In en, this message translates to:
  /// **'Could not import this audio file'**
  String get couldNotImportAudio;

  /// No description provided for @soundSubtitleAsset.
  ///
  /// In en, this message translates to:
  /// **'Bundled with SolgoInsight'**
  String get soundSubtitleAsset;

  /// No description provided for @soundSubtitleFile.
  ///
  /// In en, this message translates to:
  /// **'Imported into app private storage'**
  String get soundSubtitleFile;

  /// No description provided for @soundSubtitleSilent.
  ///
  /// In en, this message translates to:
  /// **'Sound channel stays silent'**
  String get soundSubtitleSilent;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playing;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @soundSteadyPing.
  ///
  /// In en, this message translates to:
  /// **'Steady ping'**
  String get soundSteadyPing;

  /// No description provided for @soundUrgentPulse.
  ///
  /// In en, this message translates to:
  /// **'Urgent pulse'**
  String get soundUrgentPulse;

  /// No description provided for @soundGentleChime.
  ///
  /// In en, this message translates to:
  /// **'Gentle chime'**
  String get soundGentleChime;

  /// No description provided for @soundSoftBell.
  ///
  /// In en, this message translates to:
  /// **'Soft bell'**
  String get soundSoftBell;

  /// No description provided for @soundSilent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get soundSilent;

  /// No description provided for @soundBuiltInFallback.
  ///
  /// In en, this message translates to:
  /// **'Built-in alert sound'**
  String get soundBuiltInFallback;

  /// No description provided for @vibrationCriticalRepeat.
  ///
  /// In en, this message translates to:
  /// **'Critical repeat'**
  String get vibrationCriticalRepeat;

  /// No description provided for @vibrationShortWarning.
  ///
  /// In en, this message translates to:
  /// **'Short warning'**
  String get vibrationShortWarning;

  /// No description provided for @alertActionSnooze5m.
  ///
  /// In en, this message translates to:
  /// **'Snooze 5m'**
  String get alertActionSnooze5m;

  /// No description provided for @alertActionDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get alertActionDismiss;

  /// No description provided for @alertActionStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get alertActionStop;

  /// No description provided for @alertSubjectCurrentGlucose.
  ///
  /// In en, this message translates to:
  /// **'current glucose'**
  String get alertSubjectCurrentGlucose;

  /// No description provided for @alertSubjectGlucose.
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get alertSubjectGlucose;

  /// No description provided for @alertSubjectGlucoseData.
  ///
  /// In en, this message translates to:
  /// **'Glucose data'**
  String get alertSubjectGlucoseData;

  /// No description provided for @alertTitleUrgentLowGlucose.
  ///
  /// In en, this message translates to:
  /// **'Urgent low glucose'**
  String get alertTitleUrgentLowGlucose;

  /// No description provided for @alertTitleLowGlucose.
  ///
  /// In en, this message translates to:
  /// **'Low glucose'**
  String get alertTitleLowGlucose;

  /// No description provided for @alertTitleHighGlucose.
  ///
  /// In en, this message translates to:
  /// **'High glucose'**
  String get alertTitleHighGlucose;

  /// No description provided for @alertTitleGlucoseAlert.
  ///
  /// In en, this message translates to:
  /// **'Glucose alert'**
  String get alertTitleGlucoseAlert;

  /// No description provided for @alertBodyGlucoseValue.
  ///
  /// In en, this message translates to:
  /// **'{subject} is {value}.'**
  String alertBodyGlucoseValue(String subject, String value);

  /// No description provided for @alertTitleRapidFall.
  ///
  /// In en, this message translates to:
  /// **'Rapid fall'**
  String get alertTitleRapidFall;

  /// No description provided for @alertBodyRapidFall.
  ///
  /// In en, this message translates to:
  /// **'{subject} is falling quickly.'**
  String alertBodyRapidFall(String subject);

  /// No description provided for @alertBodyRapidFallWithRate.
  ///
  /// In en, this message translates to:
  /// **'{subject} is falling quickly ({rate}).'**
  String alertBodyRapidFallWithRate(String subject, String rate);

  /// No description provided for @alertTitleNoRecentGlucoseData.
  ///
  /// In en, this message translates to:
  /// **'No recent glucose data'**
  String get alertTitleNoRecentGlucoseData;

  /// No description provided for @alertBodyNoRecentGlucoseData.
  ///
  /// In en, this message translates to:
  /// **'{subject} has not updated recently.'**
  String alertBodyNoRecentGlucoseData(String subject);

  /// No description provided for @alertFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alertFallbackTitle;

  /// No description provided for @alertFallbackBody.
  ///
  /// In en, this message translates to:
  /// **'A new alert was received.'**
  String get alertFallbackBody;
}

class _AlertingLocalizationsDelegate extends LocalizationsDelegate<AlertingLocalizations> {
  const _AlertingLocalizationsDelegate();

  @override
  Future<AlertingLocalizations> load(Locale locale) {
    return SynchronousFuture<AlertingLocalizations>(lookupAlertingLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AlertingLocalizationsDelegate old) => false;
}

AlertingLocalizations lookupAlertingLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AlertingLocalizationsEn();
    case 'zh': return AlertingLocalizationsZh();
  }

  throw FlutterError(
    'AlertingLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

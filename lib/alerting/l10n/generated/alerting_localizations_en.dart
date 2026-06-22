// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'alerting_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AlertingLocalizationsEn extends AlertingLocalizations {
  AlertingLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get alertingTitle => 'Alert Settings';

  @override
  String get alertingSubtitle => 'Configure notification, sound, vibration, and in-app behavior.';

  @override
  String get pluginTitle => 'Alerting';

  @override
  String get pluginDescription => 'Configurable alert delivery strategies.';

  @override
  String get settingsEntrySubtitle => 'Sound, vibration, notification strategies';

  @override
  String get alertSystemSection => 'Alert System';

  @override
  String get deliveryStrategiesSection => 'Delivery Strategies';

  @override
  String get enableAlertsTitle => 'Enable alerts';

  @override
  String get enableAlertsSubtitle => 'Master switch for glucose safety alerts and future alert sources.';

  @override
  String get criticalOnlyTitle => 'Critical only';

  @override
  String get criticalOnlySubtitle => 'Only urgent events can trigger delivery strategies.';

  @override
  String get detailCriticalOnly => 'Critical only';

  @override
  String get detailAllSeverities => 'All severities';

  @override
  String get inAppAlertTitle => 'In-app alert';

  @override
  String get inAppAlertSubtitle => 'Show a visible alert card while the app is open.';

  @override
  String get detailCriticalFullScreenReady => 'Critical full screen ready';

  @override
  String get detailCompactMode => 'Compact mode';

  @override
  String get systemNotificationTitle => 'System notification';

  @override
  String get systemNotificationSubtitle => 'Use the operating system notification channel.';

  @override
  String get detailHighPriorityChannel => 'High priority channel';

  @override
  String get soundAlertTitle => 'Sound alert';

  @override
  String get soundAlertSubtitle => 'Choose system, built-in, custom, or silent sound behavior.';

  @override
  String soundMaxDuration(int seconds) {
    return '${seconds}s max';
  }

  @override
  String get detailRepeatCritical => 'Repeat critical';

  @override
  String get detailSingle => 'Single';

  @override
  String get vibrationAlertTitle => 'Vibration alert';

  @override
  String get vibrationAlertSubtitle => 'Use vibration patterns for warning and critical events.';

  @override
  String vibrationCritical(String label) {
    return 'Critical: $label';
  }

  @override
  String vibrationWarning(String label) {
    return 'Warning: $label';
  }

  @override
  String get configureTooltip => 'Configure';

  @override
  String get alertSettingsEntryTitle => 'Alert Settings';

  @override
  String get alertSettingsEntrySubtitle => 'Sound, vibration, notifications, and in-app alert behavior';

  @override
  String get alertRuntimeTitle => 'Alert runtime';

  @override
  String get runtimeAndroidHelperAlerts => 'Android alerts can run through the foreground service, but SolgoInsight still treats them as helper alerts.';

  @override
  String get runtimeIosBestEffort => 'iOS can evaluate helper alerts during best-effort background refresh when the system allows it. It is not real-time.';

  @override
  String get runtimePlatformLimited => 'This platform does not provide reliable background alerts.';

  @override
  String get runtimeForegroundAlerts => 'Foreground alerts';

  @override
  String get runtimeForegroundOff => 'Foreground off';

  @override
  String get runtimeBackgroundEvaluation => 'Background evaluation';

  @override
  String get runtimeBackgroundLimited => 'Background limited';

  @override
  String get runtimeRealtimeGuaranteed => 'Realtime guaranteed';

  @override
  String get runtimeNoRealtimeGuarantee => 'No realtime guarantee';

  @override
  String get chooseSoundSourceTitle => 'Choose sound source';

  @override
  String get chooseSoundSourceSubtitle => 'The selected sound is saved globally and used whenever an alert rule requests Sound.';

  @override
  String get builtInSoundsSection => 'Built-in sounds';

  @override
  String get quietSection => 'Quiet';

  @override
  String get customSection => 'Custom';

  @override
  String get importing => 'Importing...';

  @override
  String get chooseAudioFile => 'Choose audio file';

  @override
  String previewingSound(String name) {
    return 'Previewing $name';
  }

  @override
  String get couldNotPreviewSound => 'Could not preview this sound';

  @override
  String get couldNotImportAudioTrySmaller => 'Could not import this audio file. Try a smaller local file.';

  @override
  String get couldNotImportAudio => 'Could not import this audio file';

  @override
  String get soundSubtitleAsset => 'Bundled with SolgoInsight';

  @override
  String get soundSubtitleFile => 'Imported into app private storage';

  @override
  String get soundSubtitleSilent => 'Sound channel stays silent';

  @override
  String get playing => 'Playing';

  @override
  String get preview => 'Preview';

  @override
  String get select => 'Select';

  @override
  String get soundSteadyPing => 'Steady ping';

  @override
  String get soundUrgentPulse => 'Urgent pulse';

  @override
  String get soundGentleChime => 'Gentle chime';

  @override
  String get soundSoftBell => 'Soft bell';

  @override
  String get soundSilent => 'Silent';

  @override
  String get soundBuiltInFallback => 'Built-in alert sound';

  @override
  String get vibrationCriticalRepeat => 'Critical repeat';

  @override
  String get vibrationShortWarning => 'Short warning';

  @override
  String get alertActionSnooze5m => 'Snooze 5m';

  @override
  String get alertActionDismiss => 'Dismiss';

  @override
  String get alertActionStop => 'Stop';

  @override
  String get alertSubjectCurrentGlucose => 'current glucose';

  @override
  String get alertSubjectGlucose => 'Glucose';

  @override
  String get alertSubjectGlucoseData => 'Glucose data';

  @override
  String get alertTitleUrgentLowGlucose => 'Urgent low glucose';

  @override
  String get alertTitleLowGlucose => 'Low glucose';

  @override
  String get alertTitleHighGlucose => 'High glucose';

  @override
  String get alertTitleGlucoseAlert => 'Glucose alert';

  @override
  String alertBodyGlucoseValue(String subject, String value) {
    return '$subject is $value.';
  }

  @override
  String get alertTitleRapidFall => 'Rapid fall';

  @override
  String alertBodyRapidFall(String subject) {
    return '$subject is falling quickly.';
  }

  @override
  String alertBodyRapidFallWithRate(String subject, String rate) {
    return '$subject is falling quickly ($rate).';
  }

  @override
  String get alertTitleNoRecentGlucoseData => 'No recent glucose data';

  @override
  String alertBodyNoRecentGlucoseData(String subject) {
    return '$subject has not updated recently.';
  }

  @override
  String get alertFallbackTitle => 'Alert';

  @override
  String get alertFallbackBody => 'A new alert was received.';
}

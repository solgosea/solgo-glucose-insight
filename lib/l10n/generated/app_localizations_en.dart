// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SolgoInsight';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDone => 'Done';

  @override
  String get commonBack => 'Back';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonShare => 'Share';

  @override
  String get commonPrint => 'Print';

  @override
  String get commonExportPdf => 'Export PDF';

  @override
  String get commonNoData => 'No data';

  @override
  String get commonUnavailable => 'Unavailable';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Display, sync window, storage, and export preferences.';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageDescription => 'App display language';

  @override
  String get settingsLanguageSystem => 'Follow system';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSimplifiedChinese => 'Simplified Chinese';

  @override
  String get settingsLanguageTraditionalChinese => 'Traditional Chinese';

  @override
  String get settingsLanguageChanged => 'Language updated.';

  @override
  String get settingsBloodGlucoseUnit => 'Blood glucose unit';

  @override
  String get settingsInitialSyncWindow => 'Initial sync window';

  @override
  String get settingsRecommendedBalance => 'Recommended balance';

  @override
  String get settingsExportData => 'Export data';

  @override
  String get settingsClearAllData => 'Clear all data';

  @override
  String get timeJustNow => 'just now';

  @override
  String get timeNever => 'never';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String timeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String durationSecondsShort(int seconds) {
    return '${seconds}s';
  }

  @override
  String durationMinutesShort(int minutes) {
    return '${minutes}m';
  }

  @override
  String durationHoursShort(int hours) {
    return '${hours}h';
  }

  @override
  String durationHoursMinutesShort(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String get dayPeriodDawn => 'dawn';

  @override
  String get dayPeriodMorning => 'morning';

  @override
  String get dayPeriodAfternoon => 'afternoon';

  @override
  String get dayPeriodEvening => 'evening';

  @override
  String get dayPeriodNight => 'night';

  @override
  String relativeDayPeriodToday(Object period) {
    return 'today $period';
  }

  @override
  String relativeDayPeriodYesterday(Object period) {
    return 'yesterday $period';
  }

  @override
  String relativeDayPeriodTomorrow(Object period) {
    return 'tomorrow $period';
  }

  @override
  String get syncNotSyncing => 'Not syncing';

  @override
  String get syncWaiting => 'waiting';

  @override
  String get syncNotConfigured => 'Not configured';

  @override
  String get syncConfiguredNotSyncing => 'Configured, not syncing';

  @override
  String get syncWaitingFirstSync => 'Waiting for first sync';

  @override
  String syncSynced(Object relative) {
    return 'Synced $relative';
  }

  @override
  String syncLastSynced(Object relative) {
    return 'Last synced $relative';
  }

  @override
  String get syncFailed => 'failed';

  @override
  String get syncLastFailed => 'Last sync failed';

  @override
  String get syncSchedulePending => 'Schedule pending';

  @override
  String get syncPaused => 'Sync paused';

  @override
  String get syncWaitingSchedule => 'Waiting for schedule';

  @override
  String get syncDue => 'Sync due';

  @override
  String syncNext(Object duration) {
    return 'Next $duration';
  }

  @override
  String syncEstimatedNext(Object duration) {
    return 'Est. next $duration';
  }

  @override
  String syncForegroundRefresh(Object relative) {
    return 'Foreground refresh $relative';
  }

  @override
  String syncNewCount(int count) {
    return '$count new';
  }

  @override
  String get syncTitleLive => 'Live sync active';

  @override
  String get syncTitleWarming => 'Sync warming up';

  @override
  String get syncTitleNeedsAttention => 'Sync needs attention';

  @override
  String get syncTitleInterrupted => 'Sync interrupted';

  @override
  String get syncTitleDisabled => 'Sync disabled';

  @override
  String get syncDetailCollectingFirstSamples => 'Collecting the first glucose samples for this source.';
}

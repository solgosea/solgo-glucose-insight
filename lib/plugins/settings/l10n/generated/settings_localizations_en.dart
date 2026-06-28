// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'settings_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SettingsLocalizationsEn extends SettingsLocalizations {
  SettingsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsDangerDescription => 'Destructive local data actions.';

  @override
  String get settingsDisplaySubtitle => 'Units and presentation preferences';

  @override
  String get settingsDisplayTitle => 'Display';

  @override
  String get settingsDangerTitle => 'Danger Zone';

  @override
  String get settingsExportTitle => 'Data Export';

  @override
  String get settingsAboutDescription =>
      'Application metadata and support links.';

  @override
  String get settingsStorageSubtitle => 'Local data storage summary';

  @override
  String get settingsDangerSubtitle => 'Destructive local data actions';

  @override
  String get settingsSyncSubtitle => 'Sync window and source preferences';

  @override
  String get settingsExportSubtitle => 'Export local glucose data';

  @override
  String get settingsExportDescription => 'Export local glucose data.';

  @override
  String get settingsSyncTitle => 'Sync Settings';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsDisplayDescription =>
      'Display preferences for glucose units.';

  @override
  String get settingsStorageTitle => 'Data Storage';

  @override
  String get settingsAboutSubtitle => 'App information and support links';

  @override
  String get settingsStorageDescription =>
      'Local glucose data storage summary.';

  @override
  String get settingsSyncDescription =>
      'Sync window and source sync preferences.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get pluginReportTitle => 'Settings Report';

  @override
  String get pluginSubtitle =>
      'Display, sync, storage, export, and safety settings.';

  @override
  String get pluginTitle => 'Settings';

  @override
  String get pluginDescription =>
      'Display, sync, storage, export, and safety settings.';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get settingsExportNoReadings => 'No readings to export yet.';

  @override
  String get settingsAllLocalDataCleared => 'All local data cleared.';

  @override
  String get settingsUnitsLabel => 'Units';

  @override
  String get settingsDeleteEverything => 'Delete everything';

  @override
  String get settingsClearAllDataTitle => 'Clear all data';

  @override
  String get settingsRetentionPeriodLabel => 'Retention period';

  @override
  String get settingsDaysSuffix => 'days';

  @override
  String get settingsInitialSyncWindowLabel => 'Initial sync window';

  @override
  String get settingsSyncWindowLabel => 'Sync window';

  @override
  String get settingsSyncWindowSubtitle => 'History range and sync interval';

  @override
  String settingsSyncWindowValue(int days, int minutes) {
    return '$days days · every $minutes min';
  }

  @override
  String get settingsSyncWindowSheetTitle => 'Sync window';

  @override
  String get settingsSyncWindowSheetSubtitle =>
      'Choose how much history to load, then how often SolgoInsight checks for new readings.';

  @override
  String get settingsSyncPlanLabel => 'SYNC PLAN';

  @override
  String get settingsHistoryRangeLabel => 'History range';

  @override
  String settingsHistoryRangeValue(int days) {
    return '$days days';
  }

  @override
  String get settingsSyncIntervalLabel => 'Sync interval';

  @override
  String settingsSyncIntervalValue(int minutes) {
    return 'Every $minutes min';
  }

  @override
  String settingsDaysShort(int days) {
    return '${days}d';
  }

  @override
  String settingsMinutesShort(int minutes) {
    return '${minutes}m';
  }

  @override
  String get settingsSyncPreviewTitle => 'What happens next';

  @override
  String settingsSyncPreviewBody(int days, int minutes) {
    return 'Initial sync loads up to $days days. After that, new readings are checked about every $minutes minute(s) when sync is active.';
  }

  @override
  String get settingsSaveSyncWindow => 'Save';

  @override
  String get settingsRetentionSummarySuffix => 'No data leaves this device';

  @override
  String get settingsClearAllDataDialogTitle => 'Clear all data?';

  @override
  String get settingsDaysMax => 'days max';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsRecommendedBalance => 'Recommended balance';

  @override
  String get settingsDaysCovered => 'days';

  @override
  String get settingsInitialSyncWindowSubtitle =>
      'Used when connecting a new source';

  @override
  String get settingsOpenSourceLink => 'Open source';

  @override
  String get settingsStorageUsed => 'used';

  @override
  String get settingsBloodGlucoseUnitSubtitle => 'Blood glucose unit';

  @override
  String get settingsRetentionPeriodSubtitle => 'Auto-trims older readings';

  @override
  String get settingsPrivacyLink => 'Privacy';

  @override
  String get settingsRetentionSummaryPrefix => 'Data retention:';

  @override
  String get settingsExportDataLabel => 'Export data';

  @override
  String get settingsClearAllDataSubtitle =>
      'Permanently removes all stored readings';

  @override
  String get settingsExportDataSubtitle => 'Save readings as CSV';

  @override
  String get settingsExportedTo => 'Exported to:';

  @override
  String get settingsLocalStorageTitle => 'Local storage';

  @override
  String get settingsClearAllDataDialogBody =>
      'This permanently deletes all stored CGM readings, events, and analysis snapshots. This cannot be undone.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ProfileLocalizationsEn extends ProfileLocalizations {
  ProfileLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get targetRangeTitle => 'Target Range';

  @override
  String get targetRangeDescription =>
      'Personal glucose target range thresholds.';

  @override
  String get targetRangeSubtitle => 'Personal glucose targets';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get pluginReportTitle => 'Profile Report';

  @override
  String get pluginSubtitle =>
      'Profile, data source, target range, and settings.';

  @override
  String get pluginTitle => 'Profile';

  @override
  String get pluginDescription =>
      'Profile, data source, target range, and settings.';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get targetRangeVeryHighThresholdSubtitle =>
      'Marked as urgent high zone';

  @override
  String get targetRangePrimaryBandLabel => 'Target range';

  @override
  String get targetRangeHighThresholdSubtitle => 'Above this enters high range';

  @override
  String get targetRangeUpdated => 'Target range updated';

  @override
  String get targetRangeInRangeTarget => 'IN-RANGE TARGET';

  @override
  String get targetRangeHighThresholdLabel => 'High threshold';

  @override
  String get targetRangePrimaryBandSubtitle => 'Primary glucose band';

  @override
  String get targetRangeHighLabel => 'HIGH';

  @override
  String get targetRangeDragHint => 'Drag a handle, or type below';

  @override
  String get targetRangeVeryHighLabel => 'VERY HIGH';

  @override
  String get targetRangeExactValues => 'EXACT VALUES';

  @override
  String get targetRangeSheetTitle => 'Target Range';

  @override
  String get targetRangeVeryHighThresholdLabel => 'Very high threshold';

  @override
  String get targetRangeLowThresholdLabel => 'Low threshold';

  @override
  String get targetRangeLowThresholdSubtitle => 'Below this enters low range';

  @override
  String get targetRangeCancel => 'Cancel';

  @override
  String get targetRangeLowLabel => 'LOW';

  @override
  String get targetRangeSaveRange => 'Save range';

  @override
  String get targetRangeSpread => 'spread';

  @override
  String get targetRangeReset => 'Reset';

  @override
  String get targetRangeSheetSubtitle =>
      'Drag the markers or type exact values. Both stay in sync.';

  @override
  String get profileHeaderTitle => 'My Profile';

  @override
  String profileDaysRecorded(int days) {
    return '$days days recorded';
  }

  @override
  String get profileStatTir14d => 'TIR 14d';

  @override
  String get profileStatAvg14d => 'Avg 14d';

  @override
  String get profileStatCv14d => 'CV 14d';

  @override
  String get profileSettingsSummary => 'Settings';

  @override
  String get profileSectionAppSettings => 'App Settings';

  @override
  String targetRangeLowHighGapMessage(String gap, String unit) {
    return 'Low must be at least $gap $unit below High.';
  }

  @override
  String targetRangeHighVeryHighGapMessage(String gap, String unit) {
    return 'High must be at least $gap $unit below Very High.';
  }
}

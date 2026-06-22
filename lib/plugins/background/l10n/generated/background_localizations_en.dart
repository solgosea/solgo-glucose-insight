// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'background_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BackgroundLocalizationsEn extends BackgroundLocalizations {
  BackgroundLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get glucoseSyncSubtitle => 'Sync active glucose source';

  @override
  String get sourceHealthSubtitle => 'Validate active data source availability.';

  @override
  String get sourceHealthTitle => 'Source Health Check';

  @override
  String get glucoseSyncTitle => 'Glucose Sync';

  @override
  String get glucoseSyncDescription => 'Synchronizes glucose readings from active source.';

  @override
  String get sourceHealthDescription => 'Checks the active xDrip or Nightscout source reachability.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get pluginReportTitle => 'Background Report';

  @override
  String get pluginSubtitle => 'Background glucose sync and source health tasks.';

  @override
  String get pluginTitle => 'Background Tasks';

  @override
  String get pluginDescription => 'Background glucose sync and source health tasks.';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginLoading => 'Loading';
}

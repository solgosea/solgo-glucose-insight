// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'datasource_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class DatasourceLocalizationsEn extends DatasourceLocalizations {
  DatasourceLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Data Source';

  @override
  String get pluginSubtitle => 'Configure xDrip+ Local and Nightscout sources.';

  @override
  String get pluginDescription =>
      'Configure xDrip+ Local and Nightscout sources.';

  @override
  String get pluginReportTitle => 'Data Source Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get nightscoutUpdateConnection => 'Update connection';

  @override
  String get nightscoutApiTitle => 'Nightscout API';

  @override
  String get nightscoutUpdateSubtitle =>
      'Update your site URL or access token below.';

  @override
  String get nightscoutSetupSubtitle =>
      'Enter your Nightscout site URL and optional access token.';

  @override
  String get nightscoutSiteUrl => 'Site URL';

  @override
  String get nightscoutUrlHint => 'https://your-site.herokuapp.com';

  @override
  String get nightscoutAccessToken => 'Access token';

  @override
  String get nightscoutOptional => 'Optional';

  @override
  String get nightscoutTesting => 'Testing...';

  @override
  String get nightscoutTestAndConnect => 'Test and connect';

  @override
  String get nightscoutEnterUrl => 'Enter a Nightscout URL to continue';

  @override
  String get nightscoutTestingConnection => 'Testing connection...';

  @override
  String get nightscoutConnectedSyncing => 'Connected, syncing now';
}

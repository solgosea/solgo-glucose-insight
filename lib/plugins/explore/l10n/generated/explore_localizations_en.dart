// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'explore_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ExploreLocalizationsEn extends ExploreLocalizations {
  ExploreLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Explore';

  @override
  String get pluginSubtitle => 'Review glucose patterns with focused tools.';

  @override
  String get pluginDescription => 'Review glucose patterns with focused tools.';

  @override
  String get pluginReportTitle => 'Explore Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get featuredPlugins => 'FEATURED PLUGINS';

  @override
  String get featuredReportEyebrow => 'REPORT';

  @override
  String get featuredReportBadge => 'FREE';

  @override
  String get featuredReportTitle => 'Doctor-ready glucose report';

  @override
  String get featuredReportBody =>
      'AGP standard PDF. Export & share in seconds.';

  @override
  String get runtimeNoData => 'No data';

  @override
  String get runtimeNoSource => 'No source';

  @override
  String get runtimeDisabled => 'Disabled';

  @override
  String get runtimeHidden => 'Hidden';

  @override
  String get runtimeUnavailable => 'Unavailable';

  @override
  String get sectionTimePatterns => 'TIME PATTERNS';

  @override
  String get sectionGlucoseProfile => 'GLUCOSE PROFILE';

  @override
  String get sectionEpisodes => 'EPISODES';

  @override
  String get sectionConnectedCare => 'CONNECTED CARE';

  @override
  String get sectionSystemStatus => 'SYSTEM STATUS';
}

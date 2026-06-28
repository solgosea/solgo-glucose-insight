import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'explore_localizations_en.dart';
import 'explore_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ExploreLocalizations
/// returned by `ExploreLocalizations.of(context)`.
///
/// Applications need to include `ExploreLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/explore_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ExploreLocalizations.localizationsDelegates,
///   supportedLocales: ExploreLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ExploreLocalizations.supportedLocales
/// property.
abstract class ExploreLocalizations {
  ExploreLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ExploreLocalizations of(BuildContext context) {
    return Localizations.of<ExploreLocalizations>(
        context, ExploreLocalizations)!;
  }

  static const LocalizationsDelegate<ExploreLocalizations> delegate =
      _ExploreLocalizationsDelegate();

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
  /// **'Explore'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review glucose patterns with focused tools.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Review glucose patterns with focused tools.'**
  String get pluginDescription;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Report'**
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

  /// No description provided for @featuredPlugins.
  ///
  /// In en, this message translates to:
  /// **'FEATURED PLUGINS'**
  String get featuredPlugins;

  /// No description provided for @featuredReportEyebrow.
  ///
  /// In en, this message translates to:
  /// **'REPORT'**
  String get featuredReportEyebrow;

  /// No description provided for @featuredReportBadge.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get featuredReportBadge;

  /// No description provided for @featuredReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor-ready glucose report'**
  String get featuredReportTitle;

  /// No description provided for @featuredReportBody.
  ///
  /// In en, this message translates to:
  /// **'AGP standard PDF. Export & share in seconds.'**
  String get featuredReportBody;

  /// No description provided for @runtimeNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get runtimeNoData;

  /// No description provided for @runtimeNoSource.
  ///
  /// In en, this message translates to:
  /// **'No source'**
  String get runtimeNoSource;

  /// No description provided for @runtimeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get runtimeDisabled;

  /// No description provided for @runtimeHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get runtimeHidden;

  /// No description provided for @runtimeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get runtimeUnavailable;

  /// No description provided for @sectionTimePatterns.
  ///
  /// In en, this message translates to:
  /// **'TIME PATTERNS'**
  String get sectionTimePatterns;

  /// No description provided for @sectionGlucoseProfile.
  ///
  /// In en, this message translates to:
  /// **'GLUCOSE PROFILE'**
  String get sectionGlucoseProfile;

  /// No description provided for @sectionEpisodes.
  ///
  /// In en, this message translates to:
  /// **'EPISODES'**
  String get sectionEpisodes;

  /// No description provided for @sectionConnectedCare.
  ///
  /// In en, this message translates to:
  /// **'CONNECTED CARE'**
  String get sectionConnectedCare;

  /// No description provided for @sectionSystemStatus.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM STATUS'**
  String get sectionSystemStatus;
}

class _ExploreLocalizationsDelegate
    extends LocalizationsDelegate<ExploreLocalizations> {
  const _ExploreLocalizationsDelegate();

  @override
  Future<ExploreLocalizations> load(Locale locale) {
    return SynchronousFuture<ExploreLocalizations>(
        lookupExploreLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_ExploreLocalizationsDelegate old) => false;
}

ExploreLocalizations lookupExploreLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return ExploreLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ExploreLocalizationsEn();
    case 'zh':
      return ExploreLocalizationsZh();
  }

  throw FlutterError(
      'ExploreLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

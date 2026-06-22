import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'profile_localizations_en.dart';
import 'profile_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ProfileLocalizations
/// returned by `ProfileLocalizations.of(context)`.
///
/// Applications need to include `ProfileLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/profile_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ProfileLocalizations.localizationsDelegates,
///   supportedLocales: ProfileLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ProfileLocalizations.supportedLocales
/// property.
abstract class ProfileLocalizations {
  ProfileLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ProfileLocalizations of(BuildContext context) {
    return Localizations.of<ProfileLocalizations>(
        context, ProfileLocalizations)!;
  }

  static const LocalizationsDelegate<ProfileLocalizations> delegate =
      _ProfileLocalizationsDelegate();

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

  /// No description provided for @targetRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Range'**
  String get targetRangeTitle;

  /// No description provided for @targetRangeDescription.
  ///
  /// In en, this message translates to:
  /// **'Personal glucose target range thresholds.'**
  String get targetRangeDescription;

  /// No description provided for @targetRangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal glucose targets'**
  String get targetRangeSubtitle;

  /// No description provided for @pluginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pluginUnavailable;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Report'**
  String get pluginReportTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile, data source, target range, and settings.'**
  String get pluginSubtitle;

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get pluginTitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Profile, data source, target range, and settings.'**
  String get pluginDescription;

  /// No description provided for @pluginNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available yet.'**
  String get pluginNoData;

  /// No description provided for @pluginLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get pluginLoading;

  /// No description provided for @targetRangeVeryHighThresholdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Marked as urgent high zone'**
  String get targetRangeVeryHighThresholdSubtitle;

  /// No description provided for @targetRangePrimaryBandLabel.
  ///
  /// In en, this message translates to:
  /// **'Target range'**
  String get targetRangePrimaryBandLabel;

  /// No description provided for @targetRangeHighThresholdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Above this enters high range'**
  String get targetRangeHighThresholdSubtitle;

  /// No description provided for @targetRangeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Target range updated'**
  String get targetRangeUpdated;

  /// No description provided for @targetRangeInRangeTarget.
  ///
  /// In en, this message translates to:
  /// **'IN-RANGE TARGET'**
  String get targetRangeInRangeTarget;

  /// No description provided for @targetRangeHighThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'High threshold'**
  String get targetRangeHighThresholdLabel;

  /// No description provided for @targetRangePrimaryBandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Primary glucose band'**
  String get targetRangePrimaryBandSubtitle;

  /// No description provided for @targetRangeHighLabel.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get targetRangeHighLabel;

  /// No description provided for @targetRangeDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag a handle, or type below'**
  String get targetRangeDragHint;

  /// No description provided for @targetRangeVeryHighLabel.
  ///
  /// In en, this message translates to:
  /// **'VERY HIGH'**
  String get targetRangeVeryHighLabel;

  /// No description provided for @targetRangeExactValues.
  ///
  /// In en, this message translates to:
  /// **'EXACT VALUES'**
  String get targetRangeExactValues;

  /// No description provided for @targetRangeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Range'**
  String get targetRangeSheetTitle;

  /// No description provided for @targetRangeVeryHighThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Very high threshold'**
  String get targetRangeVeryHighThresholdLabel;

  /// No description provided for @targetRangeLowThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Low threshold'**
  String get targetRangeLowThresholdLabel;

  /// No description provided for @targetRangeLowThresholdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Below this enters low range'**
  String get targetRangeLowThresholdSubtitle;

  /// No description provided for @targetRangeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get targetRangeCancel;

  /// No description provided for @targetRangeLowLabel.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get targetRangeLowLabel;

  /// No description provided for @targetRangeSaveRange.
  ///
  /// In en, this message translates to:
  /// **'Save range'**
  String get targetRangeSaveRange;

  /// No description provided for @targetRangeSpread.
  ///
  /// In en, this message translates to:
  /// **'spread'**
  String get targetRangeSpread;

  /// No description provided for @targetRangeReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get targetRangeReset;

  /// No description provided for @targetRangeSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drag the markers or type exact values. Both stay in sync.'**
  String get targetRangeSheetSubtitle;

  /// No description provided for @profileHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileHeaderTitle;

  /// No description provided for @profileBuildingBaseline.
  ///
  /// In en, this message translates to:
  /// **'Building baseline'**
  String get profileBuildingBaseline;

  /// No description provided for @profileDaysRecorded.
  ///
  /// In en, this message translates to:
  /// **'{days} days recorded'**
  String profileDaysRecorded(int days);

  /// No description provided for @profileGlucotype.
  ///
  /// In en, this message translates to:
  /// **'Glucotype: {label}'**
  String profileGlucotype(String label);

  /// No description provided for @profileGlucotypeLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get profileGlucotypeLow;

  /// No description provided for @profileGlucotypeModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get profileGlucotypeModerate;

  /// No description provided for @profileGlucotypeSevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get profileGlucotypeSevere;

  /// No description provided for @profileStatTir14d.
  ///
  /// In en, this message translates to:
  /// **'TIR 14d'**
  String get profileStatTir14d;

  /// No description provided for @profileStatAvg14d.
  ///
  /// In en, this message translates to:
  /// **'Avg 14d'**
  String get profileStatAvg14d;

  /// No description provided for @profileStatCv14d.
  ///
  /// In en, this message translates to:
  /// **'CV 14d'**
  String get profileStatCv14d;

  /// No description provided for @profileSettingsSummary.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsSummary;

  /// No description provided for @profileSectionMyBaseline.
  ///
  /// In en, this message translates to:
  /// **'My Baseline'**
  String get profileSectionMyBaseline;

  /// No description provided for @profileSectionAppSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get profileSectionAppSettings;

  /// No description provided for @profileBaselineTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Glucose Baseline'**
  String get profileBaselineTitle;

  /// No description provided for @profileBaselineBuiltFrom.
  ///
  /// In en, this message translates to:
  /// **'Built from {days} days - Updated {date}'**
  String profileBaselineBuiltFrom(int days, String date);

  /// No description provided for @profileBaselineNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get profileBaselineNotEnough;

  /// No description provided for @profileBaselineTir.
  ///
  /// In en, this message translates to:
  /// **'TIR baseline'**
  String get profileBaselineTir;

  /// No description provided for @profileBaselineTypicalPeak.
  ///
  /// In en, this message translates to:
  /// **'Typical peak'**
  String get profileBaselineTypicalPeak;

  /// No description provided for @profileBaselineCvRange.
  ///
  /// In en, this message translates to:
  /// **'CV range'**
  String get profileBaselineCvRange;

  /// No description provided for @targetRangeLowHighGapMessage.
  ///
  /// In en, this message translates to:
  /// **'Low must be at least {gap} {unit} below High.'**
  String targetRangeLowHighGapMessage(String gap, String unit);

  /// No description provided for @targetRangeHighVeryHighGapMessage.
  ///
  /// In en, this message translates to:
  /// **'High must be at least {gap} {unit} below Very High.'**
  String targetRangeHighVeryHighGapMessage(String gap, String unit);
}

class _ProfileLocalizationsDelegate
    extends LocalizationsDelegate<ProfileLocalizations> {
  const _ProfileLocalizationsDelegate();

  @override
  Future<ProfileLocalizations> load(Locale locale) {
    return SynchronousFuture<ProfileLocalizations>(
        lookupProfileLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_ProfileLocalizationsDelegate old) => false;
}

ProfileLocalizations lookupProfileLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return ProfileLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ProfileLocalizationsEn();
    case 'zh':
      return ProfileLocalizationsZh();
  }

  throw FlutterError(
      'ProfileLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

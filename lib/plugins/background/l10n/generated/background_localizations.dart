import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'background_localizations_en.dart';
import 'background_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BackgroundLocalizations
/// returned by `BackgroundLocalizations.of(context)`.
///
/// Applications need to include `BackgroundLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/background_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BackgroundLocalizations.localizationsDelegates,
///   supportedLocales: BackgroundLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the BackgroundLocalizations.supportedLocales
/// property.
abstract class BackgroundLocalizations {
  BackgroundLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BackgroundLocalizations of(BuildContext context) {
    return Localizations.of<BackgroundLocalizations>(context, BackgroundLocalizations)!;
  }

  static const LocalizationsDelegate<BackgroundLocalizations> delegate = _BackgroundLocalizationsDelegate();

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
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @glucoseSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync active glucose source'**
  String get glucoseSyncSubtitle;

  /// No description provided for @sourceHealthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Validate active data source availability.'**
  String get sourceHealthSubtitle;

  /// No description provided for @sourceHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Source Health Check'**
  String get sourceHealthTitle;

  /// No description provided for @glucoseSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose Sync'**
  String get glucoseSyncTitle;

  /// No description provided for @glucoseSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Synchronizes glucose readings from active source.'**
  String get glucoseSyncDescription;

  /// No description provided for @sourceHealthDescription.
  ///
  /// In en, this message translates to:
  /// **'Checks the active xDrip or Nightscout source reachability.'**
  String get sourceHealthDescription;

  /// No description provided for @pluginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pluginUnavailable;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Report'**
  String get pluginReportTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Background glucose sync and source health tasks.'**
  String get pluginSubtitle;

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Tasks'**
  String get pluginTitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Background glucose sync and source health tasks.'**
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
}

class _BackgroundLocalizationsDelegate extends LocalizationsDelegate<BackgroundLocalizations> {
  const _BackgroundLocalizationsDelegate();

  @override
  Future<BackgroundLocalizations> load(Locale locale) {
    return SynchronousFuture<BackgroundLocalizations>(lookupBackgroundLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_BackgroundLocalizationsDelegate old) => false;
}

BackgroundLocalizations lookupBackgroundLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return BackgroundLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return BackgroundLocalizationsEn();
    case 'zh': return BackgroundLocalizationsZh();
  }

  throw FlutterError(
    'BackgroundLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

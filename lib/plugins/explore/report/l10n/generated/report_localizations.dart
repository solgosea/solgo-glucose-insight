import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'report_localizations_en.dart';
import 'report_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ReportLocalizations
/// returned by `ReportLocalizations.of(context)`.
///
/// Applications need to include `ReportLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/report_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ReportLocalizations.localizationsDelegates,
///   supportedLocales: ReportLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ReportLocalizations.supportedLocales
/// property.
abstract class ReportLocalizations {
  ReportLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ReportLocalizations of(BuildContext context) {
    return Localizations.of<ReportLocalizations>(context, ReportLocalizations)!;
  }

  static const LocalizationsDelegate<ReportLocalizations> delegate =
      _ReportLocalizationsDelegate();

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
  /// **'Glucose Report'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor-ready glucose report with print and share.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Doctor-ready glucose report with print and share.'**
  String get pluginDescription;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose Report Report'**
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

  /// No description provided for @pageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AGP-standard - local - export to PDF or share'**
  String get pageSubtitle;

  /// No description provided for @dateFilterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose report dates'**
  String get dateFilterTooltip;

  /// No description provided for @dateFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Report period'**
  String get dateFilterTitle;

  /// No description provided for @dateFilterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a standard doctor-ready window, or drag across dates for a custom report range.'**
  String get dateFilterSubtitle;

  /// No description provided for @dateFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply period'**
  String get dateFilterApply;

  /// No description provided for @dateFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateFilterReset;

  /// No description provided for @dateFilterCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dateFilterCancel;

  /// No description provided for @dateFilterSelectedDates.
  ///
  /// In en, this message translates to:
  /// **'Selected period'**
  String get dateFilterSelectedDates;

  /// No description provided for @dateFilterDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get dateFilterDay;

  /// No description provided for @dateFilterDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get dateFilterDays;

  /// No description provided for @dateFilterReadings.
  ///
  /// In en, this message translates to:
  /// **'readings'**
  String get dateFilterReadings;

  /// No description provided for @dateFilterDragHint.
  ///
  /// In en, this message translates to:
  /// **'Glucose Report works best with 14-90 days. Custom ranges are exported exactly as selected.'**
  String get dateFilterDragHint;

  /// No description provided for @windowShortLast14Days.
  ///
  /// In en, this message translates to:
  /// **'14d'**
  String get windowShortLast14Days;

  /// No description provided for @windowShortLast30Days.
  ///
  /// In en, this message translates to:
  /// **'30d'**
  String get windowShortLast30Days;

  /// No description provided for @windowShortLast90Days.
  ///
  /// In en, this message translates to:
  /// **'90d'**
  String get windowShortLast90Days;

  /// No description provided for @sectionKeyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get sectionKeyMetrics;

  /// No description provided for @sectionTimeInRanges.
  ///
  /// In en, this message translates to:
  /// **'Time in Ranges'**
  String get sectionTimeInRanges;

  /// No description provided for @sectionAgp.
  ///
  /// In en, this message translates to:
  /// **'Ambulatory Glucose Profile'**
  String get sectionAgp;

  /// No description provided for @sectionDailyCurves.
  ///
  /// In en, this message translates to:
  /// **'Daily Curves'**
  String get sectionDailyCurves;

  /// No description provided for @sectionIncludeInReport.
  ///
  /// In en, this message translates to:
  /// **'Include in Report'**
  String get sectionIncludeInReport;

  /// No description provided for @sectionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get sectionExport;

  /// No description provided for @reportDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose Report Document'**
  String get reportDocumentTitle;

  /// No description provided for @reportWearLabel.
  ///
  /// In en, this message translates to:
  /// **'{wear}% wear'**
  String reportWearLabel(String wear);

  /// No description provided for @headerPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get headerPeriod;

  /// No description provided for @headerReadings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get headerReadings;

  /// No description provided for @headerCoverage.
  ///
  /// In en, this message translates to:
  /// **'Coverage'**
  String get headerCoverage;

  /// No description provided for @headerDataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get headerDataSource;

  /// No description provided for @headerTargetRange.
  ///
  /// In en, this message translates to:
  /// **'Target range'**
  String get headerTargetRange;

  /// No description provided for @headerGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get headerGenerated;

  /// No description provided for @exportPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Reports are generated locally from CGM readings stored on this device. No insulin, carb, medication, or meal data is included.'**
  String get exportPrivacyNote;

  /// No description provided for @exportDescription.
  ///
  /// In en, this message translates to:
  /// **'Doctor-ready PDF output packages this report for saving or sharing. The interactive report remains available in the app.'**
  String get exportDescription;

  /// No description provided for @exportSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get exportSavePdf;

  /// No description provided for @exportShareSend.
  ///
  /// In en, this message translates to:
  /// **'Share / Send'**
  String get exportShareSend;

  /// No description provided for @exportGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get exportGenerating;

  /// No description provided for @metricTir.
  ///
  /// In en, this message translates to:
  /// **'TIR'**
  String get metricTir;

  /// No description provided for @metricAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get metricAverage;

  /// No description provided for @metricWear.
  ///
  /// In en, this message translates to:
  /// **'Wear'**
  String get metricWear;

  /// No description provided for @metricCv.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get metricCv;

  /// No description provided for @metricGmi.
  ///
  /// In en, this message translates to:
  /// **'GMI'**
  String get metricGmi;

  /// No description provided for @metricSd.
  ///
  /// In en, this message translates to:
  /// **'SD'**
  String get metricSd;

  /// No description provided for @metricTargetUnit.
  ///
  /// In en, this message translates to:
  /// **'target >=70%'**
  String get metricTargetUnit;

  /// No description provided for @metricOnTarget.
  ///
  /// In en, this message translates to:
  /// **'On target'**
  String get metricOnTarget;

  /// No description provided for @metricBelowTarget.
  ///
  /// In en, this message translates to:
  /// **'Below target'**
  String get metricBelowTarget;

  /// No description provided for @metricSensorActive.
  ///
  /// In en, this message translates to:
  /// **'sensor active'**
  String get metricSensorActive;

  /// No description provided for @metricCvTargetUnit.
  ///
  /// In en, this message translates to:
  /// **'target <36%'**
  String get metricCvTargetUnit;

  /// No description provided for @metricGmiUnit.
  ///
  /// In en, this message translates to:
  /// **'est. A1C'**
  String get metricGmiUnit;

  /// No description provided for @rangeVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get rangeVeryHigh;

  /// No description provided for @rangeHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get rangeHigh;

  /// No description provided for @rangeInRange.
  ///
  /// In en, this message translates to:
  /// **'In Range'**
  String get rangeInRange;

  /// No description provided for @rangeLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get rangeLow;

  /// No description provided for @rangeVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low'**
  String get rangeVeryLow;

  /// No description provided for @emptyNoReportData.
  ///
  /// In en, this message translates to:
  /// **'No report data yet. Connect xDrip+ Local or Nightscout API and sync readings first.'**
  String get emptyNoReportData;

  /// No description provided for @periodAnalysisInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient data for period analysis.'**
  String get periodAnalysisInsufficient;

  /// No description provided for @episodeSummaryInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient data for episode summary.'**
  String get episodeSummaryInsufficient;

  /// No description provided for @periodAnalysisSummary.
  ///
  /// In en, this message translates to:
  /// **'{bestPeriod} had the highest TIR ({bestTir}%). {variablePeriod} was the most variable period (CV {cv}%).'**
  String periodAnalysisSummary(
      String bestPeriod, String bestTir, String variablePeriod, String cv);

  /// No description provided for @episodeSummary.
  ///
  /// In en, this message translates to:
  /// **'{highCount} high episodes and {lowCount} low episodes were detected in this report window.'**
  String episodeSummary(int highCount, int lowCount);

  /// No description provided for @unitDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String unitDays(int days);

  /// No description provided for @unitReadings.
  ///
  /// In en, this message translates to:
  /// **'{count} readings'**
  String unitReadings(String count);

  /// No description provided for @unitWearActive.
  ///
  /// In en, this message translates to:
  /// **'{wear}% wear - {minutes} active min'**
  String unitWearActive(String wear, int minutes);

  /// No description provided for @toggleKeyMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get toggleKeyMetricsTitle;

  /// No description provided for @toggleKeyMetricsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TIR, average, wear, CV and GMI'**
  String get toggleKeyMetricsSubtitle;

  /// No description provided for @toggleAgpChartTitle.
  ///
  /// In en, this message translates to:
  /// **'AGP Chart'**
  String get toggleAgpChartTitle;

  /// No description provided for @toggleAgpChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'24-hour percentile overlay'**
  String get toggleAgpChartSubtitle;

  /// No description provided for @toggleDailyCurvesTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Curves'**
  String get toggleDailyCurvesTitle;

  /// No description provided for @toggleDailyCurvesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last 14 days with sparse-data marks'**
  String get toggleDailyCurvesSubtitle;

  /// No description provided for @togglePeriodAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Period Analysis'**
  String get togglePeriodAnalysisTitle;

  /// No description provided for @togglePeriodAnalysisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add day-part pattern summary'**
  String get togglePeriodAnalysisSubtitle;

  /// No description provided for @toggleEpisodesSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Episodes Summary'**
  String get toggleEpisodesSummaryTitle;

  /// No description provided for @toggleEpisodesSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add low/high episode counts'**
  String get toggleEpisodesSummarySubtitle;

  /// No description provided for @sourceNightscoutXdrip.
  ///
  /// In en, this message translates to:
  /// **'Nightscout API + xDrip+ Local'**
  String get sourceNightscoutXdrip;

  /// No description provided for @sourceXdrip.
  ///
  /// In en, this message translates to:
  /// **'xDrip+ Local HTTP'**
  String get sourceXdrip;

  /// No description provided for @sourceNightscout.
  ///
  /// In en, this message translates to:
  /// **'Nightscout API'**
  String get sourceNightscout;

  /// No description provided for @sourceLocalCache.
  ///
  /// In en, this message translates to:
  /// **'Local canonical cache'**
  String get sourceLocalCache;

  /// No description provided for @sourceNoData.
  ///
  /// In en, this message translates to:
  /// **'No data source'**
  String get sourceNoData;

  /// No description provided for @agpOverlayLabel.
  ///
  /// In en, this message translates to:
  /// **'24-HOUR OVERLAY - ALL DAYS COMBINED'**
  String get agpOverlayLabel;

  /// No description provided for @agpLegendMedian.
  ///
  /// In en, this message translates to:
  /// **'Median'**
  String get agpLegendMedian;

  /// No description provided for @agpLegendIqr.
  ///
  /// In en, this message translates to:
  /// **'IQR'**
  String get agpLegendIqr;
}

class _ReportLocalizationsDelegate
    extends LocalizationsDelegate<ReportLocalizations> {
  const _ReportLocalizationsDelegate();

  @override
  Future<ReportLocalizations> load(Locale locale) {
    return SynchronousFuture<ReportLocalizations>(
        lookupReportLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_ReportLocalizationsDelegate old) => false;
}

ReportLocalizations lookupReportLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return ReportLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ReportLocalizationsEn();
    case 'zh':
      return ReportLocalizationsZh();
  }

  throw FlutterError(
      'ReportLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

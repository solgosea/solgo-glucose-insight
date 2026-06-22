import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/analysis/analysis_module_code.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_visual_mapper.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import '../application/home_metric_window_policy.dart';
import '../application/i18n/home_l10n_resolver.dart';
import '../l10n/generated/home_localizations.dart';
import '../models/home_chart_range.dart';
import '../models/home_glucose_summary_view_model.dart';
import '../models/home_stat_card_view_model.dart';
import '../models/home_tir_view_model.dart';
import '../models/home_view_model.dart';

class HomeViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;
  final GlucoseTrendVisualMapper trendVisualMapper;
  final HomeMetricWindowPolicy metricWindowPolicy;

  const HomeViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
    this.trendVisualMapper = const GlucoseTrendVisualMapper(),
    this.metricWindowPolicy = const HomeMetricWindowPolicy(),
  });

  HomeViewModel map({
    required AnalysisFacade facade,
    required HomeChartRange selectedRange,
    required SyncStatusViewModel syncStatus,
    HomeLocalizations? l10n,
  }) {
    final strings = l10n ?? HomeL10nResolver.fallback;
    final settings = facade.settings;
    final unit = settings.unit;
    final latest = facade.latestReading ??
        GlucoseReading(timestamp: DateTime.now(), value: 0);
    final chartReadings = facade.readingsForLastHours(selectedRange.hours);
    final summaryWindow = metricWindowPolicy.timeInRange;
    final summaryReadings = facade.readingsForLastHours(summaryWindow.hours);
    final summaryTir = facade.tirForReadings(summaryReadings);
    final generated = facade.localizedInsightBodiesFor(
      AnalysisModuleCode.insights,
      locale: strings.localeName,
    );
    final insightText = generated.isNotEmpty
        ? generated.first
        : (facade.compactDailySummary() ?? strings.homeNotEnoughData);

    return HomeViewModel(
      syncStatus: syncStatus,
      activeSubject: facade.activeSubject,
      glucose: _glucose(latest, unit),
      selectedRange: selectedRange,
      availableRanges: HomeChartRange.values,
      chartReadings: chartReadings,
      unit: unit,
      lowThreshold: settings.lowThreshold,
      highThreshold: settings.highThreshold,
      stats: _stats(summaryTir: summaryTir, unit: unit, l10n: strings),
      tir: _tir(summaryTir, settings, strings),
      insightText: insightText,
    );
  }

  HomeGlucoseSummaryViewModel _glucose(
    GlucoseReading reading,
    GlucoseUnit unit,
  ) {
    final ratePerMin = reading.ratePerMin;
    final value = glucoseFormatter.value(reading.value, unit);
    final rate =
        ratePerMin == null ? null : glucoseFormatter.rate(ratePerMin, unit);
    final trend = trendVisualMapper.map(ratePerMin);
    final hour = reading.timestamp.hour.toString().padLeft(2, '0');
    final minute = reading.timestamp.minute.toString().padLeft(2, '0');

    return HomeGlucoseSummaryViewModel(
      value: value.valueLabel,
      unit: value.unitLabel,
      trendArrow: trend.arrow,
      trendLabel: trend.label,
      rateText: rate?.fullLabel ?? '--',
      timestampText: '$hour:$minute',
    );
  }

  List<HomeStatCardViewModel> _stats({
    required AnalysisTirResult summaryTir,
    required GlucoseUnit unit,
    required HomeLocalizations l10n,
  }) {
    final averageWindow = metricWindowPolicy.average;
    final tirWindow = metricWindowPolicy.timeInRange;
    final cvWindow = metricWindowPolicy.coefficientOfVariation;
    final cv = summaryTir.cv;
    final tirColor = summaryTir.tir < 70 ? AppColors.amber : AppColors.green;
    final cvColor = cv < 36 ? AppColors.green : AppColors.amber;
    final mean = glucoseFormatter.value(summaryTir.mean, unit);

    return [
      HomeStatCardViewModel(
        label: l10n.homeStatAverage(averageWindow.labelSuffix),
        value: mean.valueLabel,
        valueColor: AppColors.green,
        unit: mean.unitLabel,
      ),
      HomeStatCardViewModel(
        label: l10n.homeStatTir(tirWindow.labelSuffix),
        value: '${summaryTir.tir.toStringAsFixed(0)}%',
        valueColor: tirColor,
        unit: l10n.homeInRange,
      ),
      HomeStatCardViewModel(
        label: l10n.homeStatCv(cvWindow.labelSuffix),
        value: '${cv.toStringAsFixed(0)}%',
        valueColor: cvColor,
        unit: l10n.homeStable,
      ),
    ];
  }

  HomeTirViewModel _tir(
    AnalysisTirResult tir24h,
    AppSettings settings,
    HomeLocalizations l10n,
  ) {
    final range = glucoseFormatter.range(
      settings.lowThreshold,
      settings.highThreshold,
      settings.unit,
    );
    final highLabel = thresholdFormatter.highLabel(settings);
    final lowLabel = thresholdFormatter.lowLabel(settings);
    return HomeTirViewModel(
      tir: tir24h.tir,
      tar: tir24h.tar,
      tbr: tir24h.tbr,
      footer: '${range.fullLabel} - ${l10n.homeLast24h}',
      rows: [
        HomeTirRowViewModel(
          label: l10n.homeHighWithThreshold(highLabel),
          percent: tir24h.tar,
          color: AppColors.rose,
        ),
        HomeTirRowViewModel(
          label: l10n.homeInRange,
          percent: tir24h.tir,
          color: AppColors.green,
        ),
        HomeTirRowViewModel(
          label: l10n.homeLowWithThreshold(lowLabel),
          percent: tir24h.tbr,
          color: AppColors.blue,
        ),
      ],
    );
  }
}

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
  }) {
    final settings = facade.settings;
    final unit = settings.unit;
    final latest = facade.latestReading ??
        GlucoseReading(timestamp: DateTime.now(), value: 0);
    final chartReadings = facade.readingsForLastHours(selectedRange.hours);
    final summaryWindow = metricWindowPolicy.timeInRange;
    final summaryReadings = facade.readingsForLastHours(summaryWindow.hours);
    final summaryTir = facade.tirForReadings(summaryReadings);
    final generated = facade.insightBodiesFor(AnalysisModuleCode.insights);
    final insightText = generated.isNotEmpty
        ? generated.first
        : (facade.compactDailySummary() ?? 'Not enough CGM data yet.');

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
      stats: _stats(summaryTir: summaryTir, unit: unit),
      tir: _tir(summaryTir, settings),
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
        label: 'Avg ${averageWindow.labelSuffix}',
        value: mean.valueLabel,
        valueColor: AppColors.green,
        unit: mean.unitLabel,
      ),
      HomeStatCardViewModel(
        label: 'TIR ${tirWindow.labelSuffix}',
        value: '${summaryTir.tir.toStringAsFixed(0)}%',
        valueColor: tirColor,
        unit: 'in range',
      ),
      HomeStatCardViewModel(
        label: 'CV ${cvWindow.labelSuffix}',
        value: '${cv.toStringAsFixed(0)}%',
        valueColor: cvColor,
        unit: 'stable',
      ),
    ];
  }

  HomeTirViewModel _tir(AnalysisTirResult tir24h, AppSettings settings) {
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
      footer: '${range.fullLabel} - Last 24h',
      rows: [
        HomeTirRowViewModel(
          label: 'High $highLabel',
          percent: tir24h.tar,
          color: AppColors.rose,
        ),
        HomeTirRowViewModel(
          label: 'In range',
          percent: tir24h.tir,
          color: AppColors.green,
        ),
        HomeTirRowViewModel(
          label: 'Low $lowLabel',
          percent: tir24h.tbr,
          color: AppColors.blue,
        ),
      ],
    );
  }
}

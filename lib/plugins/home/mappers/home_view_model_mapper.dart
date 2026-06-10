import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/analysis/analysis_module_code.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_visual_mapper.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import '../models/home_chart_range.dart';
import '../models/home_glucose_summary_view_model.dart';
import '../models/home_stat_card_view_model.dart';
import '../models/home_tir_view_model.dart';
import '../models/home_view_model.dart';

class HomeViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;
  final GlucoseTrendVisualMapper trendVisualMapper;

  const HomeViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
    this.trendVisualMapper = const GlucoseTrendVisualMapper(),
  });

  HomeViewModel map({
    required AnalysisFacade facade,
    required HomeChartRange selectedRange,
    required SyncStatusViewModel syncStatus,
  }) {
    final settings = facade.settings;
    final unit = settings.unit;
    final latest =
        facade.latestReading ??
        GlucoseReading(timestamp: DateTime.now(), value: 0);
    final chartReadings = facade.readingsForLastHours(selectedRange.hours);
    final tir24h = facade.tirForReadings(facade.readingsForLastHours(24));
    final cv7d =
        facade.averageCvForLastDays(7) ??
        facade.tirForReadings(facade.readingsForLastDays(7)).cv;
    final generated = facade.insightBodiesFor(AnalysisModuleCode.insights);
    final insightText =
        generated.isNotEmpty
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
      stats: _stats(tir24h: tir24h, cv7d: cv7d, unit: unit),
      tir: _tir(tir24h, settings),
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
    required AnalysisTirResult tir24h,
    required double cv7d,
    required GlucoseUnit unit,
  }) {
    final tirColor = tir24h.tir < 70 ? AppColors.amber : AppColors.green;
    final cvColor = cv7d < 36 ? AppColors.green : AppColors.amber;
    final mean = glucoseFormatter.value(tir24h.mean, unit);

    return [
      HomeStatCardViewModel(
        label: 'Avg 24h',
        value: mean.valueLabel,
        valueColor: AppColors.green,
        unit: mean.unitLabel,
      ),
      HomeStatCardViewModel(
        label: 'TIR 24h',
        value: '${tir24h.tir.toStringAsFixed(0)}%',
        valueColor: tirColor,
        unit: 'in range',
      ),
      HomeStatCardViewModel(
        label: 'CV 7d',
        value: '${cv7d.toStringAsFixed(0)}%',
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

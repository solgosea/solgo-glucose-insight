import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/text/statistics_metrics_text_builder.dart';
import '../domain/sections/statistics_metrics_section.dart';
import '../domain/statistics_delta_tone.dart' as domain;
import '../l10n/generated/statistics_localizations.dart';
import '../models/statistics_view_model.dart';

class StatisticsMetricsViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;
  final StatisticsMetricsTextBuilder textBuilder;

  const StatisticsMetricsViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
    this.textBuilder = const StatisticsMetricsTextBuilder(),
  });

  String header(
    String windowLabel, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      textBuilder.header(windowLabel, context: context);

  List<StatisticsMetricCardViewModel> map({
    required StatisticsMetricsSection section,
    required AppSettings settings,
    required String previousWindowLabel,
    required StatisticsLocalizations l10n,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    final unit = settings.unit;
    final mean = glucoseFormatter.value(section.meanMmol, unit);
    final sd = glucoseFormatter.value(section.sdMmol, unit);
    final meanDelta = glucoseFormatter.value(section.meanDeltaMmol, unit);
    final sdDelta = glucoseFormatter.value(section.sdDeltaMmol, unit);

    return [
      StatisticsMetricCardViewModel(
        label: textBuilder.tirLabel(context: context),
        value: section.tir.toStringAsFixed(0),
        valueColor: section.tir >= 70
            ? AppColors.green
            : section.tir >= 50
                ? AppColors.amber
                : AppColors.rose,
        suffix: '%',
        unit: thresholdFormatter.targetRange(settings),
        deltaText: _deltaText(
          section.tirDelta,
          suffix: '%',
          previousWindowLabel: previousWindowLabel,
          l10n: l10n,
        ),
        deltaTone: _tone(section.tirTone),
      ),
      StatisticsMetricCardViewModel(
        label: textBuilder.averageLabel(context: context),
        value: mean.valueLabel,
        valueColor: AppColors.text,
        unit: '${mean.unitLabel} - GMI ${section.gmi.toStringAsFixed(1)}%',
        deltaText:
            _deltaText(meanDelta.value, suffix: ' ${meanDelta.unitLabel}'),
        deltaTone: _tone(section.meanTone),
      ),
      StatisticsMetricCardViewModel(
        label: textBuilder.cvLabel(context: context),
        value: section.cv.toStringAsFixed(0),
        valueColor: section.cvStable ? AppColors.green : AppColors.amber,
        suffix: '%',
        unit: textBuilder.cvStatus(stable: section.cvStable, context: context),
        deltaText: _deltaText(section.cvDelta, suffix: '%'),
        deltaTone: _tone(section.cvTone),
      ),
      StatisticsMetricCardViewModel(
        label: textBuilder.sdLabel(context: context),
        value: sd.valueLabel,
        valueColor: AppColors.text,
        unit: sd.unitLabel,
        deltaText: _deltaText(sdDelta.value, suffix: ' ${sdDelta.unitLabel}'),
        deltaTone: _tone(section.sdTone),
      ),
    ];
  }

  String _deltaText(
    double delta, {
    required String suffix,
    String? previousWindowLabel,
    StatisticsLocalizations? l10n,
  }) {
    if (delta.abs() < 0.05) return l10n?.deltaSame ?? 'same';
    final sign = delta > 0 ? '+' : '';
    final value = '$sign${delta.toStringAsFixed(1)}$suffix';
    if (previousWindowLabel == null || l10n == null) return value;
    return l10n.deltaVsPrevious(value, previousWindowLabel);
  }

  StatisticsDeltaTone _tone(domain.StatisticsDeltaToneSignal tone) {
    return switch (tone) {
      domain.StatisticsDeltaToneSignal.up => StatisticsDeltaTone.up,
      domain.StatisticsDeltaToneSignal.down => StatisticsDeltaTone.down,
      domain.StatisticsDeltaToneSignal.flat => StatisticsDeltaTone.flat,
    };
  }
}

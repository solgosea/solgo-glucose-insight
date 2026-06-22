import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/text/statistics_tir_text_builder.dart';
import '../application/i18n/statistics_l10n_resolver.dart';
import '../domain/sections/statistics_tir_breakdown_section.dart';
import '../l10n/generated/statistics_localizations.dart';
import '../models/statistics_view_model.dart';

class StatisticsTirViewModelMapper {
  static const _veryHighColor = Color(0xFFA03030);
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;
  final StatisticsTirTextBuilder textBuilder;

  const StatisticsTirViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
    this.textBuilder = const StatisticsTirTextBuilder(),
  });

  StatisticsTirBreakdownViewModel map({
    required StatisticsTirBreakdownSection section,
    required AppSettings settings,
    StatisticsLocalizations? l10n,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    final strings = l10n ?? StatisticsL10nResolver.fallback;
    final veryLowLabel =
        '<${glucoseFormatter.value(3.0, settings.unit).valueLabel}';
    final veryHighLabel = thresholdFormatter.veryHighLabel(settings);
    final segments = [
      StatisticsTirSegmentViewModel(
        color: AppColors.blue,
        fraction: section.lowPct,
      ),
      StatisticsTirSegmentViewModel(
        color: AppColors.green,
        fraction: section.inRangePct,
      ),
      StatisticsTirSegmentViewModel(
        color: AppColors.rose,
        fraction: section.highPct,
      ),
      StatisticsTirSegmentViewModel(
        color: _veryHighColor,
        fraction: section.veryHighPct,
      ),
    ].where((segment) => segment.fraction > 0).toList(growable: false);

    return StatisticsTirBreakdownViewModel(
      segments: segments,
      legends: [
        StatisticsLegendItemViewModel(
          color: AppColors.blue,
          text: textBuilder.lowLegend(
            section.lowPct.toStringAsFixed(0),
            context: context,
          ),
        ),
        StatisticsLegendItemViewModel(
          color: AppColors.green,
          text: textBuilder.inRangeLegend(
            section.inRangePct.toStringAsFixed(0),
            context: context,
          ),
        ),
        StatisticsLegendItemViewModel(
          color: AppColors.rose,
          text: textBuilder.highLegend(
            section.highPct.toStringAsFixed(0),
            context: context,
          ),
        ),
        StatisticsLegendItemViewModel(
          color: _veryHighColor,
          text: textBuilder.veryHighLegend(
            section.veryHighPct.toStringAsFixed(0),
            context: context,
          ),
        ),
      ],
      extremes: [
        StatisticsExtremeCellViewModel(
          label: textBuilder.veryLowExtreme(
            veryLowLabel,
            context: context,
          ),
          value: '${section.veryLowPct.toStringAsFixed(1)}%',
          subtitle: strings.minutesPerDay(section.veryLowMinutesPerDay),
        ),
        StatisticsExtremeCellViewModel(
          label: textBuilder.veryHighExtreme(
            veryHighLabel,
            context: context,
          ),
          value: '${section.veryHighPct.toStringAsFixed(0)}%',
          subtitle: strings.minutesPerDay(section.veryHighMinutesPerDay),
        ),
      ],
    );
  }
}

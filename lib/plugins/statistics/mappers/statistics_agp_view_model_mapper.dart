import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp_chart.dart';

import '../application/text/statistics_agp_text_builder.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../domain/sections/statistics_agp_section.dart';
import '../application/i18n/statistics_l10n_resolver.dart';
import '../l10n/generated/statistics_localizations.dart';
import '../models/statistics_view_model.dart';

class StatisticsAgpViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final StatisticsAgpTextBuilder textBuilder;

  const StatisticsAgpViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.textBuilder = const StatisticsAgpTextBuilder(),
  });

  StatisticsAgpViewModel map({
    required StatisticsAgpSection section,
    required AppSettings settings,
    StatisticsLocalizations? l10n,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    final strings = l10n ?? StatisticsL10nResolver.fallback;
    return StatisticsAgpViewModel(
      title: strings.agpTitle(_windowShortLabel(section.window.id, strings)),
      guidanceText: section.showGuidance
          ? textBuilder.renderNotEnoughWindowGuidance(context: context)
          : '',
      slots: section.slots,
      unit: settings.unit,
      lowThreshold: settings.lowThreshold,
      highThreshold: settings.highThreshold,
      annotations: section.showDawnAnnotation
          ? [
              AgpAnnotation(
                minuteOfDay: 300,
                labels: [
                  strings.agpAnnotationDawn,
                  strings.agpAnnotationPhenomenon,
                ],
                color: AppColors.amber,
                opacity: 0.5,
              ),
            ]
          : const [],
      note: _agpNote(section, settings, strings, context),
    );
  }

  String _agpNote(
    StatisticsAgpSection section,
    AppSettings settings,
    StatisticsLocalizations l10n,
    PluginTextRenderContext context,
  ) {
    if (section.readings.isEmpty || section.slots.isEmpty) {
      return textBuilder.renderEmpty(context: context);
    }

    final unit = settings.unit;
    final dawn = section.dawn;
    final peak = section.medianPeak;
    final topPeriod =
        section.variablePeriods.isEmpty ? null : section.variablePeriods.first;
    final secondPeriod =
        section.variablePeriods.length > 1 ? section.variablePeriods[1] : null;
    final riseThreshold = glucoseFormatter.value(
      dawn.significantRiseThresholdMmol,
      unit,
    );

    final parts = <String>[];
    if (dawn.consistent) {
      final rise = glucoseFormatter.value(dawn.averageRiseMmol, unit);
      parts.add(
        textBuilder.renderDawn({
          'dawnConsistent': true,
          'windowLabel': dawn.windowLabel,
          'significantDays': dawn.significantDays,
          'observedDays': dawn.observedDays,
          'averageRise': rise.valueLabel,
          'glucoseUnit': rise.unitLabel,
        }, context: context),
      );
    } else if (dawn.observedDays == 0) {
      parts.add(
        textBuilder.renderDawn({
          'dawnNotEnough': true,
          'windowLabel': dawn.windowLabel,
        }, context: context),
      );
    } else {
      parts.add(
        textBuilder.renderDawn({
          'dawnObserved': true,
          'significantDays': dawn.significantDays,
          'observedDays': dawn.observedDays,
          'riseThreshold': riseThreshold.valueLabel,
          'glucoseUnit': riseThreshold.unitLabel,
        }, context: context),
      );
    }

    if (peak != null) {
      final peakValue = glucoseFormatter.value(peak.valueMmol, unit);
      parts.add(
        textBuilder.renderPeak({
          'peakValue': peakValue.valueLabel,
          'glucoseUnit': peakValue.unitLabel,
          'peakTime': _formatMinute(peak.minuteOfDay),
        }, context: context),
      );
    }

    if (topPeriod != null && secondPeriod != null) {
      parts.add(
        textBuilder.renderVariability({
          'topPeriod': _periodLabel(topPeriod.label, l10n),
          'topCv': topPeriod.cv.toStringAsFixed(0),
          'secondPeriod': _periodLabel(secondPeriod.label, l10n).toLowerCase(),
          'secondCv': secondPeriod.cv.toStringAsFixed(0),
        }, context: context),
      );
    } else if (topPeriod != null) {
      parts.add(
        textBuilder.renderVariability({
          'topPeriod': _periodLabel(topPeriod.label, l10n),
          'topCv': topPeriod.cv.toStringAsFixed(0),
        }, context: context),
      );
    } else {
      parts.add(
        textBuilder.renderVariability(
          {'notEnoughData': true},
          context: context,
        ),
      );
    }

    return parts.join(' ');
  }

  String _formatMinute(int minuteOfDay) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String _periodLabel(String code, StatisticsLocalizations l10n) {
    return switch (code) {
      'night' => l10n.periodNight,
      'morning' => l10n.periodMorning,
      'afternoon' => l10n.periodAfternoon,
      'evening' => l10n.periodEvening,
      _ => code,
    };
  }

  String _windowShortLabel(
    StatisticsAnalysisWindowId id,
    StatisticsLocalizations l10n,
  ) {
    return switch (id) {
      StatisticsAnalysisWindowId.last24Hours => l10n.windowShortLast24Hours,
      StatisticsAnalysisWindowId.last3Days => l10n.windowShortLast3Days,
      StatisticsAnalysisWindowId.last7Days => l10n.windowShortLast7Days,
      StatisticsAnalysisWindowId.last14Days => l10n.windowShortLast14Days,
      StatisticsAnalysisWindowId.last30Days => l10n.windowShortLast30Days,
      StatisticsAnalysisWindowId.last90Days => l10n.windowShortLast90Days,
    };
  }
}

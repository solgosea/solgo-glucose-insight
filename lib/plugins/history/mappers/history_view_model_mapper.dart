import 'package:flutter/material.dart';
import '../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../application/i18n/localized_date_time_formatter.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../../../domain/time/date_range_granularity.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/text/history_filter_text_builder.dart';
import '../domain/sections/history_date_section.dart';
import '../domain/sections/history_stats_section.dart';
import '../domain/sections/history_summary_section.dart';
import '../engine/history_engine_output.dart';
import '../application/i18n/history_l10n_resolver.dart';
import '../l10n/generated/history_localizations.dart';
import '../models/history_view_model.dart';
import 'history_curve_view_model_mapper.dart';
import 'history_episode_view_model_mapper.dart';
import 'history_events_view_model_mapper.dart';

class HistoryViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final HistoryCurveViewModelMapper curveMapper;
  final HistoryEpisodeViewModelMapper episodeMapper;
  final HistoryEventsViewModelMapper eventsMapper;
  final HistoryFilterTextBuilder filterTextBuilder;

  const HistoryViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.curveMapper = const HistoryCurveViewModelMapper(),
    this.episodeMapper = const HistoryEpisodeViewModelMapper(),
    this.eventsMapper = const HistoryEventsViewModelMapper(),
    this.filterTextBuilder = const HistoryFilterTextBuilder(),
  });

  HistoryViewModel map(
    HistoryEngineOutput output, {
    HistoryLocalizations? l10n,
  }) {
    final strings = l10n ?? HistoryL10nResolver.fallback;
    final filterLabel = filterTextBuilder.label(output.timeFilter, strings);
    return HistoryViewModel(
      dateNav: _dateNav(output.dateSection, strings),
      summaryChips: _summaryChips(
        output.summarySection,
        output.settings,
        strings,
      ),
      curve: curveMapper.map(output.curveSection, output.settings),
      stats: _stats(output.statsSection, output.settings, strings),
      episodeCallouts: episodeMapper.map(
        output.episodeSection,
        output.settings,
        selectedDay: output.dateSection.selectedDay,
        l10n: strings,
      ),
      events: eventsMapper.map(
        output.eventsSection,
        output.settings,
        l10n: strings,
      ),
      timeFilter: filterLabel == null
          ? null
          : HistoryTimeFilterViewModel(label: filterLabel),
    );
  }

  HistoryDateNavViewModel _dateNav(
    HistoryDateSection section,
    HistoryLocalizations l10n,
  ) {
    final yearLabel = section.selectedDay.year.toString();
    return HistoryDateNavViewModel(
      dateLabel: _dateLabel(section, l10n),
      subtitle: section.isToday
          ? '$yearLabel - ${l10n.dayView}  -  ${l10n.today}'
          : section.isSingleDay
              ? '$yearLabel - ${l10n.dayView}'
              : l10n.dateFilterRangeSubtitle,
      isToday: section.isToday,
    );
  }

  List<HistorySummaryChipViewModel> _summaryChips(
    HistorySummarySection section,
    AppSettings settings,
    HistoryLocalizations l10n,
  ) {
    final tir = section.tir;
    if (tir == null) return const [];
    final unit = settings.unit;
    final peak = _peak(section.readings);
    final peakLabel = glucoseFormatter.value(peak, unit).valueLabel;
    final meanLabel = glucoseFormatter.value(tir.mean, unit).valueLabel;
    return [
      HistorySummaryChipViewModel(
        text: '${l10n.summaryTir} ${tir.tir.toStringAsFixed(0)}%',
        color: _tirColor(tir.tir),
      ),
      HistorySummaryChipViewModel(
        text: '${l10n.summaryPeak} $peakLabel',
        color:
            peak > settings.highThreshold ? AppColors.amber : AppColors.green,
      ),
      HistorySummaryChipViewModel(
        text: '${l10n.summaryCv} ${tir.cv.toStringAsFixed(0)}%',
        color: tir.cv < 36 ? AppColors.green : AppColors.amber,
      ),
      HistorySummaryChipViewModel(
        text: '${l10n.summaryAverage} $meanLabel',
        color: (tir.mean >= settings.lowThreshold &&
                tir.mean <= settings.highThreshold)
            ? AppColors.green
            : AppColors.amber,
      ),
    ];
  }

  List<HistoryStatCardViewModel> _stats(
    HistoryStatsSection section,
    AppSettings settings,
    HistoryLocalizations l10n,
  ) {
    final tir = section.tir;
    if (tir == null) return const [];
    final unit = settings.unit;
    final peak = _peak(section.readings);
    final mean = glucoseFormatter.value(tir.mean, unit);
    final peakDisplay = glucoseFormatter.value(peak, unit);
    return [
      HistoryStatCardViewModel(
        label: l10n.statTir,
        value: '${tir.tir.toStringAsFixed(0)}%',
        color: _tirColor(tir.tir),
      ),
      HistoryStatCardViewModel(
        label: l10n.statAverage,
        value: mean.valueLabel,
        unit: mean.unitLabel,
        color: AppColors.text,
      ),
      HistoryStatCardViewModel(
        label: l10n.statPeak,
        value: peakDisplay.valueLabel,
        unit: peakDisplay.unitLabel,
        color: peak > settings.highThreshold ? AppColors.amber : AppColors.text,
      ),
      HistoryStatCardViewModel(
        label: l10n.statCv,
        value: '${tir.cv.toStringAsFixed(0)}%',
        color: tir.cv < 36 ? AppColors.green : AppColors.amber,
      ),
    ];
  }

  Color _tirColor(double tir) {
    if (tir >= 70) return AppColors.green;
    if (tir >= 50) return AppColors.amber;
    return AppColors.rose;
  }

  double _peak(List<GlucoseReading> readings) {
    if (readings.isEmpty) return 0;
    return readings.map((reading) => reading.value).reduce(
          (a, b) => a > b ? a : b,
        );
  }

  String _dateLabel(HistoryDateSection section, HistoryLocalizations l10n) {
    final formatter = LocalizedDateTimeFormatter(l10n.localeName);
    if (!section.isSingleDay) {
      return formatter.dateRange(
        section.rangeStart,
        section.rangeEnd,
        granularity: DateRangeGranularity.short,
      );
    }
    final weekday = formatter.weekdayFull(section.selectedDay);
    final date = formatter.dateShort(section.selectedDay);
    return l10n.localeName.startsWith('zh')
        ? '$weekday，$date'
        : '$weekday, $date';
  }
}

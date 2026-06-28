import 'package:intl/intl.dart';

import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../application/i18n/localized_date_time_formatter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_event.dart';
import '../domain/report_data_quality.dart';
import '../domain/report_range_band.dart';
import '../domain/sections/report_daily_curves_section.dart';
import '../domain/sections/report_episodes_section.dart';
import '../domain/sections/report_header_section.dart';
import '../domain/sections/report_metrics_section.dart';
import '../domain/sections/report_period_analysis_section.dart';
import '../domain/sections/report_ranges_section.dart';
import '../engine/calculators/report_coverage_calculator.dart';
import '../engine/report_engine_output.dart';
import '../application/i18n/report_l10n_resolver.dart';
import '../l10n/generated/report_localizations.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';

class ReportViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;

  const ReportViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  ReportViewModel map({
    required ReportEngineOutput output,
    required List<ReportSectionToggle> sections,
    ReportLocalizations? l10n,
  }) {
    final strings = l10n ?? ReportL10nResolver.fallback;
    return ReportViewModel(
      selectedPeriod: output.period,
      periodOptions: ReportPeriod.values
          .map((item) => ReportPeriodOption(
                period: item,
                selected: item == output.period,
              ))
          .toList(),
      header: _header(output.headerSection, output.settings, strings),
      metrics: _metrics(output.metricsSection, output.settings, strings),
      ranges: _ranges(output.rangesSection, output.settings, strings),
      agpSlots: output.agpSection.slots,
      dailyCurves: _dailyCurves(output.dailyCurvesSection, strings),
      dataQuality:
          _quality(output.metricsSection.quality, output.readings.length),
      periodAnalysis: _periodAnalysis(
          output.periodAnalysisSection, output.settings, strings),
      episodesSummary:
          _episodesSummary(output.episodesSection, output.settings, strings),
      sections: _sections(sections, strings),
      settings: output.settings,
      hasData: output.hasData,
      emptyText: strings.emptyNoReportData,
    );
  }

  ReportHeaderViewModel _header(
    ReportHeaderSection section,
    AppSettings settings,
    ReportLocalizations l10n,
  ) {
    final range = glucoseFormatter.range(
      settings.lowThreshold,
      settings.highThreshold,
      settings.unit,
    );
    final displayDays = section.end.difference(section.start).inDays + 1;
    final readingCount = _decimal(section.readings.length, l10n.localeName);
    return ReportHeaderViewModel(
      periodTitle: l10n.headerPeriod,
      periodLabel: '${_dateFull(section.start, l10n.localeName)} - '
          '${_dateFull(section.end, l10n.localeName)} - '
          '${l10n.unitDays(displayDays)}',
      readingsLabel: l10n.unitReadings(readingCount),
      coverageLabel: l10n.unitWearActive(
          section.quality.wearPercent.toStringAsFixed(0),
          section.quality.activeMinutes),
      dataSourceTitle: l10n.headerDataSource,
      dataSourceLabel:
          _dataSourceLabel(settings, section.readings.isNotEmpty, l10n),
      targetRangeTitle: l10n.headerTargetRange,
      targetRangeLabel: range.fullLabel,
      generatedTitle: l10n.headerGenerated,
      generatedLabel: _dateTime(section.generatedAt, l10n.localeName),
    );
  }

  String _dataSourceLabel(
    AppSettings settings,
    bool hasReadings,
    ReportLocalizations l10n,
  ) {
    final xdrip = settings.xdripSyncEnabled;
    final nightscout = settings.nightscoutSyncEnabled;
    if (xdrip && nightscout) return l10n.sourceNightscoutXdrip;
    if (xdrip) return l10n.sourceXdrip;
    if (nightscout) return l10n.sourceNightscout;
    if (hasReadings) return l10n.sourceLocalCache;
    return l10n.sourceNoData;
  }

  List<ReportMetricViewModel> _metrics(
    ReportMetricsSection section,
    AppSettings settings,
    ReportLocalizations l10n,
  ) {
    final unit = settings.unit;
    final tir = section.tir;
    final quality = section.quality;
    final mean = glucoseFormatter.value(tir.mean, unit);
    final sd = glucoseFormatter.value(tir.sd, unit);
    final tirPercent = quality.percentFor(ReportRangeBand.inRange);
    return [
      ReportMetricViewModel(
        label: l10n.metricTir,
        value: '${tirPercent.toStringAsFixed(0)}%',
        unit: l10n.metricTargetUnit,
        badge: tirPercent >= 70 ? l10n.metricOnTarget : l10n.metricBelowTarget,
        tone: ReportMetricTone.green,
      ),
      ReportMetricViewModel(
        label: l10n.metricAverage,
        value: mean.valueLabel,
        unit: mean.unitLabel,
      ),
      ReportMetricViewModel(
        label: l10n.metricWear,
        value: '${quality.wearPercent.toStringAsFixed(0)}%',
        unit: l10n.metricSensorActive,
        tone: ReportMetricTone.blue,
      ),
      ReportMetricViewModel(
        label: l10n.metricCv,
        value: '${tir.cv.toStringAsFixed(0)}%',
        unit: l10n.metricCvTargetUnit,
      ),
      ReportMetricViewModel(
        label: l10n.metricGmi,
        value: '${tir.gmi.toStringAsFixed(1)}%',
        unit: l10n.metricGmiUnit,
        tone: ReportMetricTone.amber,
      ),
      ReportMetricViewModel(
        label: l10n.metricSd,
        value: sd.valueLabel,
        unit: sd.unitLabel,
      ),
    ];
  }

  List<ReportRangeViewModel> _ranges(
    ReportRangesSection section,
    AppSettings settings,
    ReportLocalizations l10n,
  ) {
    ReportRangeViewModel range({
      required String label,
      required String thresholdLabel,
      required String? levelLabel,
      required ReportRangeBand band,
      required ReportRangeTone tone,
    }) {
      final minutes = section.quality.minutesFor(band);
      return ReportRangeViewModel(
        label: label,
        thresholdLabel: thresholdLabel,
        levelLabel: levelLabel,
        percent: section.quality.percentFor(band),
        minutesPerDay: section.periodDays <= 0
            ? 0
            : (minutes / section.periodDays).round(),
        tone: tone,
      );
    }

    final unit = settings.unit;
    final low = glucoseFormatter.value(settings.lowThreshold, unit).valueLabel;
    final high =
        glucoseFormatter.value(settings.highThreshold, unit).valueLabel;
    final veryHigh =
        glucoseFormatter.value(settings.veryHighThreshold, unit).valueLabel;
    final veryLow = glucoseFormatter
        .value(ReportCoverageCalculator.veryLowMmol, unit)
        .valueLabel;
    return [
      range(
        label: l10n.rangeVeryHigh,
        thresholdLabel: '>$veryHigh',
        levelLabel: 'L2',
        band: ReportRangeBand.veryHigh,
        tone: ReportRangeTone.veryHigh,
      ),
      range(
        label: l10n.rangeHigh,
        thresholdLabel: '$high-$veryHigh',
        levelLabel: 'L1',
        band: ReportRangeBand.high,
        tone: ReportRangeTone.high,
      ),
      range(
        label: l10n.rangeInRange,
        thresholdLabel: '$low-$high',
        levelLabel: null,
        band: ReportRangeBand.inRange,
        tone: ReportRangeTone.inRange,
      ),
      range(
        label: l10n.rangeLow,
        thresholdLabel: '$veryLow-$low',
        levelLabel: 'L1',
        band: ReportRangeBand.low,
        tone: ReportRangeTone.low,
      ),
      range(
        label: l10n.rangeVeryLow,
        thresholdLabel: '<$veryLow',
        levelLabel: 'L2',
        band: ReportRangeBand.veryLow,
        tone: ReportRangeTone.veryLow,
      ),
    ];
  }

  List<ReportDailyCurveViewModel> _dailyCurves(
    ReportDailyCurvesSection section,
    ReportLocalizations l10n,
  ) {
    return [
      for (final curve in section.curves)
        ReportDailyCurveViewModel(
          day: curve.day,
          dayLabel: _dateShort(curve.day, l10n.localeName),
          tir: curve.tir,
          readings: curve.readings,
          sparse: curve.sparse,
        ),
    ];
  }

  String _dateShort(DateTime date, String localeName) {
    return LocalizedDateTimeFormatter(localeName).dateShort(date);
  }

  String _dateFull(DateTime date, String localeName) {
    return LocalizedDateTimeFormatter(localeName).dateFull(date);
  }

  String _dateTime(DateTime date, String localeName) {
    return LocalizedDateTimeFormatter(localeName).dateTime(date);
  }

  String _decimal(int value, String localeName) {
    try {
      return NumberFormat.decimalPattern(localeName).format(value);
    } catch (_) {
      return value.toString();
    }
  }

  ReportDataQualityViewModel _quality(
    ReportDataQuality quality,
    int readingCount,
  ) {
    return ReportDataQualityViewModel(
      wearPercent: quality.wearPercent,
      activeMinutes: quality.activeMinutes,
      expectedMinutes: quality.expectedMinutes,
      readingCount: readingCount,
      duplicateCount: quality.duplicateCount,
      gapCount: quality.gapCount,
    );
  }

  ReportPeriodAnalysisViewModel _periodAnalysis(
    ReportPeriodAnalysisSection section,
    AppSettings settings,
    ReportLocalizations l10n,
  ) {
    final best = section.best;
    final mostVariable = section.mostVariable;
    if (section.rows.isEmpty || best == null || mostVariable == null) {
      return ReportPeriodAnalysisViewModel(
        hasData: false,
        summaryText: l10n.periodAnalysisInsufficient,
        rows: const [],
      );
    }
    return ReportPeriodAnalysisViewModel(
      hasData: true,
      summaryText: l10n.periodAnalysisSummary(
        best.segment.label,
        best.tir.tir.toStringAsFixed(0),
        mostVariable.segment.label,
        mostVariable.tir.cv.toStringAsFixed(0),
      ),
      rows: [
        for (final row in section.rows)
          ReportPeriodRowViewModel(
            label: row.segment.label,
            averageLabel: _formattedValue(row.tir.mean, settings),
            tirLabel: '${row.tir.tir.toStringAsFixed(0)}%',
            cvLabel: '${row.tir.cv.toStringAsFixed(0)}%',
            peakLabel: _formattedValue(row.peak, settings),
          ),
      ],
    );
  }

  ReportEpisodesSummaryViewModel _episodesSummary(
    ReportEpisodesSection section,
    AppSettings settings,
    ReportLocalizations l10n,
  ) {
    if (section.highest == null || section.lowest == null) {
      return ReportEpisodesSummaryViewModel(
        hasData: false,
        highCount: 0,
        lowCount: 0,
        avgHighDurationLabel: '-',
        avgLowDurationLabel: '-',
        nocturnalLowCount: 0,
        highestLabel: '-',
        lowestLabel: '-',
        summaryText: l10n.episodeSummaryInsufficient,
      );
    }
    return ReportEpisodesSummaryViewModel(
      hasData: section.highs.isNotEmpty || section.lows.isNotEmpty,
      highCount: section.highs.length,
      lowCount: section.lows.length,
      avgHighDurationLabel: _avgDuration(section.highs),
      avgLowDurationLabel: _avgDuration(section.lows),
      nocturnalLowCount:
          section.lows.where((event) => event.isNocturnal).length,
      highestLabel: _formattedValue(section.highest!, settings),
      lowestLabel: _formattedValue(section.lowest!, settings),
      summaryText:
          l10n.episodeSummary(section.highs.length, section.lows.length),
    );
  }

  List<ReportSectionToggle> _sections(
    List<ReportSectionToggle> sections,
    ReportLocalizations l10n,
  ) {
    return [
      for (final section in sections)
        ReportSectionToggle(
          key: section.key,
          title: _sectionTitle(section.key, l10n),
          subtitle: _sectionSubtitle(section.key, l10n),
          enabled: section.enabled,
        ),
    ];
  }

  String _sectionTitle(ReportSectionKey key, ReportLocalizations l10n) {
    switch (key) {
      case ReportSectionKey.keyMetrics:
        return l10n.toggleKeyMetricsTitle;
      case ReportSectionKey.agpChart:
        return l10n.toggleAgpChartTitle;
      case ReportSectionKey.dailyCurves:
        return l10n.toggleDailyCurvesTitle;
      case ReportSectionKey.periodAnalysis:
        return l10n.togglePeriodAnalysisTitle;
      case ReportSectionKey.episodesSummary:
        return l10n.toggleEpisodesSummaryTitle;
    }
  }

  String _sectionSubtitle(ReportSectionKey key, ReportLocalizations l10n) {
    switch (key) {
      case ReportSectionKey.keyMetrics:
        return l10n.toggleKeyMetricsSubtitle;
      case ReportSectionKey.agpChart:
        return l10n.toggleAgpChartSubtitle;
      case ReportSectionKey.dailyCurves:
        return l10n.toggleDailyCurvesSubtitle;
      case ReportSectionKey.periodAnalysis:
        return l10n.togglePeriodAnalysisSubtitle;
      case ReportSectionKey.episodesSummary:
        return l10n.toggleEpisodesSummarySubtitle;
    }
  }

  String _formattedValue(double value, AppSettings settings) {
    final formatted = glucoseFormatter.value(value, settings.unit);
    return '${formatted.valueLabel} ${formatted.unitLabel}';
  }

  String _avgDuration(List<GlucoseEvent> events) {
    if (events.isEmpty) return '-';
    final avg =
        events.map((event) => event.durationMinutes).reduce((a, b) => a + b) /
            events.length;
    return '${avg.round()} min';
  }
}

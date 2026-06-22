import 'dart:math' as math;

import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/reporting/application/report_privacy_policy.dart';
import 'package:smart_xdrip/reporting/domain/report_data_quality_summary.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_disclaimer.dart';
import 'package:smart_xdrip/reporting/domain/report_finding.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_section_type.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../../application/episode_detail_formatters.dart';
import '../../application/i18n/episode_detail_l10n_resolver.dart';
import '../../application/text/low_episode_text_builders.dart';
import '../../domain/episode_data_confidence.dart';
import '../../domain/episode_repeat_chart_dataset.dart';
import '../../domain/episode_repeat_time_block_bucket.dart';
import '../../engine/episode_detail_engine_output.dart';
import '../../l10n/generated/episode_detail_localizations.dart';
import 'low_episode_report_payloads.dart';
import 'low_episode_report_section_keys.dart';

class LowEpisodeReportAdapter {
  final GlucoseUnitFormatService formatter;
  final ReportPrivacyPolicy privacyPolicy;
  final LowEpisodeRepeatTextBuilder repeatTextBuilder;
  final DateTime Function() now;

  const LowEpisodeReportAdapter({
    this.formatter = const GlucoseUnitFormatService(),
    this.privacyPolicy = const ReportPrivacyPolicy(),
    this.repeatTextBuilder = const LowEpisodeRepeatTextBuilder(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  ReportSnapshot map(
    EpisodeDetailEngineOutput output, {
    required String? sourceLabel,
    EpisodeDetailLocalizations? l10n,
  }) {
    final strings = l10n ?? EpisodeDetailL10nResolver.fallback;
    final focus = output.focus;
    final burden = output.lowBurden;
    if (focus == null || burden == null || output.chartSection == null) {
      throw StateError('No low episode is available for report export.');
    }
    final generatedAt = now();
    final reportWindowDays = math.max(30, output.lowRepeat?.windowDays ?? 30);
    final start = focus.time.subtract(Duration(days: reportWindowDays - 1));
    final end = focus.endTime ?? focus.time;
    final quality = _qualitySummary(output, strings);
    final disclaimer = ReportDisclaimer(strings.lowReportDisclaimer);
    final findings = _findings(output, strings);
    return ReportSnapshot(
      reportId: 'low_episode_${focus.time.toIso8601String()}',
      title: strings.lowEpisodeReportTitle,
      range: ReportDateRange(start: start, end: end),
      generatedAt: generatedAt,
      sourceLabel:
          privacyPolicy.sourceLabel(sourceLabel ?? _source(output.settings)),
      unit: output.settings.unit,
      dataQuality: quality,
      sections: [
        ReportSection(
          id: 'summary',
          title: strings.lowExposureSummary,
          type: ReportSectionType.metricGrid,
          rendererKey: LowEpisodeReportSectionKeys.exposureSummary,
          payload: _summary(output, strings),
        ),
        ReportSection(
          id: 'curve',
          title: strings.representativeEpisodeCurve,
          type: ReportSectionType.chart,
          rendererKey: LowEpisodeReportSectionKeys.curve,
          payload: _curve(output),
        ),
        ReportSection(
          id: 'lifecycle',
          title: strings.episodeLifecycle,
          type: ReportSectionType.timeline,
          rendererKey: LowEpisodeReportSectionKeys.lifecycle,
          payload: _lifecycle(output, strings),
        ),
        ReportSection(
          id: 'repeat',
          title: strings.repeatPattern,
          type: ReportSectionType.chart,
          rendererKey: LowEpisodeReportSectionKeys.repeat,
          payload: output.lowRepeat == null
              ? null
              : LowEpisodeRepeatPayload(
                  dataset: _localizedRepeatDataset(output, strings),
                ),
        ),
        ReportSection(
          id: 'findings',
          title: strings.reviewNotes,
          type: ReportSectionType.findingList,
          rendererKey: LowEpisodeReportSectionKeys.findings,
          payload: LowEpisodeFindingListPayload(
            findings: [
              for (final finding in findings)
                LowEpisodeReportFindingPayload(
                  title: finding.title,
                  body: finding.body,
                  tone: finding.tone,
                ),
            ],
          ),
        ),
        ReportSection(
          id: 'quality',
          title: strings.dataQuality,
          type: ReportSectionType.dataQuality,
          rendererKey: LowEpisodeReportSectionKeys.quality,
          payload: _quality(output, strings),
        ),
      ],
      findings: findings,
      disclaimer: disclaimer,
    );
  }

  LowEpisodeExposureSummaryPayload _summary(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final burden = output.lowBurden!;
    final unit = output.settings.unit;
    final lowCount = output.lowRepeat?.count ?? 1;
    final lowPercent = _belowRangePercent(output);
    return LowEpisodeExposureSummaryPayload(
      metrics: [
        LowEpisodeReportMetric(
          label: l10n.lowEpisodes,
          value: '$lowCount',
          note: l10n.detectedEvents,
          tone: 'blue',
        ),
        LowEpisodeReportMetric(
          label: l10n.timeBelowRange,
          value: lowPercent == null ? '--' : '${lowPercent.round()}%',
          note: _belowRangeMinutesLabel(output, l10n),
          tone: 'blue',
        ),
        LowEpisodeReportMetric(
          label: l10n.lowestValue,
          value: formatter.value(burden.nadirMmol, unit).valueLabel,
          note: formatter.unitLabel(unit),
          tone: 'blue',
        ),
        LowEpisodeReportMetric(
          label: l10n.medianRecovery,
          value: burden.recoveryMinutes == null
              ? '--'
              : _durationLabel(burden.recoveryMinutes!),
          note: l10n.toAboveLowThreshold,
          tone: 'green',
        ),
      ],
    );
  }

  LowEpisodeCurvePayload _curve(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden!;
    final chart = output.chartSection!;
    final unit = output.settings.unit;
    return LowEpisodeCurvePayload(
      readings: chart.readings,
      unit: unit,
      lowThresholdMmol: output.settings.lowThreshold,
      veryLowThresholdMmol: _veryLowThreshold(output.settings),
      onsetTime: chart.onsetTime,
      nadirTime: chart.peakOrNadirTime,
      recoveryTime: chart.recoveryTime,
      timeRangeStart: chart.timeRangeStart,
      timeRangeEnd: chart.timeRangeEnd,
      nadirLabel: formatter.value(burden.nadirMmol, unit).fullLabel,
      durationBelowRangeLabel: _durationLabel(burden.durationMinutes),
      veryLowMinutesLabel: _veryLowMinutes(output),
      recoveryLabel: chart.recoveryTime == null
          ? '--'
          : EpisodeDetailFormatters.hm(chart.recoveryTime!),
    );
  }

  LowEpisodeLifecyclePayload _lifecycle(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final burden = output.lowBurden!;
    final context = output.lowContext;
    final chart = output.chartSection!;
    final unit = output.settings.unit;
    final baseline = context?.baselineHighMmol ?? context?.baselineLowMmol;
    return LowEpisodeLifecyclePayload(
      steps: [
        LowEpisodeLifecycleStepPayload(
          code: 'B',
          label: l10n.baseline,
          value: baseline == null
              ? '--'
              : formatter.value(baseline, unit).fullLabel,
          tone: 'neutral',
        ),
        LowEpisodeLifecycleStepPayload(
          code: 'D',
          label: l10n.descent,
          value: formatter
              .rate(
                -burden.descentRateMmolPerMin.abs(),
                unit,
              )
              .fullLabel,
          tone: 'amber',
        ),
        LowEpisodeLifecycleStepPayload(
          code: 'N',
          label: l10n.nadir,
          value: formatter.value(burden.nadirMmol, unit).valueLabel,
          tone: 'blue',
        ),
        LowEpisodeLifecycleStepPayload(
          code: 'L',
          label: l10n.lowTime,
          value: _durationLabel(burden.durationMinutes),
          tone: 'blue',
        ),
        LowEpisodeLifecycleStepPayload(
          code: 'OK',
          label: l10n.recovery,
          value: chart.recoveryTime == null
              ? '--'
              : EpisodeDetailFormatters.hm(chart.recoveryTime!),
          tone: 'green',
        ),
      ],
    );
  }

  LowEpisodeQualityPayload _quality(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final reliability = output.lowReliability;
    return LowEpisodeQualityPayload(
      metrics: [
        LowEpisodeReportMetric(
          label: l10n.coverage,
          value: _coverageLabel(output),
          note: l10n.episodeWindow,
          tone: 'green',
        ),
        LowEpisodeReportMetric(
          label: l10n.readings,
          value: reliability == null ? '--' : '${reliability.readingsInWindow}',
          note: l10n.visibleInWindow,
          tone: 'neutral',
        ),
        LowEpisodeReportMetric(
          label: l10n.largestGap,
          value: reliability == null
              ? '--'
              : '${reliability.largestGapMinutes} min',
          note: l10n.betweenReadings,
          tone: 'amber',
        ),
        LowEpisodeReportMetric(
          label: l10n.confidence,
          value: _confidenceLabel(reliability?.confidence, l10n),
          note: l10n.episodeReview,
          tone: 'blue',
        ),
      ],
    );
  }

  EpisodeRepeatChartDataset _localizedRepeatDataset(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final repeat = output.lowRepeat!;
    final dataset = repeat.chartDataset;
    final blockLabel = _timeBlockLabel(dataset.dominantBlockLabel, l10n);
    final rangeSuffix = dataset.dominantRangeLabel == null
        ? ''
        : ' (${dataset.dominantRangeLabel})';
    final facts = {
      'count': repeat.count,
      'windowDays': dataset.windowDays,
      'range': repeat.range ?? l10n.samePartOfDay,
      'blockLabel': blockLabel,
      'rangeSuffix': rangeSuffix,
    };
    return EpisodeRepeatChartDataset(
      windowDays: dataset.windowDays,
      repeatCount: dataset.repeatCount,
      dominantBlockLabel: blockLabel,
      dominantRangeLabel: dataset.dominantRangeLabel,
      dayMarks: dataset.dayMarks,
      timeBlockBuckets: [
        for (final bucket in dataset.timeBlockBuckets)
          EpisodeRepeatTimeBlockBucket(
            label: _timeBlockLabel(bucket.label, l10n),
            count: bucket.count,
            normalizedHeight: bucket.normalizedHeight,
            isDominant: bucket.isDominant,
            isSecondary: bucket.isSecondary,
          ),
      ],
      takeaway: repeatTextBuilder.takeaway(
        repeat.type,
        facts,
        context: PluginTextRenderContext(locale: l10n.localeName),
      ),
    );
  }

  List<ReportFinding> _findings(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final burden = output.lowBurden!;
    final repeat = output.lowRepeat;
    return [
      ReportFinding(
        title: _driverTitle(output, l10n),
        body: l10n.lowReportBelowRangeDurationNadir(
          _durationLabel(burden.durationMinutes),
          formatter.value(burden.nadirMmol, output.settings.unit).fullLabel,
        ),
        tone: 'blue',
      ),
      ReportFinding(
        title: repeat == null
            ? l10n.repeatTimingLimited
            : l10n.repeatTimingVisible,
        body: repeat == null
            ? l10n.repeatTimingInsufficientData
            : l10n.lowReportRepeatCount(
                repeat.bigStat,
                repeat.windowDays,
              ),
        tone: 'amber',
      ),
      ReportFinding(
        title: l10n.lowReportContextTitle,
        body: l10n.lowReportContextBody,
        tone: 'amber',
      ),
    ];
  }

  String _driverTitle(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final driver = output.lowDriver?.type;
    if (driver == null) return l10n.lowDriverDuration;
    return switch (driver.name) {
      'nadir' => l10n.lowDriverNadir,
      'fastDescent' => l10n.lowDriverFastDescent,
      'slowRecovery' => l10n.lowDriverSlowRecovery,
      'nocturnalTiming' => l10n.lowDriverNocturnal,
      'repeatPattern' => l10n.lowDriverRepeat,
      'mixed' => l10n.lowDriverMixed,
      _ => l10n.lowDriverDuration,
    };
  }

  ReportDataQualitySummary _qualitySummary(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final reliability = output.lowReliability;
    return ReportDataQualitySummary(
      label: _confidenceLabel(reliability?.confidence, l10n),
      coveragePercent: _coveragePercent(output),
      readingCount: reliability?.readingsInWindow,
      largestGapMinutes: reliability?.largestGapMinutes,
    );
  }

  double? _belowRangePercent(EpisodeDetailEngineOutput output) {
    final readings = output.chartSection?.readings ?? const [];
    if (readings.isEmpty) return null;
    final low = output.settings.lowThreshold;
    final count = readings.where((reading) => reading.value < low).length;
    return count / readings.length * 100;
  }

  String _belowRangeMinutesLabel(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final chart = output.chartSection;
    if (chart == null || chart.readings.length < 2) {
      return l10n.insufficientData;
    }
    final low = output.settings.lowThreshold;
    var minutes = 0;
    for (var i = 1; i < chart.readings.length; i++) {
      if (chart.readings[i - 1].value < low) {
        minutes += chart.readings[i].timestamp
            .difference(chart.readings[i - 1].timestamp)
            .inMinutes;
      }
    }
    return minutes <= 0
        ? l10n.episodeWindow
        : '${minutes}m ${l10n.belowLowThreshold}';
  }

  double? _coveragePercent(EpisodeDetailEngineOutput output) {
    final reliability = output.lowReliability;
    if (reliability == null || reliability.readingsInWindow == 0) return null;
    final chart = output.chartSection;
    if (chart == null) return null;
    final minutes = math.max(
      1,
      chart.timeRangeEnd.difference(chart.timeRangeStart).inMinutes,
    );
    final expected = math.max(1, (minutes / 5).round());
    return (reliability.readingsInWindow / expected * 100).clamp(0, 100);
  }

  String _coverageLabel(EpisodeDetailEngineOutput output) {
    final value = _coveragePercent(output);
    return value == null ? '--' : '${value.round()}%';
  }

  String _veryLowMinutes(EpisodeDetailEngineOutput output) {
    final chart = output.chartSection!;
    final readings = chart.readings;
    if (readings.length < 2) return '--';
    final veryLow = _veryLowThreshold(output.settings);
    var minutes = 0;
    for (var i = 1; i < readings.length; i++) {
      if (readings[i - 1].value < veryLow) {
        minutes += readings[i]
            .timestamp
            .difference(readings[i - 1].timestamp)
            .inMinutes;
      }
    }
    return '${minutes.clamp(0, 24 * 60)}m';
  }

  double _veryLowThreshold(AppSettings settings) =>
      math.min(settings.lowThreshold, 3.0);

  String _durationLabel(int minutes) {
    if (minutes <= 0) return '--';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  String _confidenceLabel(
    EpisodeDataConfidence? confidence,
    EpisodeDetailLocalizations l10n,
  ) {
    return switch (confidence) {
      EpisodeDataConfidence.high => l10n.reportRepresentative,
      EpisodeDataConfidence.medium => l10n.reportLimited,
      EpisodeDataConfidence.low => l10n.reportInsufficient,
      null => l10n.reportLimited,
    };
  }

  String _timeBlockLabel(String label, EpisodeDetailLocalizations l10n) {
    switch (label.toLowerCase()) {
      case 'night':
        return l10n.timeBlockNight;
      case 'dawn':
        return l10n.timeBlockDawn;
      case 'morning':
        return l10n.timeBlockMorning;
      case 'afternoon':
        return l10n.timeBlockAfternoon;
      case 'evening':
        return l10n.timeBlockEvening;
      default:
        return label;
    }
  }

  String _source(AppSettings settings) {
    if (settings.xdripSyncEnabled) return 'xDrip+ Local';
    if (settings.nightscoutSyncEnabled) return 'Nightscout';
    return 'SolgoInsight';
  }
}

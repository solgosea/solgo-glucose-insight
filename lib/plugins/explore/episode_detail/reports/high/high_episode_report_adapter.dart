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
import '../../application/text/high_episode_text_builders.dart';
import '../../domain/episode_data_confidence.dart';
import '../../domain/episode_repeat_chart_dataset.dart';
import '../../domain/episode_repeat_time_block_bucket.dart';
import '../../engine/episode_detail_engine_output.dart';
import '../../l10n/generated/episode_detail_localizations.dart';
import 'high_episode_report_payloads.dart';
import 'high_episode_report_section_keys.dart';

class HighEpisodeReportAdapter {
  final GlucoseUnitFormatService formatter;
  final ReportPrivacyPolicy privacyPolicy;
  final HighEpisodeRepeatTextBuilder repeatTextBuilder;
  final DateTime Function() now;

  const HighEpisodeReportAdapter({
    this.formatter = const GlucoseUnitFormatService(),
    this.privacyPolicy = const ReportPrivacyPolicy(),
    this.repeatTextBuilder = const HighEpisodeRepeatTextBuilder(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  ReportSnapshot map(
    EpisodeDetailEngineOutput output, {
    required String? sourceLabel,
    EpisodeDetailLocalizations? l10n,
  }) {
    final strings = l10n ?? EpisodeDetailL10nResolver.fallback;
    final focus = output.focus;
    final burden = output.highBurden;
    if (focus == null || burden == null || output.chartSection == null) {
      throw StateError('No high episode is available for report export.');
    }
    final generatedAt = now();
    final reportWindowDays = math.max(
      30,
      output.highRepeat?.windowDays ?? 30,
    );
    final start = focus.time.subtract(Duration(days: reportWindowDays - 1));
    final end = focus.endTime ?? focus.time;
    final quality = _qualitySummary(output, strings);
    final disclaimer = ReportDisclaimer(strings.highReportDisclaimer);
    final findings = _findings(output, strings);
    return ReportSnapshot(
      reportId: 'high_episode_${focus.time.toIso8601String()}',
      title: strings.highEpisodeReportTitle,
      range: ReportDateRange(start: start, end: end),
      generatedAt: generatedAt,
      sourceLabel:
          privacyPolicy.sourceLabel(sourceLabel ?? _source(output.settings)),
      unit: output.settings.unit,
      dataQuality: quality,
      sections: [
        ReportSection(
          id: '01',
          title: strings.highExposureSummary,
          type: ReportSectionType.metricGrid,
          rendererKey: HighEpisodeReportSectionKeys.exposureSummary,
          payload: _summary(output, strings),
        ),
        ReportSection(
          id: '02',
          title: strings.representativeEpisodeCurve,
          type: ReportSectionType.chart,
          rendererKey: HighEpisodeReportSectionKeys.curve,
          payload: _curve(output),
        ),
        ReportSection(
          id: '03',
          title: strings.episodeLifecycle,
          type: ReportSectionType.timeline,
          rendererKey: HighEpisodeReportSectionKeys.lifecycle,
          payload: _lifecycle(output, strings),
        ),
        ReportSection(
          id: '04',
          title: strings.repeatPattern,
          type: ReportSectionType.chart,
          rendererKey: HighEpisodeReportSectionKeys.repeat,
          payload: output.highRepeat == null
              ? null
              : HighEpisodeRepeatPayload(
                  dataset: _localizedRepeatDataset(output, strings),
                ),
        ),
        ReportSection(
          id: '05',
          title: strings.reviewNotes,
          type: ReportSectionType.findingList,
          rendererKey: HighEpisodeReportSectionKeys.findings,
          payload: HighEpisodeFindingListPayload(
            findings: [
              for (final finding in findings)
                HighEpisodeReportFindingPayload(
                  title: finding.title,
                  body: finding.body,
                  tone: finding.tone,
                ),
            ],
          ),
        ),
        ReportSection(
          id: '06',
          title: strings.dataQuality,
          type: ReportSectionType.dataQuality,
          rendererKey: HighEpisodeReportSectionKeys.quality,
          payload: _quality(output, strings),
        ),
      ],
      findings: findings,
      disclaimer: disclaimer,
    );
  }

  HighEpisodeExposureSummaryPayload _summary(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final burden = output.highBurden!;
    final chart = output.chartSection!;
    final unit = output.settings.unit;
    final highCount = output.highRepeat?.count ?? 1;
    final highPercent = _aboveRangePercent(output);
    return HighEpisodeExposureSummaryPayload(
      metrics: [
        HighEpisodeReportMetric(
          label: l10n.highEpisodes,
          value: '$highCount',
          note: l10n.pastDays(output.highRepeat?.windowDays ?? 30),
          tone: 'amber',
        ),
        HighEpisodeReportMetric(
          label: l10n.timeAboveRange,
          value: highPercent == null ? '--' : '${highPercent.round()}%',
          note: chart.readings.isEmpty
              ? l10n.insufficientData
              : l10n.episodeWindow,
          tone: 'amber',
        ),
        HighEpisodeReportMetric(
          label: l10n.highestPeak,
          value: formatter.value(burden.peakMmol, unit).valueLabel,
          note: formatter.unitLabel(unit),
          tone: 'rose',
        ),
        HighEpisodeReportMetric(
          label: l10n.medianReturn,
          value: burden.recoveryMinutes == null
              ? '--'
              : _durationLabel(burden.recoveryMinutes!),
          note: l10n.toBelowHighThreshold,
          tone: 'blue',
        ),
      ],
    );
  }

  HighEpisodeCurvePayload _curve(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden!;
    final chart = output.chartSection!;
    final unit = output.settings.unit;
    return HighEpisodeCurvePayload(
      readings: chart.readings,
      unit: unit,
      highThresholdMmol: output.settings.highThreshold,
      veryHighThresholdMmol: output.settings.veryHighThreshold,
      onsetTime: chart.onsetTime,
      peakTime: chart.peakOrNadirTime,
      returnTime: chart.recoveryTime,
      timeRangeStart: chart.timeRangeStart,
      timeRangeEnd: chart.timeRangeEnd,
      peakLabel: formatter.value(burden.peakMmol, unit).fullLabel,
      durationAboveRangeLabel: _durationLabel(burden.durationMinutes),
      veryHighMinutesLabel: _veryHighMinutes(output),
      returnLabel: chart.recoveryTime == null
          ? '--'
          : EpisodeDetailFormatters.hm(chart.recoveryTime!),
    );
  }

  HighEpisodeLifecyclePayload _lifecycle(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final burden = output.highBurden!;
    final context = output.highContext;
    final chart = output.chartSection!;
    final unit = output.settings.unit;
    final baseline = context?.baselineHighMmol ?? context?.baselineLowMmol;
    return HighEpisodeLifecyclePayload(
      steps: [
        HighEpisodeLifecycleStepPayload(
          code: 'B',
          label: l10n.baseline,
          value: baseline == null
              ? '--'
              : formatter.value(baseline, unit).fullLabel,
          tone: 'neutral',
        ),
        HighEpisodeLifecycleStepPayload(
          code: 'R',
          label: l10n.rise,
          value: formatter.rate(burden.riseRateMmolPerMin, unit).fullLabel,
          tone: 'amber',
        ),
        HighEpisodeLifecycleStepPayload(
          code: 'P',
          label: l10n.peak,
          value: formatter.value(burden.peakMmol, unit).valueLabel,
          tone: 'rose',
        ),
        HighEpisodeLifecycleStepPayload(
          code: 'D',
          label: l10n.duration,
          value: _durationLabel(burden.durationMinutes),
          tone: 'amber',
        ),
        HighEpisodeLifecycleStepPayload(
          code: 'OK',
          label: l10n.returnLabel,
          value: chart.recoveryTime == null
              ? '--'
              : EpisodeDetailFormatters.hm(chart.recoveryTime!),
          tone: 'green',
        ),
      ],
    );
  }

  HighEpisodeQualityPayload _quality(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final reliability = output.highReliability;
    return HighEpisodeQualityPayload(
      metrics: [
        HighEpisodeReportMetric(
          label: l10n.coverage,
          value: _coverageLabel(output),
          note: l10n.episodeWindow,
          tone: 'green',
        ),
        HighEpisodeReportMetric(
          label: l10n.readings,
          value: reliability == null ? '--' : '${reliability.readingsInWindow}',
          note: l10n.visibleInWindow,
          tone: 'neutral',
        ),
        HighEpisodeReportMetric(
          label: l10n.largestGap,
          value: reliability == null
              ? '--'
              : '${reliability.largestGapMinutes} min',
          note: l10n.betweenReadings,
          tone: 'amber',
        ),
        HighEpisodeReportMetric(
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
    final repeat = output.highRepeat!;
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
    final burden = output.highBurden!;
    final repeat = output.highRepeat;
    return [
      ReportFinding(
        title: _driverTitle(output, l10n),
        body: l10n.highReportAboveRangeDuration(
          _durationLabel(burden.durationMinutes),
        ),
        tone: 'rose',
      ),
      ReportFinding(
        title: repeat == null
            ? l10n.repeatTimingLimited
            : l10n.repeatTimingVisible,
        body: repeat == null
            ? l10n.repeatTimingInsufficientData
            : l10n.highReportRepeatCount(
                repeat.bigStat,
                repeat.windowDays,
              ),
        tone: 'amber',
      ),
      ReportFinding(
        title: l10n.highReportNoCauseTitle,
        body: l10n.highReportNoCauseBody,
        tone: 'blue',
      ),
    ];
  }

  String _driverTitle(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final driver = output.highDriver?.type;
    if (driver == null) return l10n.highDriverDuration;
    return switch (driver.name) {
      'peak' => l10n.highDriverPeak,
      'fastRise' => l10n.highDriverFastRise,
      'slowRecovery' => l10n.highDriverSlowRecovery,
      'repeatPattern' => l10n.highDriverRepeat,
      'mixed' => l10n.highDriverMixed,
      _ => l10n.highDriverDuration,
    };
  }

  ReportDataQualitySummary _qualitySummary(
    EpisodeDetailEngineOutput output,
    EpisodeDetailLocalizations l10n,
  ) {
    final reliability = output.highReliability;
    return ReportDataQualitySummary(
      label: _confidenceLabel(reliability?.confidence, l10n),
      coveragePercent: _coveragePercent(output),
      readingCount: reliability?.readingsInWindow,
      largestGapMinutes: reliability?.largestGapMinutes,
    );
  }

  double? _aboveRangePercent(EpisodeDetailEngineOutput output) {
    final readings = output.chartSection?.readings ?? const [];
    if (readings.isEmpty) return null;
    final high = output.settings.highThreshold;
    final count = readings.where((reading) => reading.value > high).length;
    return count / readings.length * 100;
  }

  double? _coveragePercent(EpisodeDetailEngineOutput output) {
    final reliability = output.highReliability;
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

  String _veryHighMinutes(EpisodeDetailEngineOutput output) {
    final chart = output.chartSection!;
    final readings = chart.readings;
    if (readings.length < 2) return '--';
    var minutes = 0;
    for (var i = 1; i < readings.length; i++) {
      if (readings[i - 1].value > output.settings.veryHighThreshold) {
        minutes += readings[i]
            .timestamp
            .difference(readings[i - 1].timestamp)
            .inMinutes;
      }
    }
    return '${minutes.clamp(0, 24 * 60)}m';
  }

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

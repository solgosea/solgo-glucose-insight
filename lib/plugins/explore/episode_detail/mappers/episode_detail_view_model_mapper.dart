import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';

import '../application/episode_detail_formatters.dart';
import '../application/i18n/episode_detail_l10n_resolver.dart';
import '../application/text/episode_detail_text_renderer.dart';
import '../application/text/high_episode_text_builders.dart';
import '../application/text/low_episode_text_builders.dart';
import '../domain/episode_data_confidence.dart';
import '../domain/high_episode_driver_type.dart';
import '../domain/high_episode_lifecycle_step.dart';
import '../domain/high_episode_review_priority.dart';
import '../domain/low_episode_driver_type.dart';
import '../domain/low_episode_lifecycle_step.dart';
import '../domain/low_episode_recovery_quality.dart';
import '../domain/low_episode_review_priority.dart';
import '../domain/episode_similar_chart_point.dart';
import '../domain/episode_similar_match.dart';
import '../domain/text/episode_detail_text_slot.dart';
import '../domain/text/episode_detail_text_type.dart';
import '../engine/episode_detail_engine_output.dart';
import '../l10n/generated/episode_detail_localizations.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../shared/episode_pattern_card.dart';

class EpisodeDetailViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final EpisodeDetailTextRenderer textRenderer;
  final HighEpisodeSummaryTextBuilder summaryTextBuilder;
  final HighEpisodeBurdenTextBuilder burdenTextBuilder;
  final HighEpisodeDriverTextBuilder driverTextBuilder;
  final HighEpisodeContextTextBuilder contextTextBuilder;
  final HighEpisodeRepeatTextBuilder repeatTextBuilder;
  final HighEpisodeReliabilityTextBuilder reliabilityTextBuilder;
  final LowEpisodeSummaryTextBuilder lowSummaryTextBuilder;
  final LowEpisodeBurdenTextBuilder lowBurdenTextBuilder;
  final LowEpisodeDriverTextBuilder lowDriverTextBuilder;
  final LowEpisodeRecoveryTextBuilder lowRecoveryTextBuilder;
  final LowEpisodeContextTextBuilder lowContextTextBuilder;
  final LowEpisodeRepeatTextBuilder lowRepeatTextBuilder;
  final LowEpisodeReliabilityTextBuilder lowReliabilityTextBuilder;
  final EpisodeDetailLocalizations? l10n;

  const EpisodeDetailViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.textRenderer = const EpisodeDetailTextRenderer(),
    this.summaryTextBuilder = const HighEpisodeSummaryTextBuilder(),
    this.burdenTextBuilder = const HighEpisodeBurdenTextBuilder(),
    this.driverTextBuilder = const HighEpisodeDriverTextBuilder(),
    this.contextTextBuilder = const HighEpisodeContextTextBuilder(),
    this.repeatTextBuilder = const HighEpisodeRepeatTextBuilder(),
    this.reliabilityTextBuilder = const HighEpisodeReliabilityTextBuilder(),
    this.lowSummaryTextBuilder = const LowEpisodeSummaryTextBuilder(),
    this.lowBurdenTextBuilder = const LowEpisodeBurdenTextBuilder(),
    this.lowDriverTextBuilder = const LowEpisodeDriverTextBuilder(),
    this.lowRecoveryTextBuilder = const LowEpisodeRecoveryTextBuilder(),
    this.lowContextTextBuilder = const LowEpisodeContextTextBuilder(),
    this.lowRepeatTextBuilder = const LowEpisodeRepeatTextBuilder(),
    this.lowReliabilityTextBuilder = const LowEpisodeReliabilityTextBuilder(),
    this.l10n,
  });

  EpisodeDetailLocalizations get _strings =>
      l10n ?? EpisodeDetailL10nResolver.fallback;

  PluginTextRenderContext get _textContext =>
      PluginTextRenderContext(locale: _strings.localeName);

  EpisodeDetailViewModel map(EpisodeDetailEngineOutput output) {
    final strings = _strings;
    final focus = output.focus;
    if (focus == null || output.window == null || output.chartSection == null) {
      return _empty(output);
    }

    final high = output.query.kind == EpisodeKind.high;
    final unit = output.settings.unit;
    final themeColor = high ? AppColors.rose : AppColors.blue;
    final window = output.window!;
    final chart = output.chartSection!;
    final duration = math.max(focus.durationMinutes, 0);
    final extreme = _extremeValue(focus, window.extremeReading);
    final rate = _episodeRate(focus, window.leadUpSlope, high);
    final recoveryRate = _recoveryRate(
      extreme: extreme,
      duration: duration,
      high: high,
    );
    final area = _episodeArea(focus, extreme, duration, high, output.settings);

    final hero = EpisodeHeroViewModel(
      valueLabel: high ? strings.peakValue : strings.nadirValue,
      valueText: glucoseFormatter.value(extreme, unit).valueLabel,
      valueUnit: glucoseFormatter.unitLabel(unit),
      valueColor: themeColor,
      durationText: '$duration min',
      durationRange: EpisodeDetailFormatters.range(
        focus.time,
        chart.episodeEndTime,
      ),
      onsetRateLabel: high ? strings.onsetRate : strings.descentRate,
      onsetRateText: EpisodeDetailFormatters.rate(
        rate,
        unit: unit,
        forcePositive: high && rate >= 0,
      ),
      onsetRateColor: high ? AppColors.amber : AppColors.blue,
      recoveryRateText: EpisodeDetailFormatters.rate(
        recoveryRate,
        unit: unit,
        forcePositive: !high && recoveryRate >= 0,
      ),
      areaLabel: high ? strings.areaAboveTarget : strings.areaBelowTarget,
      areaText: glucoseFormatter.area(area.abs(), unit).fullLabel,
      areaColor: themeColor,
      heroBg: themeColor.withOpacity(0.06),
      heroBorder: themeColor.withOpacity(0.22),
      showNocturnalBadge: !high && focus.isNocturnal,
    );

    return EpisodeDetailViewModel(
      kind: output.query.kind,
      statusTime: EpisodeDetailFormatters.hm(focus.time),
      title: _episodeTitle(output.query.kind),
      subtitle: _headerEpisodeRange(
        focus.time,
        focus.endTime,
      ),
      hero: hero,
      chart: EpisodeChartViewModel(
        readings: chart.readings,
        unit: unit,
        lowThreshold: chart.lowThreshold,
        highThreshold: chart.highThreshold,
        onsetTime: chart.onsetTime,
        peakOrNadirTime: chart.peakOrNadirTime,
        episodeEndTime: chart.episodeEndTime,
        recoveryTime: chart.recoveryTime,
        timeRangeStart: chart.timeRangeStart,
        timeRangeEnd: chart.timeRangeEnd,
        themeColor: themeColor,
        episode: ChartEpisode(
          start: focus.time,
          end: chart.episodeEndTime,
          color: themeColor,
        ),
      ),
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: strings.similarEpisodesPastDays(
        output.similarSection.windowDays,
      ),
      similarCards: const [],
      similarChart: _similarChart(output, high: high, unit: unit),
      disclaimer: _detailText(high ? 'highDisclaimer' : 'lowDisclaimer'),
      emptyText: '',
      highSummary: high ? _highSummary(output) : null,
      highBurden: high ? _highBurden(output) : null,
      highLifecycle: high ? _highLifecycle(output) : null,
      highDriver: high ? _highDriver(output) : null,
      highContext: high ? _highContext(output) : null,
      highRepeat: high ? _highRepeat(output) : null,
      highReliability: high ? _highReliability(output) : null,
      lowSummary: high ? null : _lowSummary(output),
      lowBurden: high ? null : _lowBurden(output),
      lowLifecycle: high ? null : _lowLifecycle(output),
      lowDriver: high ? null : _lowDriver(output),
      lowRecovery: high ? null : _lowRecovery(output),
      lowContext: high ? null : _lowContext(output),
      lowRepeat: high ? null : _lowRepeat(output),
      lowReliability: high ? null : _lowReliability(output),
    );
  }

  EpisodeDetailViewModel _empty(EpisodeDetailEngineOutput output) {
    final high = output.query.kind == EpisodeKind.high;
    return EpisodeDetailViewModel(
      kind: output.query.kind,
      statusTime: '',
      title: _episodeTitle(output.query.kind),
      subtitle: _emptySubtitle(output),
      hero: null,
      chart: null,
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: '',
      similarCards: const [],
      disclaimer: '',
      emptyText: output.query.isFocused
          ? _focusedMissingText(output)
          : _detailText(high ? 'highEmpty' : 'lowEmpty'),
    );
  }

  HighEpisodeSummaryViewModel? _highSummary(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden;
    final driver = output.highDriver;
    final recovery = output.highRecovery;
    if (burden == null || driver == null) return null;
    final unit = output.settings.unit;
    final facts = _highFacts(output);
    return HighEpisodeSummaryViewModel(
      priorityLabel: _priorityLabel(burden.priority),
      priorityColor: _priorityColor(burden.priority),
      title: summaryTextBuilder.title(
        burden.priority,
        facts,
        context: _textContext,
      ),
      subtitle: summaryTextBuilder.subtitle(
        burden.priority,
        facts,
        context: _textContext,
      ),
      peakText: glucoseFormatter.value(burden.peakMmol, unit).fullLabel,
      durationText: '${burden.durationMinutes} min',
      recoveryTimeText: _recoveryTimeText(recovery?.recoveryTime),
    );
  }

  HighEpisodeBurdenViewModel? _highBurden(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden;
    if (burden == null) return null;
    final unit = output.settings.unit;
    return HighEpisodeBurdenViewModel(
      note: burdenTextBuilder.note(
        burden.priority,
        _highFacts(output),
        context: _textContext,
      ),
      metrics: [
        HighEpisodeBurdenMetricViewModel(
          label: _strings.peak,
          value: glucoseFormatter.value(burden.peakMmol, unit).fullLabel,
          note: _strings.overTarget(
            '+${glucoseFormatter.value(burden.peakOverThresholdMmol, unit).fullLabel}',
          ),
          accent: AppColors.rose,
        ),
        HighEpisodeBurdenMetricViewModel(
          label: _strings.duration,
          value: '${burden.durationMinutes} min',
          note: _strings.timeAboveRange,
          accent: AppColors.amber,
        ),
        HighEpisodeBurdenMetricViewModel(
          label: _strings.exposure,
          value: glucoseFormatter.area(burden.areaAboveTarget, unit).fullLabel,
          note: _strings.areaAboveTarget,
          accent: AppColors.rose,
        ),
        HighEpisodeBurdenMetricViewModel(
          label: _strings.recovery,
          value: burden.recoveryMinutes == null
              ? _strings.notVisible
              : '${burden.recoveryMinutes}m',
          note: _strings.returnTowardRange,
          accent: AppColors.green,
        ),
      ],
    );
  }

  HighEpisodeLifecycleViewModel? _highLifecycle(
    EpisodeDetailEngineOutput output,
  ) {
    final focus = output.focus;
    final window = output.window;
    final burden = output.highBurden;
    final recovery = output.highRecovery;
    if (focus == null || window == null || burden == null) return null;
    final context = output.highContext;
    final unit = output.settings.unit;
    final baselineLow = context?.baselineLowMmol ?? window.baselineLow;
    final baselineHigh = context?.baselineHighMmol ?? window.baselineHigh;
    final riseRate = focus.ratePerMin ?? window.leadUpSlope;
    final steps = [
      HighEpisodeLifecycleStep(
        code: 'B',
        label: _strings.baseline,
        value: _compactRangeText(
          lowMmol: baselineLow,
          highMmol: baselineHigh,
          unit: unit,
        ),
        tone: HighEpisodeLifecycleStepTone.neutral,
      ),
      HighEpisodeLifecycleStep(
        code: 'R',
        label: _strings.rise,
        value: _compactRateText(riseRate, unit),
        tone: HighEpisodeLifecycleStepTone.warning,
      ),
      HighEpisodeLifecycleStep(
        code: 'P',
        label: _strings.peak,
        value: glucoseFormatter.value(burden.peakMmol, unit).valueLabel,
        tone: HighEpisodeLifecycleStepTone.hot,
      ),
      HighEpisodeLifecycleStep(
        code: 'D',
        label: _strings.duration,
        value: '${burden.durationMinutes} min',
        tone: HighEpisodeLifecycleStepTone.warning,
      ),
      HighEpisodeLifecycleStep(
        code: 'OK',
        label: _strings.recovery,
        value: _recoveryTimeText(recovery?.recoveryTime),
        tone: HighEpisodeLifecycleStepTone.recovered,
      ),
    ];
    return HighEpisodeLifecycleViewModel(
      steps: steps
          .map(
            (step) => HighEpisodeLifecycleStepViewModel(
              code: step.code,
              label: step.label,
              value: step.value,
              color: _lifecycleColor(step.tone),
            ),
          )
          .toList(),
    );
  }

  HighEpisodeDriverViewModel? _highDriver(EpisodeDetailEngineOutput output) {
    final driver = output.highDriver;
    if (driver == null) return null;
    final facts = _highFacts(output);
    return HighEpisodeDriverViewModel(
      title: driverTextBuilder.title(
        driver.type,
        facts,
        context: _textContext,
      ),
      body: driverTextBuilder.body(
        driver.type,
        facts,
        context: _textContext,
      ),
      driverLabel: _driverLabel(driver.type),
      peakScore: driver.peakScore,
      durationScore: math.max(driver.durationScore, driver.areaScore),
      riseScore: driver.riseScore,
      recoveryScore: driver.recoveryScore,
      repeatScore: driver.repeatScore,
    );
  }

  HighEpisodeContextViewModel? _highContext(EpisodeDetailEngineOutput output) {
    final context = output.highContext;
    final burden = output.highBurden;
    final window = output.window;
    if (context == null || burden == null || window == null) return null;
    final unit = output.settings.unit;
    final usualPeakRange = context.usualPeakLowMmol == null ||
            context.usualPeakHighMmol == null
        ? null
        : glucoseFormatter
            .range(context.usualPeakLowMmol!, context.usualPeakHighMmol!, unit)
            .fullLabel;
    final peakLabel = glucoseFormatter.value(burden.peakMmol, unit).fullLabel;
    final aboveUsual = context.usualPeakHighMmol != null &&
        burden.peakMmol > context.usualPeakHighMmol!;
    final hasBaseline =
        context.baselineLowMmol != null && context.baselineHighMmol != null;
    final baselineRange = hasBaseline
        ? glucoseFormatter
            .range(context.baselineLowMmol!, context.baselineHighMmol!, unit)
            .fullLabel
        : _strings.unknown;
    final leadUpSlope = context.leadUpSlope;
    final stableLeadUp = leadUpSlope == null || leadUpSlope.abs() < 0.04;
    final cv = context.variabilityCv;
    final variableWindow = cv != null && cv >= 30;
    return HighEpisodeContextViewModel(
      note: contextTextBuilder.note(_highFacts(output), context: _textContext),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: _strings.peakVsUsualDailyPeak,
          value: '${_strings.current} $peakLabel',
          detail: usualPeakRange == null
              ? _strings.baselineUnavailable
              : _strings.baselineValue(usualPeakRange),
          badgeLabel: usualPeakRange == null
              ? _strings.unknown
              : aboveUsual
                  ? _strings.above
                  : _strings.within,
          badgeColor: usualPeakRange == null
              ? AppColors.amber
              : aboveUsual
                  ? AppColors.rose
                  : AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: _strings.preOnsetBaseline,
          value:
              EpisodeDetailFormatters.range(window.start, window.preMidpoint),
          detail: baselineRange,
          badgeLabel: hasBaseline
              ? stableLeadUp
                  ? _strings.stable
                  : _strings.rising
              : _strings.unknown,
          badgeColor: hasBaseline
              ? stableLeadUp
                  ? AppColors.green
                  : AppColors.amber
              : AppColors.amber,
        ),
        HighEpisodeContextMetricViewModel(
          label: context.variabilityLabel == null
              ? _strings.timeWindowVariability
              : _strings.variabilityLabel(
                  _periodVariabilityLabel(context.variabilityLabel!),
                ),
          value:
              context.variabilityWindowText ?? '${output.focus!.time.hour}:00',
          detail: cv == null
              ? _strings.notEnoughHistory
              : _strings.cvRank(
                  cv.toStringAsFixed(0),
                  context.variabilityRank ?? '-',
                  context.variabilityTotal ?? '-',
                ),
          badgeLabel: cv == null
              ? _strings.unknown
              : variableWindow
                  ? _strings.variable
                  : _strings.stable,
          badgeColor: cv == null
              ? AppColors.amber
              : variableWindow
                  ? AppColors.amber
                  : AppColors.green,
        ),
      ],
    );
  }

  HighEpisodeRepeatViewModel? _highRepeat(EpisodeDetailEngineOutput output) {
    final repeat = output.highRepeat;
    if (repeat == null) return null;
    final blockLabel = _timeBlockLabel(repeat.chartDataset.dominantBlockLabel);
    final rangeSuffix = repeat.chartDataset.dominantRangeLabel == null
        ? ''
        : ' (${repeat.chartDataset.dominantRangeLabel})';
    final facts = {
      'count': repeat.count,
      'range': repeat.range ?? _strings.samePartOfDay,
      'windowDays': repeat.chartDataset.windowDays,
      'blockLabel': blockLabel,
      'rangeSuffix': rangeSuffix,
    };
    return HighEpisodeRepeatViewModel(
      title: repeatTextBuilder.title(
        repeat.type,
        facts,
        context: _textContext,
      ),
      body: repeatTextBuilder.body(
        repeat.type,
        facts,
        context: _textContext,
      ),
      hint: repeatTextBuilder.hint(
        repeat.type,
        facts,
        context: _textContext,
      ),
      bigStat: repeat.bigStat,
      indicators: repeat.indicators
          .map(
            (item) => PatternDayIndicator(
              label: item.label,
              active: item.active,
            ),
          )
          .toList(),
      windowLabel: _strings.pastDays(repeat.chartDataset.windowDays),
      summaryStat: repeat.bigStat,
      summaryLabel: repeat.count == 1
          ? _strings.dayWithRepeatedHighs
          : _strings.daysWithRepeatedHighs,
      clusterTitle: repeat.count == 0
          ? _strings.noClearRepeat
          : _strings.clusterTitle(blockLabel),
      clusterBody: repeat.count == 0
          ? repeatTextBuilder.body(
              repeat.type,
              facts,
              context: _textContext,
            )
          : _strings.repeatedHighsAround(blockLabel, rangeSuffix),
      dayMarks: repeat.chartDataset.dayMarks
          .map(
            (mark) => EpisodeRepeatDayMarkViewModel(
              label: _repeatDayLabel(mark.date),
              hasEpisode: mark.hasEpisode,
              isCurrent: mark.isCurrent,
              isStrong: mark.isStrong,
            ),
          )
          .toList(),
      timeBlocks: repeat.chartDataset.timeBlockBuckets
          .map(
            (bucket) => EpisodeRepeatTimeBlockViewModel(
              label: _timeBlockLabel(bucket.label),
              count: bucket.count,
              normalizedHeight: bucket.normalizedHeight,
              isDominant: bucket.isDominant,
              isSecondary: bucket.isSecondary,
            ),
          )
          .toList(),
      takeaway: repeatTextBuilder.takeaway(
        repeat.type,
        facts,
        context: _textContext,
      ),
    );
  }

  HighEpisodeReliabilityViewModel? _highReliability(
    EpisodeDetailEngineOutput output,
  ) {
    final reliability = output.highReliability;
    if (reliability == null) return null;
    return HighEpisodeReliabilityViewModel(
      confidenceLabel: _confidenceLabel(reliability.confidence),
      confidenceColor: _confidenceColor(reliability.confidence),
      note: reliabilityTextBuilder.note(
        reliability.confidence,
        _highFacts(output),
        context: _textContext,
      ),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: _strings.readings,
          value: '${reliability.readingsInWindow}',
          detail: _strings.visibleInWindow,
          progress: (reliability.readingsInWindow / 48).clamp(0.0, 1.0),
          accent: AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: _strings.largestGap,
          value: '${reliability.largestGapMinutes} min',
          detail: _strings.betweenReadings,
          progress: (1 - (reliability.largestGapMinutes / 60)).clamp(0.0, 1.0),
          accent: reliability.largestGapMinutes <= 15
              ? AppColors.blue
              : reliability.largestGapMinutes <= 30
                  ? AppColors.amber
                  : AppColors.rose,
        ),
        HighEpisodeContextMetricViewModel(
          label: _strings.coverage,
          value: reliability.hasPeakCoverage && reliability.hasRecoveryCoverage
              ? _strings.peakRecovery
              : reliability.hasPeakCoverage
                  ? _strings.peakOnly
                  : _strings.partial,
          detail: _strings.dataConfidence,
          progress:
              reliability.hasPeakCoverage && reliability.hasRecoveryCoverage
                  ? 0.9
                  : reliability.hasPeakCoverage
                      ? 0.62
                      : 0.34,
          accent: reliability.hasPeakCoverage && reliability.hasRecoveryCoverage
              ? AppColors.green
              : AppColors.amber,
        ),
      ],
    );
  }

  LowEpisodeSummaryViewModel? _lowSummary(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden;
    final driver = output.lowDriver;
    final recovery = output.lowRecovery;
    if (burden == null || driver == null) return null;
    final unit = output.settings.unit;
    final facts = _lowFacts(output);
    return LowEpisodeSummaryViewModel(
      priorityLabel: _lowPriorityLabel(burden.priority),
      priorityColor: _lowPriorityColor(burden.priority),
      title: lowSummaryTextBuilder.title(
        burden.priority,
        facts,
        context: _textContext,
      ),
      subtitle: lowSummaryTextBuilder.subtitle(
        burden.priority,
        facts,
        context: _textContext,
      ),
      nadirText: glucoseFormatter.value(burden.nadirMmol, unit).fullLabel,
      durationText: '${burden.durationMinutes} min',
      recoveryTimeText: _recoveryTimeText(recovery?.recoveryTime),
    );
  }

  LowEpisodeBurdenViewModel? _lowBurden(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden;
    if (burden == null) return null;
    final unit = output.settings.unit;
    return LowEpisodeBurdenViewModel(
      note: lowBurdenTextBuilder.note(
        burden.priority,
        _lowFacts(output),
        context: _textContext,
      ),
      metrics: [
        LowEpisodeBurdenMetricViewModel(
          label: _strings.nadirGap,
          value:
              '-${glucoseFormatter.value(burden.nadirBelowThresholdMmol, unit).valueLabel}',
          note: _strings.belowLowThreshold,
          accent: AppColors.blue,
        ),
        LowEpisodeBurdenMetricViewModel(
          label: _strings.area,
          value: glucoseFormatter.area(burden.areaBelowTarget, unit).fullLabel,
          note: _strings.areaBelowTarget,
          accent: AppColors.amber,
        ),
        LowEpisodeBurdenMetricViewModel(
          label: _strings.dropPerMinute,
          value: EpisodeDetailFormatters.rate(
            -burden.descentRateMmolPerMin.abs(),
            unit: unit,
          ),
          note: _strings.leadUpDescent,
          accent: AppColors.blue,
        ),
        LowEpisodeBurdenMetricViewModel(
          label: _strings.recovered,
          value: burden.recoveryMinutes == null
              ? _strings.notVisible
              : '${burden.recoveryMinutes}m',
          note: _strings.returnTowardRange,
          accent: AppColors.green,
        ),
      ],
    );
  }

  LowEpisodeLifecycleViewModel? _lowLifecycle(
    EpisodeDetailEngineOutput output,
  ) {
    final focus = output.focus;
    final window = output.window;
    final burden = output.lowBurden;
    final recovery = output.lowRecovery;
    if (focus == null || window == null || burden == null) return null;
    final context = output.lowContext;
    final unit = output.settings.unit;
    final baselineLow = context?.baselineLowMmol ?? window.baselineLow;
    final baselineHigh = context?.baselineHighMmol ?? window.baselineHigh;
    final descentRate = -(focus.ratePerMin ?? window.leadUpSlope ?? 0).abs();
    final steps = [
      LowEpisodeLifecycleStep(
        code: 'B',
        label: _strings.baseline,
        value: _compactRangeText(
          lowMmol: baselineLow,
          highMmol: baselineHigh,
          unit: unit,
        ),
        tone: LowEpisodeLifecycleStepTone.neutral,
      ),
      LowEpisodeLifecycleStep(
        code: 'D',
        label: _strings.descent,
        value: _compactRateText(descentRate, unit),
        tone: LowEpisodeLifecycleStepTone.warning,
      ),
      LowEpisodeLifecycleStep(
        code: 'N',
        label: _strings.nadir,
        value: glucoseFormatter.value(burden.nadirMmol, unit).valueLabel,
        tone: LowEpisodeLifecycleStepTone.low,
      ),
      LowEpisodeLifecycleStep(
        code: 'T',
        label: _strings.lowTime,
        value: '${burden.durationMinutes} min',
        tone: LowEpisodeLifecycleStepTone.warning,
      ),
      LowEpisodeLifecycleStep(
        code: 'OK',
        label: _strings.recovery,
        value: _recoveryTimeText(recovery?.recoveryTime),
        tone: LowEpisodeLifecycleStepTone.recovered,
      ),
    ];
    return LowEpisodeLifecycleViewModel(
      steps: steps
          .map(
            (step) => LowEpisodeLifecycleStepViewModel(
              code: step.code,
              label: step.label,
              value: step.value,
              color: _lowLifecycleColor(step.tone),
            ),
          )
          .toList(),
    );
  }

  LowEpisodeDriverViewModel? _lowDriver(EpisodeDetailEngineOutput output) {
    final driver = output.lowDriver;
    if (driver == null) return null;
    final facts = _lowFacts(output);
    return LowEpisodeDriverViewModel(
      title: lowDriverTextBuilder.title(
        driver.type,
        facts,
        context: _textContext,
      ),
      body: lowDriverTextBuilder.body(
        driver.type,
        facts,
        context: _textContext,
      ),
      driverLabel: _lowDriverLabel(driver.type),
      nadirScore: driver.nadirScore,
      durationScore: math.max(driver.durationScore, driver.areaScore),
      descentScore: driver.descentScore,
      recoveryScore: driver.recoveryScore,
      nocturnalScore: driver.nocturnalScore,
      repeatScore: driver.repeatScore,
    );
  }

  LowEpisodeRecoveryViewModel? _lowRecovery(EpisodeDetailEngineOutput output) {
    final recovery = output.lowRecovery;
    if (recovery == null) return null;
    final minutes = recovery.recoveryMinutes;
    return LowEpisodeRecoveryViewModel(
      qualityLabel: _lowRecoveryQualityLabel(recovery.quality),
      qualityColor: _lowRecoveryQualityColor(recovery.quality),
      recoveryTimeText: _recoveryTimeText(recovery.recoveryTime),
      recoveryMinutesText:
          minutes == null ? _strings.notVisible : '${minutes}m',
      note: lowRecoveryTextBuilder.note(
        recovery.quality,
        _lowFacts(output),
        context: _textContext,
      ),
    );
  }

  LowEpisodeContextViewModel? _lowContext(EpisodeDetailEngineOutput output) {
    final context = output.lowContext;
    final burden = output.lowBurden;
    final window = output.window;
    if (context == null || burden == null || window == null) return null;
    final unit = output.settings.unit;
    final usualNadirRange = context.usualNadirLowMmol == null ||
            context.usualNadirHighMmol == null
        ? null
        : glucoseFormatter
            .range(
                context.usualNadirLowMmol!, context.usualNadirHighMmol!, unit)
            .fullLabel;
    final nadirLabel = glucoseFormatter.value(burden.nadirMmol, unit).fullLabel;
    final belowUsual = context.usualNadirLowMmol != null &&
        burden.nadirMmol < context.usualNadirLowMmol!;
    final hasBaseline =
        context.baselineLowMmol != null && context.baselineHighMmol != null;
    final baselineRange = hasBaseline
        ? glucoseFormatter
            .range(context.baselineLowMmol!, context.baselineHighMmol!, unit)
            .fullLabel
        : _strings.unknown;
    final leadUpSlope = context.leadUpSlope;
    final fastDrop = leadUpSlope != null && leadUpSlope.abs() >= 0.06;
    final slopeLabel =
        (context.variabilityLabel ?? '').toLowerCase().contains('overnight')
            ? _strings.overnightSlope
            : _strings.daytimeSlope;
    final currentSlope = leadUpSlope == null
        ? _strings.unknown
        : _compactRateText(-leadUpSlope.abs(), unit);
    final usualSlope = context.typicalSlope == null
        ? _strings.usualUnavailable
        : _strings.usualRate(_compactRateText(context.typicalSlope, unit));
    return LowEpisodeContextViewModel(
      note:
          lowContextTextBuilder.note(_lowFacts(output), context: _textContext),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: _strings.nadirVsUsualDailyNadir,
          value: '${_strings.current} $nadirLabel',
          detail: usualNadirRange == null
              ? _strings.baselineUnavailable
              : _strings.baselineValue(usualNadirRange),
          badgeLabel: usualNadirRange == null
              ? _strings.unknown
              : belowUsual
                  ? _strings.lower
                  : _strings.within,
          badgeColor: usualNadirRange == null
              ? AppColors.amber
              : belowUsual
                  ? AppColors.blue
                  : AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: _strings.preEpisodeBaseline,
          value:
              EpisodeDetailFormatters.range(window.start, window.preMidpoint),
          detail: baselineRange,
          badgeLabel: hasBaseline
              ? fastDrop
                  ? _strings.dropping
                  : _strings.stable
              : _strings.unknown,
          badgeColor: hasBaseline
              ? fastDrop
                  ? AppColors.amber
                  : AppColors.green
              : AppColors.amber,
        ),
        HighEpisodeContextMetricViewModel(
          label: slopeLabel,
          value: currentSlope,
          detail: usualSlope,
          badgeLabel: leadUpSlope == null
              ? _strings.unknown
              : fastDrop
                  ? _strings.fast
                  : _strings.typical,
          badgeColor: leadUpSlope == null
              ? AppColors.amber
              : fastDrop
                  ? AppColors.amber
                  : AppColors.green,
        ),
      ],
    );
  }

  LowEpisodeRepeatViewModel? _lowRepeat(EpisodeDetailEngineOutput output) {
    final repeat = output.lowRepeat;
    if (repeat == null) return null;
    final blockLabel = _timeBlockLabel(repeat.chartDataset.dominantBlockLabel);
    final rangeSuffix = repeat.chartDataset.dominantRangeLabel == null
        ? ''
        : ' (${repeat.chartDataset.dominantRangeLabel})';
    final facts = {
      'count': repeat.count,
      'range': repeat.range ?? _strings.samePartOfDay,
      'windowDays': repeat.chartDataset.windowDays,
      'blockLabel': blockLabel,
      'rangeSuffix': rangeSuffix,
    };
    return LowEpisodeRepeatViewModel(
      title: lowRepeatTextBuilder.title(
        repeat.type,
        facts,
        context: _textContext,
      ),
      body: lowRepeatTextBuilder.body(
        repeat.type,
        facts,
        context: _textContext,
      ),
      hint: lowRepeatTextBuilder.hint(
        repeat.type,
        facts,
        context: _textContext,
      ),
      bigStat: repeat.bigStat,
      indicators: repeat.indicators
          .map(
            (item) => PatternDayIndicator(
              label: item.label,
              active: item.active,
            ),
          )
          .toList(),
      windowLabel: _strings.pastDays(repeat.chartDataset.windowDays),
      summaryStat: repeat.bigStat,
      summaryLabel: repeat.count == 1
          ? _strings.dayWithRepeatedLows
          : _strings.daysWithRepeatedLows,
      clusterTitle: repeat.count == 0
          ? _strings.noClearRepeat
          : _strings.clusterTitle(blockLabel),
      clusterBody: repeat.count == 0
          ? lowRepeatTextBuilder.body(
              repeat.type,
              facts,
              context: _textContext,
            )
          : _strings.repeatedLowsAround(blockLabel, rangeSuffix),
      dayMarks: repeat.chartDataset.dayMarks
          .map(
            (mark) => EpisodeRepeatDayMarkViewModel(
              label: _repeatDayLabel(mark.date),
              hasEpisode: mark.hasEpisode,
              isCurrent: mark.isCurrent,
              isStrong: mark.isStrong,
            ),
          )
          .toList(),
      timeBlocks: repeat.chartDataset.timeBlockBuckets
          .map(
            (bucket) => EpisodeRepeatTimeBlockViewModel(
              label: _timeBlockLabel(bucket.label),
              count: bucket.count,
              normalizedHeight: bucket.normalizedHeight,
              isDominant: bucket.isDominant,
              isSecondary: bucket.isSecondary,
            ),
          )
          .toList(),
      takeaway: lowRepeatTextBuilder.takeaway(
        repeat.type,
        facts,
        context: _textContext,
      ),
    );
  }

  LowEpisodeReliabilityViewModel? _lowReliability(
    EpisodeDetailEngineOutput output,
  ) {
    final reliability = output.lowReliability;
    if (reliability == null) return null;
    return LowEpisodeReliabilityViewModel(
      confidenceLabel: _confidenceLabel(reliability.confidence),
      confidenceColor: _confidenceColor(reliability.confidence),
      note: lowReliabilityTextBuilder.note(
        reliability.confidence,
        _lowFacts(output),
        context: _textContext,
      ),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: _strings.readings,
          value: '${reliability.readingsInWindow}',
          detail: _strings.visibleInWindow,
          progress: (reliability.readingsInWindow / 48).clamp(0.0, 1.0),
          accent: AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: _strings.largestGap,
          value: '${reliability.largestGapMinutes} min',
          detail: _strings.betweenReadings,
          progress: (1 - (reliability.largestGapMinutes / 60)).clamp(0.0, 1.0),
          accent: reliability.largestGapMinutes <= 15
              ? AppColors.blue
              : reliability.largestGapMinutes <= 30
                  ? AppColors.amber
                  : AppColors.rose,
        ),
        HighEpisodeContextMetricViewModel(
          label: _strings.coverage,
          value: reliability.hasNadirCoverage && reliability.hasRecoveryCoverage
              ? _strings.nadirRecovery
              : reliability.hasNadirCoverage
                  ? _strings.nadirOnly
                  : _strings.partial,
          detail: _strings.dataConfidence,
          progress:
              reliability.hasNadirCoverage && reliability.hasRecoveryCoverage
                  ? 0.9
                  : reliability.hasNadirCoverage
                      ? 0.62
                      : 0.34,
          accent:
              reliability.hasNadirCoverage && reliability.hasRecoveryCoverage
                  ? AppColors.green
                  : AppColors.amber,
        ),
      ],
    );
  }

  EpisodeSimilarChartViewModel _similarChart(
    EpisodeDetailEngineOutput output, {
    required bool high,
    required GlucoseUnit unit,
  }) {
    final section = output.similarSection;
    final themeColor = high ? AppColors.rose : AppColors.blue;
    final selected = section.selected;
    final matchCount = section.points.where((point) => !point.isCurrent).length;
    final durations = section.points
        .where((point) => !point.isCurrent)
        .map((point) => point.durationMinutes)
        .toList()
      ..sort();
    final values = section.points
        .where((point) => !point.isCurrent)
        .map((point) => point.valueMmol)
        .toList()
      ..sort();
    final medianDuration =
        durations.isEmpty ? null : durations[durations.length ~/ 2];
    final medianValue = values.isEmpty ? null : values[values.length ~/ 2];
    final cluster = selected == null
        ? _strings.noCluster
        : _timeClusterLabel(selected.match.event.time);

    return EpisodeSimilarChartViewModel(
      title: _strings.similarEpisodes,
      trailing: _strings.pastDays(section.windowDays),
      valueAxisLabel: high ? _strings.peakGlucose : _strings.nadirGlucose,
      chips: [
        _strings.similarCount(matchCount),
        cluster,
        medianDuration == null
            ? _strings.noMedian
            : _strings.minutesMedian(medianDuration),
        medianValue == null
            ? _strings.noMedianValue
            : _strings.valueMedian(
                glucoseFormatter.value(medianValue, unit).valueLabel,
              ),
      ],
      points: section.points
          .map(
            (point) => EpisodeSimilarChartPointViewModel(
              id: point.id,
              time: point.time,
              dateLabel: _shortDate(point.time),
              timeLabel: EpisodeDetailFormatters.hm(point.time),
              valueText:
                  glucoseFormatter.value(point.valueMmol, unit).fullLabel,
              durationText: '${point.durationMinutes}m',
              valueMmol: point.valueMmol,
              durationMinutes: point.durationMinutes,
              isCurrent: point.isCurrent,
              isSelected: point.isSelected,
              slowOrUnknownRecovery: point.slowOrUnknownRecovery,
              matchLabel: _similarMatchLabel(point.label),
              color: _similarPointColor(
                point,
                themeColor: themeColor,
              ),
            ),
          )
          .toList(),
      selected: selected == null
          ? null
          : EpisodeSimilarSelectionViewModel(
              dateLabel: _strings.selectedDate(
                _shortDate(selected.match.event.time),
              ),
              title: _strings.selectedEpisode(
                _rangeOrTime(selected.match.event),
                high ? _strings.high : _strings.low,
              ),
              description: selected.reason,
              matchLabel: _similarMatchLabel(selected.match.label),
              valueText: glucoseFormatter
                  .value(selected.match.valueMmol, unit)
                  .valueLabel,
              durationText: '${selected.match.durationMinutes}m',
              recoveryText: selected.match.event.endTime == null
                  ? _strings.notVisible
                  : EpisodeDetailFormatters.hm(selected.match.event.endTime!),
              badgeColor: AppColors.green,
            ),
      emptyText: _strings.similarEmptyPast30,
      note: _strings.similarChartNote(
        high ? _strings.driverPeak : _strings.driverNadir,
      ),
    );
  }

  Color _similarPointColor(
    EpisodeSimilarChartPoint point, {
    required Color themeColor,
  }) {
    if (point.isSelected) return AppColors.green;
    if (point.isCurrent) return themeColor;
    if (point.slowOrUnknownRecovery) return AppColors.amber;
    if (point.label == EpisodeSimilarMatchLabel.looseMatch) {
      return AppColors.textDim;
    }
    return themeColor;
  }

  String _similarMatchLabel(EpisodeSimilarMatchLabel label) {
    switch (label) {
      case EpisodeSimilarMatchLabel.verySimilar:
        return _strings.similarVerySimilar;
      case EpisodeSimilarMatchLabel.similar:
        return _strings.similarSimilar;
      case EpisodeSimilarMatchLabel.looseMatch:
        return _strings.similarLooseMatch;
    }
  }

  String _timeClusterLabel(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return _strings.clusterNight;
    if (hour < 12) return _strings.clusterAm;
    if (hour < 18) return _strings.clusterPm;
    return _strings.clusterEvening;
  }

  String _timeBlockLabel(String label) {
    switch (label.toLowerCase()) {
      case 'night':
        return _strings.timeBlockNight;
      case 'dawn':
        return _strings.timeBlockDawn;
      case 'morning':
        return _strings.timeBlockMorning;
      case 'afternoon':
        return _strings.timeBlockAfternoon;
      case 'evening':
        return _strings.timeBlockEvening;
      default:
        return label;
    }
  }

  String _periodVariabilityLabel(String label) {
    switch (label.toLowerCase()) {
      case 'overnight':
      case 'night':
        return _strings.timeBlockNight;
      case 'morning':
        return _strings.timeBlockMorning;
      case 'afternoon':
        return _strings.timeBlockAfternoon;
      case 'evening':
        return _strings.timeBlockEvening;
      default:
        return label;
    }
  }

  String _rangeOrTime(GlucoseEvent event) {
    if (event.endTime == null) return EpisodeDetailFormatters.hm(event.time);
    return EpisodeDetailFormatters.range(event.time, event.endTime!);
  }

  Map<String, Object?> _highFacts(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden;
    final driver = output.highDriver;
    final unit = output.settings.unit;
    return {
      'driverLabel': driver == null
          ? _strings.driverMixedSignals
          : _driverLabel(driver.type),
      'peakLabel': burden == null
          ? _strings.unknown
          : glucoseFormatter.value(burden.peakMmol, unit).fullLabel,
      'durationMinutes': burden?.durationMinutes ?? 0,
      'areaLabel': burden == null
          ? _strings.unknown
          : glucoseFormatter.area(burden.areaAboveTarget, unit).fullLabel,
    };
  }

  Map<String, Object?> _lowFacts(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden;
    final driver = output.lowDriver;
    final unit = output.settings.unit;
    return {
      'driverLabel': driver == null
          ? _strings.driverMixedSignals
          : _lowDriverLabel(driver.type),
      'nadirLabel': burden == null
          ? _strings.unknown
          : glucoseFormatter.value(burden.nadirMmol, unit).fullLabel,
      'durationMinutes': burden?.durationMinutes ?? 0,
      'areaLabel': burden == null
          ? _strings.unknown
          : glucoseFormatter.area(burden.areaBelowTarget, unit).fullLabel,
      'lowThresholdLabel':
          glucoseFormatter.value(output.settings.lowThreshold, unit).fullLabel,
      'recoveryLabel': output.lowRecovery?.recoveryMinutes == null
          ? _strings.notVisible
          : '${output.lowRecovery!.recoveryMinutes} min',
    };
  }

  String _detailText(String name, [Map<String, Object?> facts = const {}]) {
    return textRenderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail(name),
      facts: facts,
      context: _textContext,
    );
  }

  String _focusedMissingText(EpisodeDetailEngineOutput output) {
    final kindLabel =
        output.query.kind == EpisodeKind.high ? _strings.high : _strings.low;
    final focus = output.query.focus;
    final time = focus == null
        ? ''
        : _strings.focusedMissingTime(
            EpisodeDetailFormatters.hm(focus.eventTime),
          );
    return _strings.focusedMissingEpisode(kindLabel, time);
  }

  String _recoveryTimeText(DateTime? recoveryTime) {
    if (recoveryTime == null) return _strings.notVisible;
    return EpisodeDetailFormatters.hm(recoveryTime);
  }

  String _episodeTitle(EpisodeKind kind) => kind == EpisodeKind.high
      ? _strings.highEpisodeTitle
      : _strings.lowEpisodeTitle;

  String _emptySubtitle(EpisodeDetailEngineOutput output) {
    final high = output.query.kind == EpisodeKind.high;
    if (output.query.isFocused) {
      return high
          ? _strings.noMatchingHighEpisode
          : _strings.noMatchingLowEpisode;
    }
    return high ? _strings.noRecentHighEpisode : _strings.noRecentLowEpisode;
  }

  String _headerEpisodeRange(DateTime start, DateTime? end) {
    final date = _shortDate(start);
    if (end == null) return '$date · ${EpisodeDetailFormatters.hm(start)}';
    return '$date · ${EpisodeDetailFormatters.range(start, end)}';
  }

  String _shortDate(DateTime value) {
    if (_strings.localeName.startsWith('zh')) {
      return '${value.month}月${value.day}日';
    }
    return '${_shortMonth(value.month)} ${value.day}';
  }

  String _shortMonth(int month) {
    switch (month) {
      case 1:
        return _strings.monthJan;
      case 2:
        return _strings.monthFeb;
      case 3:
        return _strings.monthMar;
      case 4:
        return _strings.monthApr;
      case 5:
        return _strings.monthMay;
      case 6:
        return _strings.monthJun;
      case 7:
        return _strings.monthJul;
      case 8:
        return _strings.monthAug;
      case 9:
        return _strings.monthSep;
      case 10:
        return _strings.monthOct;
      case 11:
        return _strings.monthNov;
      case 12:
        return _strings.monthDec;
    }
    return '$month';
  }

  String _compactRangeText({
    required double? lowMmol,
    required double? highMmol,
    required GlucoseUnit unit,
  }) {
    if (lowMmol == null || highMmol == null) return _strings.unknown;
    final range = glucoseFormatter.range(lowMmol, highMmol, unit);
    return '${range.lowLabel}-${range.highLabel}';
  }

  String _compactRateText(double? rateMmolPerMin, GlucoseUnit unit) {
    if (rateMmolPerMin == null || rateMmolPerMin.isNaN) {
      return _strings.unknown;
    }
    final rate = glucoseFormatter.rate(rateMmolPerMin, unit);
    return '${rate.valueLabel}/min';
  }

  double _extremeValue(GlucoseEvent event, GlucoseReading? extremeReading) {
    if (extremeReading != null) return extremeReading.value;
    return event.peakOrNadir ?? event.value;
  }

  double _episodeRate(GlucoseEvent event, double? windowSlope, bool high) {
    final rate = event.ratePerMin ?? windowSlope ?? 0;
    return high ? rate.abs() : -rate.abs();
  }

  double _recoveryRate({
    required double extreme,
    required int duration,
    required bool high,
  }) {
    if (duration <= 0) return 0;
    return high
        ? -(extreme - 7.0).abs() / duration
        : (4.0 - extreme).abs() / duration;
  }

  double _episodeArea(
    GlucoseEvent event,
    double extreme,
    int duration,
    bool high,
    AppSettings settings,
  ) {
    if (event.areaOutOfRange != null) return event.areaOutOfRange!;
    final threshold = high ? settings.highThreshold : settings.lowThreshold;
    final distance = high
        ? math.max(0, extreme - threshold)
        : math.max(0, threshold - extreme);
    return distance * math.max(duration, 1).toDouble();
  }

  String _priorityLabel(HighEpisodeReviewPriority priority) {
    switch (priority) {
      case HighEpisodeReviewPriority.info:
        return _strings.priorityInfo;
      case HighEpisodeReviewPriority.notable:
        return _strings.priorityNotable;
      case HighEpisodeReviewPriority.important:
        return _strings.priorityImportant;
    }
  }

  Color _priorityColor(HighEpisodeReviewPriority priority) {
    switch (priority) {
      case HighEpisodeReviewPriority.info:
        return AppColors.green;
      case HighEpisodeReviewPriority.notable:
        return AppColors.amber;
      case HighEpisodeReviewPriority.important:
        return AppColors.rose;
    }
  }

  String _driverLabel(HighEpisodeDriverType type) {
    switch (type) {
      case HighEpisodeDriverType.peak:
        return _strings.driverPeak;
      case HighEpisodeDriverType.duration:
        return _strings.driverDuration;
      case HighEpisodeDriverType.fastRise:
        return _strings.driverFastRise;
      case HighEpisodeDriverType.slowRecovery:
        return _strings.driverSlowRecovery;
      case HighEpisodeDriverType.repeatPattern:
        return _strings.driverRepeatTiming;
      case HighEpisodeDriverType.mixed:
        return _strings.driverMixedSignals;
    }
  }

  Color _lifecycleColor(HighEpisodeLifecycleStepTone tone) {
    switch (tone) {
      case HighEpisodeLifecycleStepTone.neutral:
        return AppColors.textDim;
      case HighEpisodeLifecycleStepTone.warning:
        return AppColors.amber;
      case HighEpisodeLifecycleStepTone.hot:
        return AppColors.rose;
      case HighEpisodeLifecycleStepTone.recovered:
        return AppColors.green;
    }
  }

  String _confidenceLabel(EpisodeDataConfidence confidence) {
    switch (confidence) {
      case EpisodeDataConfidence.high:
        return _strings.confidenceHigh;
      case EpisodeDataConfidence.medium:
        return _strings.confidenceMedium;
      case EpisodeDataConfidence.low:
        return _strings.confidenceLow;
    }
  }

  Color _confidenceColor(EpisodeDataConfidence confidence) {
    switch (confidence) {
      case EpisodeDataConfidence.high:
        return AppColors.green;
      case EpisodeDataConfidence.medium:
        return AppColors.amber;
      case EpisodeDataConfidence.low:
        return AppColors.rose;
    }
  }

  String _lowPriorityLabel(LowEpisodeReviewPriority priority) {
    switch (priority) {
      case LowEpisodeReviewPriority.info:
        return _strings.priorityInfo;
      case LowEpisodeReviewPriority.notable:
        return _strings.priorityNotable;
      case LowEpisodeReviewPriority.important:
        return _strings.priorityImportant;
    }
  }

  Color _lowPriorityColor(LowEpisodeReviewPriority priority) {
    switch (priority) {
      case LowEpisodeReviewPriority.info:
        return AppColors.green;
      case LowEpisodeReviewPriority.notable:
        return AppColors.blue;
      case LowEpisodeReviewPriority.important:
        return AppColors.amber;
    }
  }

  String _lowDriverLabel(LowEpisodeDriverType type) {
    switch (type) {
      case LowEpisodeDriverType.nadir:
        return _strings.driverNadir;
      case LowEpisodeDriverType.duration:
        return _strings.driverDuration;
      case LowEpisodeDriverType.fastDescent:
        return _strings.driverFastDescent;
      case LowEpisodeDriverType.slowRecovery:
        return _strings.driverSlowRecovery;
      case LowEpisodeDriverType.nocturnalTiming:
        return _strings.driverNocturnalTiming;
      case LowEpisodeDriverType.repeatPattern:
        return _strings.driverRepeatTiming;
      case LowEpisodeDriverType.mixed:
        return _strings.driverMixedSignals;
    }
  }

  Color _lowLifecycleColor(LowEpisodeLifecycleStepTone tone) {
    switch (tone) {
      case LowEpisodeLifecycleStepTone.neutral:
        return AppColors.textDim;
      case LowEpisodeLifecycleStepTone.warning:
        return AppColors.amber;
      case LowEpisodeLifecycleStepTone.low:
        return AppColors.blue;
      case LowEpisodeLifecycleStepTone.recovered:
        return AppColors.green;
    }
  }

  String _lowRecoveryQualityLabel(LowEpisodeRecoveryQuality quality) {
    switch (quality) {
      case LowEpisodeRecoveryQuality.quick:
        return _strings.recoveryQuick;
      case LowEpisodeRecoveryQuality.gradual:
        return _strings.recoveryGradual;
      case LowEpisodeRecoveryQuality.slow:
        return _strings.recoverySlow;
      case LowEpisodeRecoveryQuality.unknown:
        return _strings.unknown;
    }
  }

  Color _lowRecoveryQualityColor(LowEpisodeRecoveryQuality quality) {
    switch (quality) {
      case LowEpisodeRecoveryQuality.quick:
        return AppColors.green;
      case LowEpisodeRecoveryQuality.gradual:
        return AppColors.blue;
      case LowEpisodeRecoveryQuality.slow:
        return AppColors.amber;
      case LowEpisodeRecoveryQuality.unknown:
        return AppColors.textDim;
    }
  }

  String _repeatDayLabel(DateTime value) {
    return _shortDate(value);
  }
}

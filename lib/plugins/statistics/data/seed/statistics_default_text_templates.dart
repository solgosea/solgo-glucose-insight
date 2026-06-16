import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';

import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';

class StatisticsDefaultTextTemplates {
  static const all = <PluginTextTemplate>[
    PluginTextTemplate(
      key: 'statistics.agp.summary.dawn.consistent.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      bodyTemplate:
          'A consistent pre-dawn rise between {windowLabel} appears on {significantDays} of {observedDays} observed days, with glucose climbing roughly {averageRise} {glucoseUnit} over that window.',
      requiredFacts: [
        'dawnConsistent',
        'windowLabel',
        'significantDays',
        'observedDays',
        'averageRise',
        'glucoseUnit',
      ],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.dawn.absent.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      bodyTemplate:
          'The selected period does not show a consistent pre-dawn rise pattern; only {significantDays} of {observedDays} observed days crossed the +{riseThreshold} {glucoseUnit} rise threshold.',
      requiredFacts: [
        'dawnObserved',
        'significantDays',
        'observedDays',
        'riseThreshold',
        'glucoseUnit',
      ],
      priority: 20,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.dawn.not_enough.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      bodyTemplate:
          'The selected period does not contain enough paired {windowLabel} readings to evaluate a pre-dawn rise pattern.',
      requiredFacts: ['dawnNotEnough', 'windowLabel'],
      priority: 30,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.peak.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpMedianPeak,
      bodyTemplate:
          'The median curve peaks near {peakValue} {glucoseUnit} around {peakTime}.',
      requiredFacts: ['peakValue', 'peakTime', 'glucoseUnit'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.variability.two.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      bodyTemplate:
          '{topPeriod} is the most variable period by CV ({topCv}%), followed by {secondPeriod} ({secondCv}%).',
      requiredFacts: ['topPeriod', 'topCv', 'secondPeriod', 'secondCv'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.variability.one.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      bodyTemplate: '{topPeriod} is the most variable period by CV ({topCv}%).',
      requiredFacts: ['topPeriod', 'topCv'],
      priority: 20,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.variability.not_enough.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      bodyTemplate:
          'More period-level data is needed before identifying the most variable time window.',
      requiredFacts: ['notEnoughData'],
      priority: 90,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.empty.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpNoData,
      bodyTemplate: 'Not enough CGM data yet to draw an AGP profile.',
      requiredFacts: ['notEnoughData'],
      priority: 90,
    ),
  ];

  const StatisticsDefaultTextTemplates._();
}

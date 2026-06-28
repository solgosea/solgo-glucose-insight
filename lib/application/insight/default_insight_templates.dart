import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/insight/insight_slot_code.dart';
import '../../domain/insight/insight_template.dart';
import '../../domain/insight/insight_type_code.dart';

class DefaultInsightTemplates {
  static const all = <InsightTemplate>[
    InsightTemplate(
      code: 'daily_brief_complete_day_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.dailyBrief,
      type: InsightTypeCode.dailyCompleteDay,
      locale: 'en',
      eyebrowTemplate: 'Daily insight',
      bodyTemplate:
          '{dayLabel}: TIR was {tir}%, {tirDeltaPhrase} the recent 14-day average of {avgTir14}%. CV was {cv}%, {cvDeltaPhrase} the recent pattern.',
      footerTemplate: 'Based on {observedDays14} observed days.',
      requiredFacts: [
        'dayLabel',
        'tir',
        'tirDeltaPhrase',
        'avgTir14',
        'cv',
        'cvDeltaPhrase',
        'observedDays14',
      ],
      priority: 10,
    ),
    InsightTemplate(
      code: 'daily_brief_not_enough_data_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.dailyBrief,
      type: InsightTypeCode.dailyNotEnoughData,
      locale: 'en',
      eyebrowTemplate: 'Daily insight',
      bodyTemplate:
          'There is not enough recent glucose data to summarize a full day yet.',
      priority: 20,
    ),
    InsightTemplate(
      code: 'weekly_review_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.weeklyReview,
      type: InsightTypeCode.weeklyReview,
      locale: 'en',
      eyebrowTemplate: 'Weekly review',
      bodyTemplate:
          '{weekRange}: TIR was {tir7}%, {tirDeltaPhrase} the previous week. CV was {cv7}%.',
      footerTemplate: 'Based on {readingCount7} readings.',
      requiredFacts: [
        'weekRange',
        'tir7',
        'tirDeltaPhrase',
        'cv7',
        'readingCount7',
      ],
      priority: 20,
    ),
    InsightTemplate(
      code: 'pattern_dawn_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.dawnPattern,
      locale: 'en',
      eyebrowTemplate: '{dawnTitle}',
      bodyTemplate:
          'The {windowLabel} window showed {significantDays} notable rises across {observedMornings} observed mornings.',
      requiredFacts: [
        'dawnTitle',
        'windowLabel',
        'significantDays',
        'observedMornings',
      ],
      priority: 30,
    ),
    InsightTemplate(
      code: 'pattern_volatile_period_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.volatilePeriod,
      locale: 'en',
      eyebrowTemplate: 'Most variable window',
      bodyTemplate:
          '{periodLabel} had CV {periodCv}% with TIR {periodTir}% and average glucose {periodMean}.',
      requiredFacts: [
        'periodLabel',
        'periodCv',
        'periodTir',
        'periodMean',
      ],
      priority: 40,
    ),
    InsightTemplate(
      code: 'pattern_stable_period_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.stablePeriod,
      locale: 'en',
      eyebrowTemplate: 'Most stable window',
      bodyTemplate:
          '{periodLabel} looked comparatively stable, with TIR {periodTir}% and CV {periodCv}%.',
      requiredFacts: [
        'periodLabel',
        'periodTir',
        'periodCv',
      ],
      priority: 50,
    ),
    InsightTemplate(
      code: 'pattern_weekday_gap_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.weekdayGap,
      locale: 'en',
      eyebrowTemplate: '{weekdayGapTitle}',
      bodyTemplate:
          'Weekend TIR was {weekendTir}%, about {weekdayGapDelta}pp {weekdayGapDirection} weekday TIR.',
      requiredFacts: [
        'weekdayGapTitle',
        'weekendTir',
        'weekdayGapDelta',
        'weekdayGapDirection',
        'weekdayTir',
      ],
      priority: 60,
    ),
    InsightTemplate(
      code: 'pattern_not_enough_data_en_v1',
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.notEnoughPatternData,
      locale: 'en',
      eyebrowTemplate: 'Pattern insight',
      bodyTemplate:
          'More recent readings are needed before a reliable pattern can be shown.',
      priority: 100,
    ),
  ];
}

import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';

import '../../domain/text/episode_detail_text_slot.dart';

class EpisodeDetailDefaultTextTemplates {
  static const all = <PluginTextTemplate>[
    PluginTextTemplate(
      key: 'episode_detail.detail.highDisclaimer.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highDisclaimer',
      bodyTemplate:
          'This is observational CGM analysis only and is not medical advice. Consult your healthcare provider for clinical decisions.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowDisclaimer.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowDisclaimer',
      bodyTemplate:
          'Low glucose episodes require clinical interpretation. This is observational CGM analysis only and is not medical advice.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highEmpty.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highEmpty',
      bodyTemplate: 'No high glucose episodes detected in the last 30 days.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowEmpty.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowEmpty',
      bodyTemplate: 'No low glucose episodes detected in the last 30 days.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.baselineUnavailable.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.baselineUnavailable',
      bodyTemplate:
          'Baseline range unavailable; not enough readings before onset',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highBaseline.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highBaseline',
      bodyTemplate: 'Pre-onset baseline {range}',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowBaseline.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowBaseline',
      bodyTemplate: 'Pre-episode range {range}',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.slopeUnavailable.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.slopeUnavailable',
      bodyTemplate:
          'Lead-up readings limited; slope cannot be estimated from this window',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highSlopeNoComparison.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highSlopeNoComparison',
      bodyTemplate: 'Lead-up rise {slope}; historical comparison unavailable',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowSlopeNoComparison.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowSlopeNoComparison',
      bodyTemplate:
          'Lead-up descent {slope}; historical comparison unavailable',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highSlopeComparison.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highSlopeComparison',
      bodyTemplate:
          'Lead-up rise {slope}; {direction} historical window average ({typicalSlope})',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowSlopeComparison.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowSlopeComparison',
      bodyTemplate:
          'Lead-up descent {slope}; {direction} historical window average ({typicalSlope})',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.variabilityUnavailable.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.variabilityUnavailable',
      bodyTemplate:
          'Time-window variability unavailable; not enough historical readings',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.variabilityAvailable.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.variabilityAvailable',
      bodyTemplate:
          '{label} window ({windowText}) CV {cv}%, rank {rank}/{total} by variability',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highPatternEmpty.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highPatternEmpty',
      bodyTemplate:
          'No morning-window high episodes were detected in the 14-day analysis window.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highPatternClustered.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highPatternClustered',
      bodyTemplate:
          '{count} morning-window high episodes were detected in the last 14 days. Events occurred between {range}.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.highPatternNoCluster.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.highPatternNoCluster',
      bodyTemplate:
          '{count} morning-window high episodes were detected in the last 14 days. The time cluster cannot be estimated from the current sample.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowPatternEmpty.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowPatternEmpty',
      bodyTemplate:
          'No nocturnal low episodes were detected in the 30-day analysis window.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowPatternClustered.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowPatternClustered',
      bodyTemplate:
          '{count} nocturnal low episodes were detected in the past 30 days. They occurred between {range}.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowPatternNoCluster.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowPatternNoCluster',
      bodyTemplate:
          '{count} nocturnal low episodes were detected in the past 30 days. The time cluster cannot be estimated from the current sample.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowDistribution.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowDistribution',
      bodyTemplate:
          'Low episode distribution: {nocturnalPct}% nocturnal (00:00-06:00) | {afternoonPct}% afternoon | {otherPct}% other',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowSeverityDescription.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowSeverityDescription',
      bodyTemplate: '{nadirLabel} is compared with this threshold band.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.detail.lowSeverityFootnote.v1',
      slot: EpisodeDetailTextSlot.detail,
      type: 'episode_detail.detail.lowSeverityFootnote',
      bodyTemplate:
          'Severity is derived from the episode nadir value in the current CGM event.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.summary.info.v1',
      slot: EpisodeDetailTextSlot.highSummaryTitle,
      type: 'episode_detail.high.priority.info',
      bodyTemplate: 'A short high episode worth noting.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.summary.notable.v1',
      slot: EpisodeDetailTextSlot.highSummaryTitle,
      type: 'episode_detail.high.priority.notable',
      bodyTemplate: 'A notable high episode, mainly driven by {driverLabel}.',
      requiredFacts: ['driverLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.summary.important.v1',
      slot: EpisodeDetailTextSlot.highSummaryTitle,
      type: 'episode_detail.high.priority.important',
      bodyTemplate:
          'An important high episode to review, mainly driven by {driverLabel}.',
      requiredFacts: ['driverLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.summary.subtitle.v1',
      slot: EpisodeDetailTextSlot.highSummarySubtitle,
      type: 'episode_detail.high.priority.notable',
      bodyTemplate:
          'Peak was {peakLabel}, duration was {durationMinutes} min, and exposure above target was {areaLabel}.',
      requiredFacts: ['peakLabel', 'durationMinutes', 'areaLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.summary.subtitle.important.v1',
      slot: EpisodeDetailTextSlot.highSummarySubtitle,
      type: 'episode_detail.high.priority.important',
      bodyTemplate:
          'Peak was {peakLabel}, duration was {durationMinutes} min, and recovery or exposure makes this worth closer review.',
      requiredFacts: ['peakLabel', 'durationMinutes'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.summary.subtitle.info.v1',
      slot: EpisodeDetailTextSlot.highSummarySubtitle,
      type: 'episode_detail.high.priority.info',
      bodyTemplate:
          'Peak and duration stayed near the lighter end of recent high episodes.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.burden.note.v1',
      slot: EpisodeDetailTextSlot.highBurdenNote,
      type: 'episode_detail.high.priority.notable',
      bodyTemplate:
          'This high stayed above target long enough to be worth reviewing, even if the peak alone was not extreme.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.burden.note.important.v1',
      slot: EpisodeDetailTextSlot.highBurdenNote,
      type: 'episode_detail.high.priority.important',
      bodyTemplate:
          'The episode burden is elevated because peak, duration, recovery, or exposure crossed the review threshold.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.burden.note.info.v1',
      slot: EpisodeDetailTextSlot.highBurdenNote,
      type: 'episode_detail.high.priority.info',
      bodyTemplate:
          'This episode appears shorter or lighter than the main high episodes in the current window.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.title.duration.v1',
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: 'episode_detail.high.driver.duration',
      bodyTemplate: 'Duration is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.body.duration.v1',
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: 'episode_detail.high.driver.duration',
      bodyTemplate:
          'The peak was above target, but the episode burden mainly comes from staying above target for {durationMinutes} minutes before recovery.',
      requiredFacts: ['durationMinutes'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.title.peak.v1',
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: 'episode_detail.high.driver.peak',
      bodyTemplate: 'Peak is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.body.peak.v1',
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: 'episode_detail.high.driver.peak',
      bodyTemplate:
          'The largest signal is the peak value at {peakLabel}, which rose above the configured high target.',
      requiredFacts: ['peakLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.title.fast_rise.v1',
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: 'episode_detail.high.driver.fast_rise',
      bodyTemplate: 'Fast rise is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.body.fast_rise.v1',
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: 'episode_detail.high.driver.fast_rise',
      bodyTemplate:
          'The lead-up slope was faster than usual, so the episode is mostly explained by the rise into the high range.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.title.slow_recovery.v1',
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: 'episode_detail.high.driver.slow_recovery',
      bodyTemplate: 'Slow recovery is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.body.slow_recovery.v1',
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: 'episode_detail.high.driver.slow_recovery',
      bodyTemplate:
          'The episode took longer to recover, so the main review signal is the delayed return toward range.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.title.repeat.v1',
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: 'episode_detail.high.driver.repeat',
      bodyTemplate: 'Repeat timing is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.body.repeat.v1',
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: 'episode_detail.high.driver.repeat',
      bodyTemplate:
          'Similar high episodes appeared repeatedly in the same part of the day, making the timing pattern worth reviewing.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.title.mixed.v1',
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: 'episode_detail.high.driver.mixed',
      bodyTemplate: 'This episode has mixed drivers.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.driver.body.mixed.v1',
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: 'episode_detail.high.driver.mixed',
      bodyTemplate:
          'Peak, duration, exposure, and recovery are close enough that no single driver fully explains the episode.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.context.note.v1',
      slot: EpisodeDetailTextSlot.highContextNote,
      type: 'episode_detail.high.priority.notable',
      bodyTemplate:
          'This compares the episode with your observed baseline. It is not a clinical target.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.title.morning.v1',
      slot: EpisodeDetailTextSlot.highRepeatTitle,
      type: 'episode_detail.high.repeat.morning',
      bodyTemplate: 'Morning-window highs',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.body.morning.v1',
      slot: EpisodeDetailTextSlot.highRepeatBody,
      type: 'episode_detail.high.repeat.morning',
      bodyTemplate:
          'High episodes appeared {count} times in the morning window, including this episode. They were clustered between {range}.',
      requiredFacts: ['count', 'range'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.title.evening.v1',
      slot: EpisodeDetailTextSlot.highRepeatTitle,
      type: 'episode_detail.high.repeat.evening',
      bodyTemplate: 'Evening-window highs',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.body.evening.v1',
      slot: EpisodeDetailTextSlot.highRepeatBody,
      type: 'episode_detail.high.repeat.evening',
      bodyTemplate:
          'High episodes appeared {count} times in the evening window, including this episode. They were clustered between {range}.',
      requiredFacts: ['count', 'range'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.title.same_time.v1',
      slot: EpisodeDetailTextSlot.highRepeatTitle,
      type: 'episode_detail.high.repeat.same_time',
      bodyTemplate: 'Same-time high cluster',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.body.same_time.v1',
      slot: EpisodeDetailTextSlot.highRepeatBody,
      type: 'episode_detail.high.repeat.same_time',
      bodyTemplate:
          'Similar high episodes, including this episode, clustered around {range} in the recent window.',
      requiredFacts: ['range'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.title.none.v1',
      slot: EpisodeDetailTextSlot.highRepeatTitle,
      type: 'episode_detail.high.repeat.none',
      bodyTemplate: 'No clear repeated timing',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.body.none.v1',
      slot: EpisodeDetailTextSlot.highRepeatBody,
      type: 'episode_detail.high.repeat.none',
      bodyTemplate:
          'The recent window does not show a clear repeated high-episode timing pattern.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.hint.v1',
      slot: EpisodeDetailTextSlot.highRepeatHint,
      type: 'episode_detail.high.repeat.morning',
      bodyTemplate:
          'If this repeats, review nearby context such as meal timing, activity, sensor status, or routine changes.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.takeaway.morning.v1',
      slot: EpisodeDetailTextSlot.highRepeatTakeaway,
      type: 'episode_detail.high.repeat.morning',
      bodyTemplate:
          'High episodes repeated {count} times in the past {windowDays} days, mainly around {blockLabel}{rangeSuffix}.',
      requiredFacts: ['count', 'windowDays', 'blockLabel', 'rangeSuffix'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.takeaway.evening.v1',
      slot: EpisodeDetailTextSlot.highRepeatTakeaway,
      type: 'episode_detail.high.repeat.evening',
      bodyTemplate:
          'High episodes repeated {count} times in the past {windowDays} days, mainly around {blockLabel}{rangeSuffix}.',
      requiredFacts: ['count', 'windowDays', 'blockLabel', 'rangeSuffix'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.takeaway.same_time.v1',
      slot: EpisodeDetailTextSlot.highRepeatTakeaway,
      type: 'episode_detail.high.repeat.same_time',
      bodyTemplate:
          'The strongest repeat signal is a same-time cluster around {range} in the past {windowDays} days.',
      requiredFacts: ['range', 'windowDays'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.repeat.takeaway.none.v1',
      slot: EpisodeDetailTextSlot.highRepeatTakeaway,
      type: 'episode_detail.high.repeat.none',
      bodyTemplate:
          'No clear repeated high-episode timing pattern is visible in the past {windowDays} days.',
      requiredFacts: ['windowDays'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.reliability.high.v1',
      slot: EpisodeDetailTextSlot.highReliabilityNote,
      type: 'episode_detail.high.reliability.high',
      bodyTemplate:
          'Readings around the peak and recovery are available, so duration and recovery are likely reliable.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.reliability.medium.v1',
      slot: EpisodeDetailTextSlot.highReliabilityNote,
      type: 'episode_detail.high.reliability.medium',
      bodyTemplate:
          'Some gaps were detected, so duration and recovery should be reviewed with moderate confidence.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.high.reliability.low.v1',
      slot: EpisodeDetailTextSlot.highReliabilityNote,
      type: 'episode_detail.high.reliability.low',
      bodyTemplate:
          'Large data gaps were detected near the episode window. Duration and recovery may be incomplete.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.summary.info.v1',
      slot: EpisodeDetailTextSlot.lowSummaryTitle,
      type: 'episode_detail.low.priority.info',
      bodyTemplate: 'A brief low episode worth noting.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.summary.notable.v1',
      slot: EpisodeDetailTextSlot.lowSummaryTitle,
      type: 'episode_detail.low.priority.notable',
      bodyTemplate: 'A notable low episode, mainly driven by {driverLabel}.',
      requiredFacts: ['driverLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.summary.important.v1',
      slot: EpisodeDetailTextSlot.lowSummaryTitle,
      type: 'episode_detail.low.priority.important',
      bodyTemplate:
          'An important low episode to review, mainly driven by {driverLabel}.',
      requiredFacts: ['driverLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.summary.subtitle.info.v1',
      slot: EpisodeDetailTextSlot.lowSummarySubtitle,
      type: 'episode_detail.low.priority.info',
      bodyTemplate:
          'Nadir and duration stayed near the lighter end of recent low episodes.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.summary.subtitle.notable.v1',
      slot: EpisodeDetailTextSlot.lowSummarySubtitle,
      type: 'episode_detail.low.priority.notable',
      bodyTemplate:
          'Nadir was {nadirLabel}, duration was {durationMinutes} min, and exposure below target was {areaLabel}.',
      requiredFacts: ['nadirLabel', 'durationMinutes', 'areaLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.summary.subtitle.important.v1',
      slot: EpisodeDetailTextSlot.lowSummarySubtitle,
      type: 'episode_detail.low.priority.important',
      bodyTemplate:
          'Nadir was {nadirLabel}, duration was {durationMinutes} min, and recovery or repeated timing makes this worth closer review.',
      requiredFacts: ['nadirLabel', 'durationMinutes'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.burden.note.info.v1',
      slot: EpisodeDetailTextSlot.lowBurdenNote,
      type: 'episode_detail.low.priority.info',
      bodyTemplate:
          'This episode appears shorter or lighter than the main low episodes in the current window.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.burden.note.notable.v1',
      slot: EpisodeDetailTextSlot.lowBurdenNote,
      type: 'episode_detail.low.priority.notable',
      bodyTemplate:
          'This low stayed below target long enough to be worth reviewing, even if the nadir alone was not extreme.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.burden.note.important.v1',
      slot: EpisodeDetailTextSlot.lowBurdenNote,
      type: 'episode_detail.low.priority.important',
      bodyTemplate:
          'The episode burden is elevated because nadir, duration, recovery, or repeat timing crossed the review threshold.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.nadir.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.nadir',
      bodyTemplate: 'Nadir is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.nadir.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.nadir',
      bodyTemplate:
          'The strongest signal is the nadir at {nadirLabel}, compared with the configured low threshold.',
      requiredFacts: ['nadirLabel'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.duration.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.duration',
      bodyTemplate: 'Duration is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.duration.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.duration',
      bodyTemplate:
          'The nadir was below target, but the episode burden mainly comes from staying low for {durationMinutes} minutes.',
      requiredFacts: ['durationMinutes'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.fast_descent.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.fast_descent',
      bodyTemplate: 'Fast descent is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.fast_descent.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.fast_descent',
      bodyTemplate:
          'The lead-up slope dropped quickly, so the main review signal is the fall into the low range.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.slow_recovery.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.slow_recovery',
      bodyTemplate: 'Slow recovery is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.slow_recovery.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.slow_recovery',
      bodyTemplate:
          'The episode took longer to recover, so the main review signal is the delayed return toward range.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.nocturnal.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.nocturnal',
      bodyTemplate: 'Nocturnal timing is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.nocturnal.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.nocturnal',
      bodyTemplate:
          'The episode occurred overnight, so timing is the main context to review.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.repeat.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.repeat',
      bodyTemplate: 'Repeat timing is the main driver.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.repeat.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.repeat',
      bodyTemplate:
          'Similar low episodes appeared repeatedly in the same part of the day, making the timing pattern worth reviewing.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.title.mixed.v1',
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: 'episode_detail.low.driver.mixed',
      bodyTemplate: 'This episode has mixed drivers.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.driver.body.mixed.v1',
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: 'episode_detail.low.driver.mixed',
      bodyTemplate:
          'Nadir, duration, descent speed, recovery, and repeat timing are close enough that no single driver fully explains the episode.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.recovery.quick.v1',
      slot: EpisodeDetailTextSlot.lowRecoveryNote,
      type: 'episode_detail.low.recovery.quick',
      bodyTemplate:
          'Recovery was visible within the quick range for this episode window.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.recovery.gradual.v1',
      slot: EpisodeDetailTextSlot.lowRecoveryNote,
      type: 'episode_detail.low.recovery.gradual',
      bodyTemplate:
          'Recovery was visible, but it took a gradual return toward range.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.recovery.slow.v1',
      slot: EpisodeDetailTextSlot.lowRecoveryNote,
      type: 'episode_detail.low.recovery.slow',
      bodyTemplate:
          'Recovery was visible but slow in this CGM window; interpret duration with the data quality below.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.recovery.unknown.v1',
      slot: EpisodeDetailTextSlot.lowRecoveryNote,
      type: 'episode_detail.low.recovery.unknown',
      bodyTemplate:
          'A return toward range was not visible in the episode window, so recovery timing is unknown.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.context.note.v1',
      slot: EpisodeDetailTextSlot.lowContextNote,
      type: 'episode_detail.low.priority.notable',
      bodyTemplate:
          'This compares the episode with your observed baseline. It is not a clinical target.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.title.nocturnal.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTitle,
      type: 'episode_detail.low.repeat.nocturnal',
      bodyTemplate: 'Nocturnal lows',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.body.nocturnal.v1',
      slot: EpisodeDetailTextSlot.lowRepeatBody,
      type: 'episode_detail.low.repeat.nocturnal',
      bodyTemplate:
          'Low episodes appeared {count} times overnight in the recent window.',
      requiredFacts: ['count'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.title.afternoon.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTitle,
      type: 'episode_detail.low.repeat.afternoon',
      bodyTemplate: 'Afternoon lows',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.body.afternoon.v1',
      slot: EpisodeDetailTextSlot.lowRepeatBody,
      type: 'episode_detail.low.repeat.afternoon',
      bodyTemplate:
          'Low episodes appeared {count} times in the afternoon window.',
      requiredFacts: ['count'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.title.same_time.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTitle,
      type: 'episode_detail.low.repeat.same_time',
      bodyTemplate: 'Same-time low cluster',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.body.same_time.v1',
      slot: EpisodeDetailTextSlot.lowRepeatBody,
      type: 'episode_detail.low.repeat.same_time',
      bodyTemplate:
          'Similar low episodes clustered around {range} in the recent window.',
      requiredFacts: ['range'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.title.fast_descent.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTitle,
      type: 'episode_detail.low.repeat.fast_descent',
      bodyTemplate: 'Repeated fast descents',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.body.fast_descent.v1',
      slot: EpisodeDetailTextSlot.lowRepeatBody,
      type: 'episode_detail.low.repeat.fast_descent',
      bodyTemplate:
          'Recent low episodes often included a fast descent before the low range.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.title.none.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTitle,
      type: 'episode_detail.low.repeat.none',
      bodyTemplate: 'No clear repeated timing',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.body.none.v1',
      slot: EpisodeDetailTextSlot.lowRepeatBody,
      type: 'episode_detail.low.repeat.none',
      bodyTemplate:
          'The recent window does not show a clear repeated low-episode timing pattern.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.hint.v1',
      slot: EpisodeDetailTextSlot.lowRepeatHint,
      type: 'episode_detail.low.repeat.none',
      bodyTemplate:
          'Review nearby context such as sensor gaps, activity, sleep timing, routine changes, or other logged notes.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.takeaway.nocturnal.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTakeaway,
      type: 'episode_detail.low.repeat.nocturnal',
      bodyTemplate:
          'Low episodes repeated {count} times in the past {windowDays} days, mainly around {blockLabel}{rangeSuffix}.',
      requiredFacts: ['count', 'windowDays', 'blockLabel', 'rangeSuffix'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.takeaway.afternoon.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTakeaway,
      type: 'episode_detail.low.repeat.afternoon',
      bodyTemplate:
          'Low episodes repeated {count} times in the past {windowDays} days, mainly around {blockLabel}{rangeSuffix}.',
      requiredFacts: ['count', 'windowDays', 'blockLabel', 'rangeSuffix'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.takeaway.same_time.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTakeaway,
      type: 'episode_detail.low.repeat.same_time',
      bodyTemplate:
          'The strongest repeat signal is a same-time low cluster around {range} in the past {windowDays} days.',
      requiredFacts: ['range', 'windowDays'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.takeaway.fast_descent.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTakeaway,
      type: 'episode_detail.low.repeat.fast_descent',
      bodyTemplate:
          'Recent low episodes often share a fast-descent pattern, so descent speed is worth reviewing alongside timing.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.repeat.takeaway.none.v1',
      slot: EpisodeDetailTextSlot.lowRepeatTakeaway,
      type: 'episode_detail.low.repeat.none',
      bodyTemplate:
          'No clear repeated low-episode timing pattern is visible in the past {windowDays} days.',
      requiredFacts: ['windowDays'],
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.reliability.high.v1',
      slot: EpisodeDetailTextSlot.lowReliabilityNote,
      type: 'episode_detail.low.reliability.high',
      bodyTemplate:
          'Readings around the nadir and recovery are available, so duration and recovery are likely reliable.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.reliability.medium.v1',
      slot: EpisodeDetailTextSlot.lowReliabilityNote,
      type: 'episode_detail.low.reliability.medium',
      bodyTemplate:
          'Some gaps were detected, so nadir, duration, and recovery should be reviewed with moderate confidence.',
    ),
    PluginTextTemplate(
      key: 'episode_detail.low.reliability.low.v1',
      slot: EpisodeDetailTextSlot.lowReliabilityNote,
      type: 'episode_detail.low.reliability.low',
      bodyTemplate:
          'Large data gaps were detected near the episode window. Nadir, duration, or recovery may be incomplete.',
    ),
  ];

  const EpisodeDetailDefaultTextTemplates._();
}

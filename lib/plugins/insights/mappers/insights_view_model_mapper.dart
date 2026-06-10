import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';
import 'package:smart_xdrip/domain/insight/narrative_insight.dart';
import '../models/insights_view_model.dart';

class InsightsViewModelMapper {
  InsightsViewModel map({required AnalysisFacade facade}) {
    final insights = facade.insights;
    final daily = _firstForSlot(insights, InsightSlotCode.dailyBrief);
    final weekly = _firstForSlot(insights, InsightSlotCode.weeklyReview);
    final patterns =
        insights
            .where((insight) => insight.slot == InsightSlotCode.patternCard)
            .toList()
          ..sort((a, b) => a.generatedAt.compareTo(b.generatedAt));
    final anchor = facade.latestReading?.timestamp ?? DateTime.now();

    return InsightsViewModel(
      headerDate: _formatHeaderDate(anchor),
      dailyBrief: daily?.body ?? '',
      dailyBriefFooter: daily?.footer ?? '',
      weeklyReview: _weeklyReview(weekly),
      patterns: patterns.map(_pattern).toList(),
    );
  }

  WeeklyReviewViewModel _weeklyReview(NarrativeInsight? insight) {
    final facts = insight?.facts ?? const <String, Object?>{};
    return WeeklyReviewViewModel(
      eyebrow: insight?.eyebrow ?? '',
      body: insight?.body ?? '',
      stats: [
        InsightMiniStatViewModel(
          value: _factString(facts, 'tir7'),
          label: 'TIR',
          tone: InsightMiniStatTone.positive,
        ),
        InsightMiniStatViewModel(
          value: _factString(facts, 'bestDayShort'),
          label: 'Best day',
        ),
        InsightMiniStatViewModel(
          value: _factString(facts, 'longestHighValue'),
          label: _factString(facts, 'longestHighLabel'),
          tone:
              facts['hasLongestHigh'] == true
                  ? InsightMiniStatTone.warning
                  : InsightMiniStatTone.neutral,
        ),
      ],
    );
  }

  InsightPatternViewModel _pattern(NarrativeInsight insight) {
    return InsightPatternViewModel(
      icon: _iconFor(insight.type),
      title: insight.title ?? '',
      body: insight.body,
      footer: insight.footer ?? '',
    );
  }

  NarrativeInsight? _firstForSlot(
    List<NarrativeInsight> insights,
    InsightSlotCode slot,
  ) {
    final rows =
        insights.where((insight) => insight.slot == slot).toList()
          ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    return rows.isEmpty ? null : rows.first;
  }

  InsightPatternIcon _iconFor(InsightTypeCode type) {
    return switch (type) {
      InsightTypeCode.dawnPattern => InsightPatternIcon.dawn,
      InsightTypeCode.volatilePeriod => InsightPatternIcon.volatility,
      InsightTypeCode.stablePeriod => InsightPatternIcon.stability,
      InsightTypeCode.weekdayGap => InsightPatternIcon.weekday,
      _ => InsightPatternIcon.generic,
    };
  }

  String _factString(Map<String, Object?> facts, String key) {
    final value = facts[key];
    if (value == null) return '--';
    final text = value.toString();
    return text.isEmpty ? '--' : text;
  }

  String _formatHeaderDate(DateTime date) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }
}

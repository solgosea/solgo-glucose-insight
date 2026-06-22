import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/analysis/analysis_module_code.dart';
import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';
import 'package:smart_xdrip/domain/insight/narrative_insight.dart';
import 'package:smart_xdrip/plugins/insights/domain/insights_pattern_kind.dart';
import 'package:smart_xdrip/plugins/insights/domain/insights_query.dart';
import 'package:smart_xdrip/plugins/insights/engine/insights_engine.dart';
import 'package:smart_xdrip/plugins/insights/engine/insights_engine_input.dart';
import 'package:smart_xdrip/plugins/insights/l10n/generated/insights_localizations_zh.dart';
import 'package:smart_xdrip/plugins/insights/mappers/insights_view_model_mapper.dart';

void main() {
  test('insights engine builds section output from narrative facts', () {
    final now = DateTime(2026, 6, 17, 9);
    final output = const InsightsEngine().run(
      InsightsEngineInput(
        query: InsightsQuery(subjectId: 'self', anchorTime: now),
        insights: [
          _insight(
            id: 'old-daily',
            slot: InsightSlotCode.dailyBrief,
            type: InsightTypeCode.dailyNotEnoughData,
            generatedAt: now.subtract(const Duration(hours: 1)),
          ),
          _insight(
            id: 'daily',
            slot: InsightSlotCode.dailyBrief,
            type: InsightTypeCode.dailyCompleteDay,
            generatedAt: now,
            facts: const {
              'dayLabel': 'Yesterday',
              'tir': '78',
              'tirDeltaPhrase': '4pp above',
              'avgTir14': '74',
              'cv': '31',
              'cvDeltaPhrase': 'close to',
              'avgCv14': '30',
              'observedDays14': 12,
            },
          ),
          _insight(
            id: 'pattern',
            slot: InsightSlotCode.patternCard,
            type: InsightTypeCode.weekdayGap,
            generatedAt: now,
            facts: const {
              'weekdayGapTitle': 'Weekends show lower TIR',
              'weekendTir': '68',
              'weekdayGapDelta': '9',
              'weekdayGapDirection': 'below',
              'weekdayTir': '77',
              'weekdayGapDays': 12,
            },
          ),
        ],
      ),
    );

    expect(output.query.subjectId, 'self');
    expect(output.dailySection.facts['tir'], '78');
    expect(
        output.patternsSection.items.single.kind, InsightsPatternKind.weekday);
  });

  test('insights mapper renders display text from plugin templates', () {
    final now = DateTime(2026, 6, 17, 9);
    final output = const InsightsEngine().run(
      InsightsEngineInput(
        query: InsightsQuery(subjectId: 'self', anchorTime: now),
        insights: [
          _insight(
            id: 'weekly',
            slot: InsightSlotCode.weeklyReview,
            type: InsightTypeCode.weeklyReview,
            generatedAt: now,
            facts: const {
              'weekRange': 'JUN 10-16',
              'tir7': '81',
              'tirDeltaPhrase': 'up 3pp from',
              'prevTir7': '78',
              'cv7': '29',
              'readingCount7': 1950,
              'bestDayShort': 'Tue',
              'longestHighValue': '42m',
              'hasLongestHigh': false,
            },
          ),
        ],
      ),
    );

    final viewModel = const InsightsViewModelMapper().map(output);

    expect(viewModel.headerDate, 'Jun 17, 2026');
    expect(viewModel.weeklyReview.eyebrow, 'WEEK IN REVIEW - JUN 10-16');
    expect(viewModel.weeklyReview.body, contains('Last week TIR was 81%'));
    expect(viewModel.weeklyReview.stats.first.label, 'TIR');
    expect(viewModel.patternsEmptyText, isNotEmpty);
  });

  test('insights mapper renders Chinese text from localized templates', () {
    final now = DateTime(2026, 6, 17, 9);
    final output = const InsightsEngine().run(
      InsightsEngineInput(
        query: InsightsQuery(subjectId: 'self', anchorTime: now),
        insights: [
          _insight(
            id: 'daily',
            slot: InsightSlotCode.dailyBrief,
            type: InsightTypeCode.dailyCompleteDay,
            generatedAt: now,
            facts: const {
              'dayLabel': '昨天',
              'tir': '78',
              'tirDeltaPhrase': '高于',
              'avgTir14': '74',
              'cv': '31',
              'cvDeltaPhrase': '接近',
              'avgCv14': '30',
              'observedDays14': 12,
            },
          ),
          _insight(
            id: 'weekly',
            slot: InsightSlotCode.weeklyReview,
            type: InsightTypeCode.weeklyReview,
            generatedAt: now,
            facts: const {
              'weekRange': '6月10-16日',
              'tir7': '81',
              'tirDeltaPhrase': '高于',
              'prevTir7': '78',
              'cv7': '29',
              'bestDayShort': '周二',
              'longestHighValue': '42分',
            },
          ),
        ],
      ),
    );

    final viewModel = const InsightsViewModelMapper().map(
      output,
      l10n: InsightsLocalizationsZh(),
    );

    expect(viewModel.headerDate, '2026年6月17日');
    expect(viewModel.dailyBrief, contains('昨天 的 TIR 为 78%'));
    expect(viewModel.dailyBriefFooter, '基于 12 天数据');
    expect(viewModel.weeklyReview.eyebrow, '本周回顾 - 6月10-16日');
    expect(viewModel.weeklyReview.body, contains('上周 TIR 为 81%'));
    expect(viewModel.weeklyReview.stats[1].label, '最佳日');
    expect(viewModel.patternsEmptyText, '等待足够的 CGM 数据后生成洞察。');
  });
}

NarrativeInsight _insight({
  required String id,
  required InsightSlotCode slot,
  required InsightTypeCode type,
  required DateTime generatedAt,
  Map<String, Object?> facts = const {},
}) {
  return NarrativeInsight(
    id: id,
    module: AnalysisModuleCode.insights,
    slot: slot,
    type: type,
    templateCode: id,
    templateVersion: 1,
    body: '$id fallback body',
    facts: facts,
    generatedAt: generatedAt,
  );
}

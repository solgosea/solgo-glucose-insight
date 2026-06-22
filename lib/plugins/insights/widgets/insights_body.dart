import 'package:flutter/material.dart';
import '../application/i18n/insights_l10n.dart';
import '../models/insights_view_model.dart';
import 'daily/daily_brief_card.dart';
import 'header/insights_header.dart';
import 'patterns/insight_pattern_list.dart';
import 'shared/insight_section_label.dart';
import 'weekly/weekly_review_card.dart';

class InsightsBody extends StatelessWidget {
  final InsightsViewModel viewModel;
  final VoidCallback onBack;

  const InsightsBody({
    super.key,
    required this.viewModel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InsightsHeader(
              dateText: viewModel.headerDate,
              onBack: onBack,
            ),
            DailyBriefCard(
              text: viewModel.dailyBrief,
              footer: viewModel.dailyBriefFooter,
            ),
            WeeklyReviewCard(viewModel: viewModel.weeklyReview),
            InsightSectionLabel(
              context.insightsL10n.insightsSectionPatternsDetected,
            ),
            InsightPatternList(
              patterns: viewModel.patterns,
              emptyText: viewModel.patternsEmptyText,
            ),
          ],
        ),
      ),
    );
  }
}

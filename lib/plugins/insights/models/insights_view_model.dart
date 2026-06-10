enum InsightPatternIcon { dawn, volatility, stability, weekday, generic }

class InsightsViewModel {
  final String headerDate;
  final String dailyBrief;
  final String dailyBriefFooter;
  final WeeklyReviewViewModel weeklyReview;
  final List<InsightPatternViewModel> patterns;

  const InsightsViewModel({
    required this.headerDate,
    required this.dailyBrief,
    required this.dailyBriefFooter,
    required this.weeklyReview,
    required this.patterns,
  });
}

class WeeklyReviewViewModel {
  final String eyebrow;
  final String body;
  final List<InsightMiniStatViewModel> stats;

  const WeeklyReviewViewModel({
    required this.eyebrow,
    required this.body,
    required this.stats,
  });
}

class InsightMiniStatViewModel {
  final String value;
  final String label;
  final InsightMiniStatTone tone;

  const InsightMiniStatViewModel({
    required this.value,
    required this.label,
    this.tone = InsightMiniStatTone.neutral,
  });
}

enum InsightMiniStatTone { neutral, positive, warning }

class InsightPatternViewModel {
  final InsightPatternIcon icon;
  final String title;
  final String body;
  final String footer;

  const InsightPatternViewModel({
    required this.icon,
    required this.title,
    required this.body,
    required this.footer,
  });
}

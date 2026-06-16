import 'statistics_analysis_window.dart';
import 'statistics_analysis_window_id.dart';

class StatisticsAnalysisWindowCatalog {
  static const all = [
    StatisticsAnalysisWindow(
      id: StatisticsAnalysisWindowId.last24Hours,
      label: '24h',
      headerLabel: 'LAST 24 HOURS',
      duration: Duration(hours: 24),
      comparisonDuration: Duration(hours: 24),
      isAgpRecommended: false,
    ),
    StatisticsAnalysisWindow(
      id: StatisticsAnalysisWindowId.last3Days,
      label: '3d',
      headerLabel: 'LAST 3 DAYS',
      duration: Duration(days: 3),
      comparisonDuration: Duration(days: 3),
      isAgpRecommended: false,
    ),
    StatisticsAnalysisWindow(
      id: StatisticsAnalysisWindowId.last7Days,
      label: '7d',
      headerLabel: 'LAST 7 DAYS',
      duration: Duration(days: 7),
      comparisonDuration: Duration(days: 7),
      isAgpRecommended: true,
    ),
    StatisticsAnalysisWindow(
      id: StatisticsAnalysisWindowId.last14Days,
      label: '14d',
      headerLabel: 'LAST 14 DAYS',
      duration: Duration(days: 14),
      comparisonDuration: Duration(days: 14),
      isAgpRecommended: true,
    ),
    StatisticsAnalysisWindow(
      id: StatisticsAnalysisWindowId.last30Days,
      label: '30d',
      headerLabel: 'LAST 30 DAYS',
      duration: Duration(days: 30),
      comparisonDuration: Duration(days: 30),
      isAgpRecommended: true,
    ),
    StatisticsAnalysisWindow(
      id: StatisticsAnalysisWindowId.last90Days,
      label: '90d',
      headerLabel: 'LAST 90 DAYS',
      duration: Duration(days: 90),
      comparisonDuration: Duration(days: 90),
      isAgpRecommended: true,
    ),
  ];

  const StatisticsAnalysisWindowCatalog._();

  static StatisticsAnalysisWindow byId(StatisticsAnalysisWindowId id) {
    return all.firstWhere(
      (window) => window.id == id,
      orElse: () => byId(StatisticsAnalysisWindowId.last14Days),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';

void main() {
  test('statistics window catalog exposes the supported analysis windows', () {
    expect(
      StatisticsAnalysisWindowCatalog.all.map((window) => window.label),
      ['24h', '3d', '7d', '14d', '30d', '90d'],
    );

    expect(
      StatisticsAnalysisWindowCatalog.byId(
        StatisticsAnalysisWindowId.last24Hours,
      ).isAgpRecommended,
      isFalse,
    );
    expect(
      StatisticsAnalysisWindowCatalog.byId(
        StatisticsAnalysisWindowId.last7Days,
      ).isAgpRecommended,
      isTrue,
    );
  });
}

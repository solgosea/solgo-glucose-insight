import '../../l10n/generated/home_localizations.dart';
import '../../models/home_chart_range.dart';

extension HomeRangeL10n on HomeLocalizations {
  String rangeLabel(HomeChartRange range) {
    return switch (range) {
      HomeChartRange.oneHour => homeRangeOneHour,
      HomeChartRange.fourHours => homeRangeFourHours,
      HomeChartRange.eightHours => homeRangeEightHours,
      HomeChartRange.twentyFourHours => homeRangeTwentyFourHours,
    };
  }

  String rangeTitle(HomeChartRange range) {
    return switch (range) {
      HomeChartRange.oneHour => homeRangeTitleOneHour,
      HomeChartRange.fourHours => homeRangeTitleFourHours,
      HomeChartRange.eightHours => homeRangeTitleEightHours,
      HomeChartRange.twentyFourHours => homeRangeTitleTwentyFourHours,
    };
  }
}

import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection.dart';

import 'statistics_analysis_window_id.dart';

class StatisticsDateFilter {
  final DateFilterSelection selection;
  final StatisticsAnalysisWindowId windowId;

  const StatisticsDateFilter({
    required this.selection,
    required this.windowId,
  });

  factory StatisticsDateFilter.defaultValue(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return StatisticsDateFilter(
      selection: DateFilterSelection(
        start: today.subtract(const Duration(days: 13)),
        end: today,
      ),
      windowId: StatisticsAnalysisWindowId.last14Days,
    );
  }

  bool get isPresetWindow => _windowIdForSelection(selection) == windowId;

  StatisticsDateFilter copyWithSelection(DateFilterSelection next) {
    return StatisticsDateFilter(
      selection: next,
      windowId:
          _windowIdForSelection(next) ?? StatisticsAnalysisWindowId.last14Days,
    );
  }

  static StatisticsAnalysisWindowId? _windowIdForSelection(
    DateFilterSelection selection,
  ) {
    final days = selection.end.difference(selection.start).inDays + 1;
    return switch (days) {
      1 => StatisticsAnalysisWindowId.last24Hours,
      3 => StatisticsAnalysisWindowId.last3Days,
      7 => StatisticsAnalysisWindowId.last7Days,
      14 => StatisticsAnalysisWindowId.last14Days,
      30 => StatisticsAnalysisWindowId.last30Days,
      90 => StatisticsAnalysisWindowId.last90Days,
      _ => null,
    };
  }
}

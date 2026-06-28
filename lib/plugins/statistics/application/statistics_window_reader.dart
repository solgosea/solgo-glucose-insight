import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../domain/statistics_analysis_window.dart';

class StatisticsWindowReader {
  const StatisticsWindowReader();

  List<GlucoseReading> readingsForWindow(
    AnalysisFacade facade,
    StatisticsAnalysisWindow window,
  ) {
    final anchor = facade.latestReading?.timestamp;
    return _readingsForDuration(
      facade,
      duration: window.duration,
      now: anchor,
    );
  }

  List<GlucoseReading> previousReadingsForWindow(
    AnalysisFacade facade,
    StatisticsAnalysisWindow window,
  ) {
    final latest = facade.latestReading?.timestamp;
    if (latest == null) return const [];
    return _readingsForDuration(
      facade,
      duration: window.duration,
      now: latest.subtract(window.comparisonDuration),
    );
  }

  List<GlucoseReading> readingsForSelection(
    AnalysisFacade facade, {
    required DateTime start,
    required DateTime end,
  }) {
    final exclusiveEnd = end.add(const Duration(days: 1));
    return facade.readings
        .where(
          (reading) =>
              !reading.timestamp.isBefore(start) &&
              reading.timestamp.isBefore(exclusiveEnd),
        )
        .toList();
  }

  List<GlucoseReading> previousReadingsForSelection(
    AnalysisFacade facade, {
    required DateTime start,
    required DateTime end,
  }) {
    final dayCount = end.difference(start).inDays + 1;
    final previousEnd = start;
    final previousStart = start.subtract(Duration(days: dayCount));
    return facade.readings
        .where(
          (reading) =>
              !reading.timestamp.isBefore(previousStart) &&
              reading.timestamp.isBefore(previousEnd),
        )
        .toList();
  }

  List<GlucoseReading> _readingsForDuration(
    AnalysisFacade facade, {
    required Duration duration,
    DateTime? now,
  }) {
    final current = now ?? facade.latestReading?.timestamp ?? DateTime.now();
    final cutoff = current.subtract(duration);
    return facade.readings
        .where(
          (reading) =>
              !reading.timestamp.isBefore(cutoff) &&
              !reading.timestamp.isAfter(current),
        )
        .toList();
  }
}

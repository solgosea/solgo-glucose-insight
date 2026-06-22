import '../../../domain/analysis/status_analysis_context.dart';

class CgmSignalContinuityCalculator {
  const CgmSignalContinuityCalculator();

  Duration longestGap(StatusAnalysisContext context) {
    final readings = [...context.evidence.selection.cgmHistoryReadings.readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    var longest = Duration.zero;
    for (var i = 1; i < readings.length; i++) {
      final gap = readings[i].timestamp.difference(readings[i - 1].timestamp);
      if (gap > longest) longest = gap;
    }
    return longest;
  }
}

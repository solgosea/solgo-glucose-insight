import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/status_level.dart';
import '../../../domain/xdrip/xdrip_completeness_bucket.dart';

class XdripCompletenessHeatmapCalculator {
  const XdripCompletenessHeatmapCalculator();

  List<XdripCompletenessBucket> calculate(StatusAnalysisContext context) {
    const bucketCount = 24;
    const expectedPerHour = 12;
    final start = context.now.subtract(const Duration(hours: 24));
    final readings = [...context.evidence.selection.xdripLiveReadings.readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return List.generate(bucketCount, (index) {
      final bucketStart = start.add(Duration(hours: index));
      final bucketEnd = bucketStart.add(const Duration(hours: 1));
      final observed = readings
          .where(
            (reading) =>
                !reading.timestamp.isBefore(bucketStart) &&
                reading.timestamp.isBefore(bucketEnd),
          )
          .length;
      final ratio = observed / expectedPerHour;
      final level = ratio >= .95
          ? StatusLevel.healthy
          : ratio >= .85
              ? StatusLevel.watch
              : StatusLevel.issue;
      return XdripCompletenessBucket(
        start: bucketStart,
        end: bucketEnd,
        observed: observed,
        expected: expectedPerHour,
        level: level,
      );
    });
  }
}

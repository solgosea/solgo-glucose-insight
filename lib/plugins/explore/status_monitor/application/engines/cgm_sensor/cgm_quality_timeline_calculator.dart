import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/detail/status_timeline_bucket.dart';
import '../../../domain/status_level.dart';

class CgmQualityTimelineCalculator {
  const CgmQualityTimelineCalculator();

  List<StatusTimelineBucket> calculate(StatusAnalysisContext context) {
    const bucketCount = 48;
    final window = const Duration(hours: 24);
    final bucketSize = Duration(
      milliseconds: window.inMilliseconds ~/ bucketCount,
    );
    final start = context.now.subtract(window);
    final readings = [...context.evidence.selection.cgmHistoryReadings.readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    if (readings.isEmpty) {
      return List.generate(bucketCount, (index) {
        final bucketStart = start.add(bucketSize * index);
        final bucketEnd = bucketStart.add(bucketSize);
        return StatusTimelineBucket(
          start: bucketStart,
          end: bucketEnd,
          level: StatusLevel.unknown,
          label: 'No readings',
          value: 0,
        );
      });
    }
    return List.generate(bucketCount, (index) {
      final bucketStart = start.add(bucketSize * index);
      final bucketEnd = bucketStart.add(bucketSize);
      final count = readings
          .where(
            (reading) =>
                !reading.timestamp.isBefore(bucketStart) &&
                reading.timestamp.isBefore(bucketEnd),
          )
          .length;
      final level = count >= 4
          ? StatusLevel.healthy
          : count >= 1
              ? StatusLevel.watch
              : count == 0
                  ? StatusLevel.issue
                  : StatusLevel.watch;
      return StatusTimelineBucket(
        start: bucketStart,
        end: bucketEnd,
        level: level,
        label: '$count readings',
        value: count,
      );
    });
  }
}

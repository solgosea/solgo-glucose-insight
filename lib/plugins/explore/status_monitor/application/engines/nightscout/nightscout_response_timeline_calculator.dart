import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/nightscout/nightscout_response_timeline.dart';

class NightscoutResponseTimelineCalculator {
  const NightscoutResponseTimelineCalculator();

  NightscoutResponseTimeline calculate(StatusAnalysisContext context) {
    final points = context.evidence.nightscoutEvidence.responseTimeline;
    final sortedMs =
        points.map((point) => point.elapsed.inMilliseconds).toList()..sort();
    final median = sortedMs.isEmpty
        ? null
        : Duration(milliseconds: sortedMs[sortedMs.length ~/ 2]);
    final timeoutCount = points.where((point) => point.timeout).length;
    return NightscoutResponseTimeline(
      points: points,
      median: median,
      timeoutCount: timeoutCount,
    );
  }
}

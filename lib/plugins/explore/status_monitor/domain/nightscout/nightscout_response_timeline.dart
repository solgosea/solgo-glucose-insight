import '../detail/status_response_time_point.dart';

class NightscoutResponseTimeline {
  final List<StatusResponseTimePoint> points;
  final Duration? median;
  final int timeoutCount;

  const NightscoutResponseTimeline({
    required this.points,
    this.median,
    this.timeoutCount = 0,
  });

  Map<String, Object?> toJson() => {
        'points': points.map((point) => point.toJson()).toList(),
        'medianMs': median?.inMilliseconds,
        'timeoutCount': timeoutCount,
      };
}

import '../../../../domain/entities/glucose_event.dart';
import '../../domain/history_time_filter.dart';
import '../../domain/history_time_filter_policy.dart';

class HistoryEpisodeFilterCalculator {
  final HistoryTimeFilterPolicy policy;

  const HistoryEpisodeFilterCalculator({
    this.policy = const HistoryTimeFilterPolicy(),
  });

  List<GlucoseEvent> calculate(
    List<GlucoseEvent> events,
    HistoryTimeFilter? filter,
  ) {
    return events
        .where((event) =>
            event.type == GlucoseEventType.highEpisode ||
            event.type == GlucoseEventType.lowEpisode)
        .where((event) => policy.includesEpisode(event, filter))
        .toList()
      ..sort((a, b) => b.time.compareTo(a.time));
  }
}

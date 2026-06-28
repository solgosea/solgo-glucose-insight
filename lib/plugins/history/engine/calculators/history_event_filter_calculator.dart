import '../../../../domain/entities/glucose_event.dart';
import '../../domain/history_time_filter.dart';
import '../../domain/history_time_filter_policy.dart';

class HistoryEventFilterCalculator {
  final HistoryTimeFilterPolicy policy;

  const HistoryEventFilterCalculator({
    this.policy = const HistoryTimeFilterPolicy(),
  });

  List<GlucoseEvent> calculate(
    List<GlucoseEvent> events,
    HistoryTimeFilter? filter,
  ) {
    return events.where((event) => policy.includesEvent(event, filter)).toList()
      ..sort((a, b) => b.time.compareTo(a.time));
  }
}

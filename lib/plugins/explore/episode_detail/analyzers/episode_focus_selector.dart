import 'package:smart_xdrip/domain/entities/glucose_event.dart';

class EpisodeFocusSelector {
  const EpisodeFocusSelector();

  GlucoseEvent? latestOfType(
    List<GlucoseEvent> events, {
    required GlucoseEventType type,
  }) {
    final matches =
        events.where((event) => event.type == type).toList()
          ..sort((a, b) => a.time.compareTo(b.time));
    return matches.isEmpty ? null : matches.last;
  }
}

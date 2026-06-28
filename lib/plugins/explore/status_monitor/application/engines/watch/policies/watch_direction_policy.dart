import '../../../../domain/status_direction.dart';
import '../../../../domain/status_level.dart';

class WatchDirectionPolicy {
  const WatchDirectionPolicy();

  List<StatusDirection> directions(StatusLevel level) {
    if (level == StatusLevel.healthy) return const [];
    return const [
      StatusDirection(
        title: 'Check watch display path',
        body:
            'Watch display depends on the watch bridge and xDrip+ Web Service evidence.',
      ),
    ];
  }
}

import '../../../domain/juggluco/juggluco_path_state.dart';

class JugglucoPathStateCalculator {
  const JugglucoPathStateCalculator();

  JugglucoPathState calculate({
    required bool receiverConfigured,
    required bool broadcastObserved,
    required bool xdripCompatibleObserved,
    required Duration? age,
  }) {
    if (!receiverConfigured) {
      return JugglucoPathState.notConfigured;
    }
    if (!broadcastObserved) return JugglucoPathState.waitingForFirstBroadcast;
    if (!xdripCompatibleObserved) return JugglucoPathState.directOnly;
    if (age == null) return JugglucoPathState.unknown;
    final minutes = age.inMinutes;
    if (minutes <= 10) return JugglucoPathState.fresh;
    if (minutes <= 20) return JugglucoPathState.delayed;
    if (minutes <= 45) return JugglucoPathState.stale;
    return JugglucoPathState.unavailable;
  }
}

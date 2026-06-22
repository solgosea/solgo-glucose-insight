import '../status_level.dart';
import 'xdrip_reading_source_state.dart';

class XdripPipelineGateResult {
  final bool hasLocalService;
  final bool hasLiveReadings;
  final XdripReadingSourceState readingSourceState;
  final int? maxScore;
  final StatusLevel? maxLevel;
  final String message;

  const XdripPipelineGateResult({
    required this.hasLocalService,
    required this.hasLiveReadings,
    required this.readingSourceState,
    required this.message,
    this.maxScore,
    this.maxLevel,
  });

  bool get hasOnlyService => hasLocalService && !hasLiveReadings;
  bool get usesFallbackReadings =>
      readingSourceState == XdripReadingSourceState.nightscoutFallback;

  int applyScoreCap(int score) {
    final cap = maxScore;
    if (cap == null) return score;
    return score > cap ? cap : score;
  }

  StatusLevel levelFor(int? score, StatusLevel Function(int? score) mapper) {
    if (score == null) return StatusLevel.unknown;
    if (hasOnlyService) return StatusLevel.watch;
    if (!hasLocalService && !hasLiveReadings) return StatusLevel.unknown;
    final level = mapper(score);
    if (maxLevel == StatusLevel.watch && level == StatusLevel.healthy) {
      return StatusLevel.watch;
    }
    return level;
  }

  String labelFor(int? score, String Function(int? score) mapper) {
    if (score == null) {
      return 'Limited xDrip+ evidence';
    }
    if (hasOnlyService) {
      return 'Service reachable, no readings';
    }
    if (usesFallbackReadings) {
      return 'Nightscout reading fallback';
    }
    if (!hasLocalService && hasLiveReadings) {
      return 'xDrip+ service not visible';
    }
    return mapper(score);
  }
}

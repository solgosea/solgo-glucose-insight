import '../status_level.dart';

class CgmSensorPipelineGateResult {
  final bool hasLiveReadings;
  final int? maxScore;
  final StatusLevel? forcedLevel;
  final StatusLevel? maxLevel;
  final String message;

  const CgmSensorPipelineGateResult({
    required this.hasLiveReadings,
    required this.message,
    this.maxScore,
    this.forcedLevel,
    this.maxLevel,
  });

  int applyScoreCap(int score) {
    final cap = maxScore;
    if (cap == null) return score;
    return score > cap ? cap : score;
  }

  StatusLevel levelFor(int? score, StatusLevel Function(int? score) mapper) {
    if (forcedLevel != null) return forcedLevel!;
    if (score == null) return StatusLevel.unknown;
    final level = mapper(score);
    if (maxLevel == StatusLevel.watch && level == StatusLevel.healthy) {
      return StatusLevel.watch;
    }
    return level;
  }

  String labelFor(int? score, String Function(int? score) mapper) {
    if (!hasLiveReadings) return 'No live readings';
    if (score == null) return 'Limited sensor evidence';
    return mapper(score);
  }
}

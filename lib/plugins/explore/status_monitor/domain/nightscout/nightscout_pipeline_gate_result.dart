import '../status_level.dart';

class NightscoutPipelineGateResult {
  final bool apiReachable;
  final bool entriesAvailable;
  final bool serverDataFresh;
  final int? maxScore;
  final StatusLevel? forcedLevel;
  final StatusLevel? maxLevel;
  final String message;

  const NightscoutPipelineGateResult({
    required this.apiReachable,
    required this.entriesAvailable,
    required this.serverDataFresh,
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
    if (!apiReachable) return 'Cloud API offline';
    if (!entriesAvailable) return 'Entries unavailable';
    if (!serverDataFresh) return 'Server data stale';
    if (score == null) return 'Limited cloud evidence';
    return mapper(score);
  }
}

import '../status_level.dart';

class AapsPipelineGateResult {
  final bool nightscoutReachable;
  final bool hasAapsContext;
  final bool hasFreshLoopContext;
  final int? maxScore;
  final StatusLevel? forcedLevel;
  final StatusLevel? maxLevel;
  final String message;

  const AapsPipelineGateResult({
    required this.nightscoutReachable,
    required this.hasAapsContext,
    required this.hasFreshLoopContext,
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
    if (!nightscoutReachable) return 'Nightscout evidence unavailable';
    if (!hasAapsContext) return 'No AAPS context';
    if (!hasFreshLoopContext) return 'AAPS context stale';
    if (score == null) return 'Limited AAPS evidence';
    return mapper(score);
  }
}

class StatusProbeScoreVm {
  final int score;
  final int yesCount;
  final int totalCount;
  final int noCount;
  final double progress;
  final bool includedInCore;

  const StatusProbeScoreVm({
    required this.score,
    required this.yesCount,
    required this.totalCount,
    required this.noCount,
    required this.progress,
    this.includedInCore = true,
  });
}

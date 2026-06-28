class StatusProbeChecklistSummaryVm {
  final String passing;
  final String needsAction;
  final String optionalPaths;
  final String lastChecked;
  final int coreScore;
  final double coreProgress;

  const StatusProbeChecklistSummaryVm({
    required this.passing,
    required this.needsAction,
    required this.optionalPaths,
    required this.lastChecked,
    required this.coreScore,
    required this.coreProgress,
  });
}

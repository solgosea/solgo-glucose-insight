class StatusProbeSuiteProgressVm {
  final String label;
  final double percent;
  final int completedCount;
  final int runningCount;
  final int totalCount;

  const StatusProbeSuiteProgressVm({
    required this.label,
    required this.percent,
    required this.completedCount,
    required this.runningCount,
    required this.totalCount,
  });
}

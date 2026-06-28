class StatusProbeRunProgress {
  final int completedCount;
  final int runningCount;
  final int totalCount;

  const StatusProbeRunProgress({
    required this.completedCount,
    required this.runningCount,
    required this.totalCount,
  });

  double get percent =>
      totalCount <= 0 ? 0 : (completedCount / totalCount).clamp(0, 1);

  String get label => totalCount <= 0
      ? '0/0 · 0%'
      : '$completedCount/$totalCount · ${(percent * 100).round()}%';
}

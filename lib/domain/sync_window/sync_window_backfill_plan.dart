class SyncWindowBackfillPlan {
  final DateTime from;
  final DateTime to;
  final int windowDays;

  const SyncWindowBackfillPlan({
    required this.from,
    required this.to,
    required this.windowDays,
  });

  bool get isEmpty => !to.isAfter(from);
}

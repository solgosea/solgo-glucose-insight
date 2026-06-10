class GlucoseSyncPlan {
  final DateTime from;
  final DateTime to;
  final bool initial;
  final DateTime? previousCursor;

  const GlucoseSyncPlan({
    required this.from,
    required this.to,
    required this.initial,
    required this.previousCursor,
  });
}

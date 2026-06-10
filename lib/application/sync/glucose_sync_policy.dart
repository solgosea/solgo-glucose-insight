class GlucoseSyncPolicy {
  final int initialSyncDays;
  final Duration overlapWindow;
  final Duration maxCatchUpWindow;

  const GlucoseSyncPolicy({
    required this.initialSyncDays,
    this.overlapWindow = const Duration(minutes: 10),
    this.maxCatchUpWindow = const Duration(days: 3),
  });

  factory GlucoseSyncPolicy.fromSettings({required int initialSyncDays}) {
    return GlucoseSyncPolicy(initialSyncDays: initialSyncDays);
  }
}

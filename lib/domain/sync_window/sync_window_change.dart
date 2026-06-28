class SyncWindowChange {
  final int previousDays;
  final int nextDays;

  const SyncWindowChange({
    required this.previousDays,
    required this.nextDays,
  });

  bool get expanded => nextDays > previousDays;
}

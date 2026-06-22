class StatusHistoryWindow {
  final DateTime from;
  final DateTime to;

  const StatusHistoryWindow({
    required this.from,
    required this.to,
  });

  factory StatusHistoryWindow.lastSevenDays(DateTime now) {
    final today = now.isUtc
        ? DateTime.utc(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day);
    return StatusHistoryWindow(
      from: today.subtract(const Duration(days: 6)),
      to: now,
    );
  }
}

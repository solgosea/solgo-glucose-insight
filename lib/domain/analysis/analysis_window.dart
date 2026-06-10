class AnalysisWindow {
  final DateTime start;
  final DateTime end;
  final String label;

  const AnalysisWindow({
    required this.start,
    required this.end,
    required this.label,
  });

  Duration get duration => end.difference(start);

  bool contains(DateTime time) => !time.isBefore(start) && time.isBefore(end);

  static AnalysisWindow lastDays(int days, {DateTime? now}) {
    final anchor = now ?? DateTime.now();
    return AnalysisWindow(
      start: anchor.subtract(Duration(days: days)),
      end: anchor,
      label: '${days}d',
    );
  }
}

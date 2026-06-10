enum HomeChartRange {
  fourHours('4h', 4),
  eightHours('8h', 8),
  twentyFourHours('24h', 24);

  final String label;
  final int hours;

  const HomeChartRange(this.label, this.hours);

  String get title => 'LAST ${label.toUpperCase()}';
}

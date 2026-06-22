enum HomeChartRange {
  oneHour('1h', 1),
  fourHours('4h', 4),
  eightHours('8h', 8),
  twentyFourHours('24h', 24);

  final String label;
  final int hours;

  const HomeChartRange(this.label, this.hours);
}

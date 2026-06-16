class HomeMetricWindow {
  final int hours;
  final String labelSuffix;

  const HomeMetricWindow._({
    required this.hours,
    required this.labelSuffix,
  });

  static const last24Hours = HomeMetricWindow._(
    hours: 24,
    labelSuffix: '24h',
  );
}

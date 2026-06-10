class DailyGlucoseSummary {
  final DateTime day;
  final int readingCount;
  final double tir;
  final double tar;
  final double tbr;
  final double mean;
  final double cv;
  final double minValue;
  final double maxValue;
  final double firstReadingValue;

  const DailyGlucoseSummary({
    required this.day,
    required this.readingCount,
    required this.tir,
    required this.tar,
    required this.tbr,
    required this.mean,
    required this.cv,
    required this.minValue,
    required this.maxValue,
    required this.firstReadingValue,
  });
}

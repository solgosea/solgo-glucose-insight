class PersonalBaseline {
  final double tirLow;
  final double tirHigh;
  final double peakLow;
  final double peakHigh;
  final double cvLow;
  final double cvHigh;
  final double fastingLow;
  final double fastingHigh;
  final double averageMeanLow;
  final double averageMeanHigh;
  final DateTime updatedAt;
  final int daysUsed;

  const PersonalBaseline({
    required this.tirLow,
    required this.tirHigh,
    required this.peakLow,
    required this.peakHigh,
    required this.cvLow,
    required this.cvHigh,
    required this.fastingLow,
    required this.fastingHigh,
    required this.averageMeanLow,
    required this.averageMeanHigh,
    required this.updatedAt,
    required this.daysUsed,
  });
}

import '../../domain/entities/glucose_reading.dart';

class DawnPhenomenonDetector {
  /// Returns daily dawn rise values for readings spanning 04:00-07:00.
  static List<double> detectDailyRises(List<GlucoseReading> readings) {
    final Map<String, List<GlucoseReading>> byDay = {};
    for (final r in readings) {
      if (r.timestamp.hour >= 4 && r.timestamp.hour < 7) {
        final key =
            '${r.timestamp.year}-${r.timestamp.month}-${r.timestamp.day}';
        byDay.putIfAbsent(key, () => []).add(r);
      }
    }

    return byDay.values
        .where((day) => day.length >= 4)
        .map((day) {
          day.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          return day.last.value - day.first.value;
        })
        .where((rise) => rise > 0)
        .toList();
  }

  /// Returns true if dawn phenomenon is consistent (>=10/14 days).
  static bool isConsistent(List<GlucoseReading> readings14d) {
    final rises = detectDailyRises(readings14d);
    final significant = rises.where((r) => r >= 1.2).length;
    return significant >= 10;
  }

  static double avgRise(List<GlucoseReading> readings14d) {
    final rises = detectDailyRises(readings14d);
    if (rises.isEmpty) return 0;
    return rises.reduce((a, b) => a + b) / rises.length;
  }
}

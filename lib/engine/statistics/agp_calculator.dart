import '../../domain/entities/glucose_reading.dart';

/// Ambulatory Glucose Profile percentile data per 5-minute slot (288 slots/day)
class AgpSlot {
  final int minuteOfDay; // 0..1435
  final double p10, p25, p50, p75, p90;
  const AgpSlot({
    required this.minuteOfDay,
    required this.p10,
    required this.p25,
    required this.p50,
    required this.p75,
    required this.p90,
  });
}

class AgpCalculator {
  static List<AgpSlot> calculate(List<GlucoseReading> readings) {
    // Group readings by 5-minute slot
    final Map<int, List<double>> slots = {};
    for (final r in readings) {
      final slot = (r.timestamp.hour * 60 + r.timestamp.minute) ~/ 5 * 5;
      slots.putIfAbsent(slot, () => []).add(r.value);
    }

    final result = <AgpSlot>[];
    for (int m = 0; m < 1440; m += 5) {
      final vals = slots[m];
      if (vals == null || vals.isEmpty) continue;
      vals.sort();
      result.add(
        AgpSlot(
          minuteOfDay: m,
          p10: _percentile(vals, 10),
          p25: _percentile(vals, 25),
          p50: _percentile(vals, 50),
          p75: _percentile(vals, 75),
          p90: _percentile(vals, 90),
        ),
      );
    }
    return result;
  }

  static double _percentile(List<double> sorted, int p) {
    if (sorted.isEmpty) return 0;
    final idx = (p / 100) * (sorted.length - 1);
    final lo = idx.floor();
    final hi = idx.ceil();
    if (lo == hi) return sorted[lo];
    return sorted[lo] + (sorted[hi] - sorted[lo]) * (idx - lo);
  }
}

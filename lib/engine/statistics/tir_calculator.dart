import '../../domain/entities/glucose_reading.dart';

class TirResult {
  final double tir; // %
  final double tar; // %
  final double tbr; // %
  final double tarVeryHigh; // %
  final double tbrVeryLow; // %
  final double mean;
  final double sd;
  final double cv;
  final double gmi;
  final int readingCount;

  const TirResult({
    required this.tir,
    required this.tar,
    required this.tbr,
    required this.tarVeryHigh,
    required this.tbrVeryLow,
    required this.mean,
    required this.sd,
    required this.cv,
    required this.gmi,
    required this.readingCount,
  });
}

class TirCalculator {
  static TirResult calculate(
    List<GlucoseReading> readings, {
    double low = 3.9,
    double high = 10.0,
    double veryHigh = 13.9,
    double veryLow = 3.0,
  }) {
    if (readings.isEmpty) return _empty();

    final values = readings.map((r) => r.value).toList();
    final n = values.length;

    final inRange = values.where((v) => v >= low && v <= high).length;
    final above = values.where((v) => v > high).length;
    final below = values.where((v) => v < low).length;
    final veryAbove = values.where((v) => v > veryHigh).length;
    final veryBelow = values.where((v) => v < veryLow).length;

    final mean = values.reduce((a, b) => a + b) / n;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) / n;

    final sdVal = _sqrt(variance);
    final cv = mean > 0 ? (sdVal / mean) * 100 : 0.0;
    // GMI = 3.31 + 0.02392 * mean_mg/dL
    final gmi = 3.31 + 0.02392 * (mean * 18.0);

    return TirResult(
      tir: (inRange / n) * 100,
      tar: (above / n) * 100,
      tbr: (below / n) * 100,
      tarVeryHigh: (veryAbove / n) * 100,
      tbrVeryLow: (veryBelow / n) * 100,
      mean: mean,
      sd: sdVal,
      cv: cv,
      gmi: gmi,
      readingCount: n,
    );
  }

  static double _sqrt(double v) {
    if (v <= 0) return 0;
    double x = v;
    for (int i = 0; i < 20; i++) {
      x = (x + v / x) / 2;
    }
    return x;
  }

  static TirResult _empty() => const TirResult(
    tir: 0,
    tar: 0,
    tbr: 0,
    tarVeryHigh: 0,
    tbrVeryLow: 0,
    mean: 0,
    sd: 0,
    cv: 0,
    gmi: 0,
    readingCount: 0,
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/engine/statistics/tir_calculator.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

void main() {
  test('TIR calculator returns 100% when all readings in range', () {
    final readings = [
      GlucoseReading(timestamp: DateTime(2026, 1, 1, 0, 0), value: 5.5),
      GlucoseReading(timestamp: DateTime(2026, 1, 1, 0, 5), value: 6.2),
      GlucoseReading(timestamp: DateTime(2026, 1, 1, 0, 10), value: 7.0),
    ];
    final result = TirCalculator.calculate(readings);
    expect(result.tir, 100.0);
    expect(result.tar, 0.0);
    expect(result.tbr, 0.0);
  });

  test('TIR calculator computes mean correctly', () {
    final readings = [
      GlucoseReading(timestamp: DateTime(2026, 1, 1, 0, 0), value: 5.0),
      GlucoseReading(timestamp: DateTime(2026, 1, 1, 0, 5), value: 7.0),
    ];
    final result = TirCalculator.calculate(readings);
    expect(result.mean, 6.0);
  });
}

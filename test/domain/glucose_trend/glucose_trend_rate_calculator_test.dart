import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_rate_calculator.dart';

void main() {
  group('GlucoseTrendRateCalculator', () {
    test('calculates mmol/L per minute from adjacent readings', () {
      const calculator = GlucoseTrendRateCalculator();
      final previous = GlucoseReading(
        timestamp: DateTime(2026, 6, 9, 10),
        value: 5.8,
      );
      final current = GlucoseReading(
        timestamp: DateTime(2026, 6, 9, 10, 5),
        value: 6.4,
      );

      expect(
        calculator.ratePerMin(previous: previous, current: current),
        closeTo(0.12, 0.001),
      );
    });

    test('ignores intervals outside the supported CGM cadence window', () {
      const calculator = GlucoseTrendRateCalculator();
      final previous = GlucoseReading(
        timestamp: DateTime(2026, 6, 9, 10),
        value: 5.8,
      );
      final current = GlucoseReading(
        timestamp: DateTime(2026, 6, 9, 10, 30),
        value: 6.4,
      );

      expect(
        calculator.ratePerMin(previous: previous, current: current),
        isNull,
      );
    });
  });
}

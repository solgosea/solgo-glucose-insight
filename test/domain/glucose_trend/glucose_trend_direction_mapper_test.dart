import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_direction_mapper.dart';

void main() {
  group('GlucoseTrendDirectionMapper', () {
    test('maps Nightscout direction names to fallback rates', () {
      const mapper = GlucoseTrendDirectionMapper();

      expect(mapper.fallbackRatePerMin('DoubleUp'), 0.16);
      expect(mapper.fallbackRatePerMin('SingleUp'), 0.10);
      expect(mapper.fallbackRatePerMin('FortyFiveUp'), 0.06);
      expect(mapper.fallbackRatePerMin('Flat'), 0.0);
      expect(mapper.fallbackRatePerMin('FortyFiveDown'), -0.06);
      expect(mapper.fallbackRatePerMin('SingleDown'), -0.10);
      expect(mapper.fallbackRatePerMin('DoubleDown'), -0.16);
    });

    test('returns null for unknown directions', () {
      const mapper = GlucoseTrendDirectionMapper();

      expect(mapper.fallbackRatePerMin('NOT COMPUTABLE'), isNull);
    });
  });
}

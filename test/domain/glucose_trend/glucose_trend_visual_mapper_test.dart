import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_band.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_visual_mapper.dart';
import 'package:smart_xdrip/foundation/utils/glucose_formatter.dart';

void main() {
  group('GlucoseTrendVisualMapper', () {
    test('maps rates to visual arrows and labels', () {
      const mapper = GlucoseTrendVisualMapper();

      expect(mapper.map(null).arrow, '--');
      expect(mapper.map(null).band, GlucoseTrendBand.unknown);

      expect(mapper.map(0.18).arrow, '↑↑');
      expect(mapper.map(0.18).label, 'Rising fast');
      expect(mapper.map(0.08).arrow, '↑');
      expect(mapper.map(0.01).arrow, '→');
      expect(mapper.map(-0.08).arrow, '↓');
      expect(mapper.map(-0.18).arrow, '↓↓');
      expect(mapper.map(-0.18).label, 'Falling fast');
    });

    test('keeps legacy formatter trend aligned with visual mapper', () {
      expect(GlucoseFormatter.trend(0.18), '↑↑');
      expect(GlucoseFormatter.trend(0.08), '↑');
      expect(GlucoseFormatter.trend(0), '→');
      expect(GlucoseFormatter.trend(-0.08), '↓');
      expect(GlucoseFormatter.trend(-0.18), '↓↓');
    });
  });
}

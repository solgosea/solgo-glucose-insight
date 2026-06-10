import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

void main() {
  group('GlucoseUnitFormatService', () {
    const service = GlucoseUnitFormatService();

    test('formats mmol/L values without converting raw storage values', () {
      final value = service.value(6.42, GlucoseUnit.mmolL);

      expect(value.value, 6.42);
      expect(value.valueLabel, '6.4');
      expect(value.unitLabel, 'mmol/L');
      expect(value.fullLabel, '6.4 mmol/L');
    });

    test('formats mg/dL values by converting from mmol/L', () {
      final value = service.value(10, GlucoseUnit.mgDl);

      expect(value.value, 180);
      expect(value.valueLabel, '180');
      expect(value.unitLabel, 'mg/dL');
      expect(value.fullLabel, '180 mg/dL');
    });

    test('formats ranges and rates in the selected unit', () {
      final range = service.range(3.9, 10, GlucoseUnit.mgDl);
      final rate = service.rate(0.1, GlucoseUnit.mgDl);

      expect(range.fullLabel, '70-180 mg/dL');
      expect(rate.fullLabel, '+1.8 mg/dL/min');
    });

    test('formats area values consistently with unit conversion', () {
      final area = service.area(10, GlucoseUnit.mgDl);

      expect(area.fullLabel, '180 mg/dL-min');
    });
  });
}

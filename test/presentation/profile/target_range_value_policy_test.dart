import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/target_range/target_range_value_policy.dart';

void main() {
  group('TargetRangeValuePolicy', () {
    const policy = TargetRangeValuePolicy();

    test('prevents markers from crossing each other', () {
      const draft = TargetRangeDraft(
        lowMmol: 3.9,
        highMmol: 10.0,
        veryHighMmol: 13.9,
      );

      final next = policy.updateMarker(
        draft: draft,
        marker: TargetRangeMarker.low,
        valueMmol: 12.0,
        unit: GlucoseUnit.mmolL,
      );

      expect(next.lowMmol, lessThan(next.highMmol));
      expect(next.lowMmol, closeTo(9.7, 0.0001));
    });

    test('snaps mg/dL input to whole-number display values', () {
      const draft = TargetRangeDraft(
        lowMmol: 3.9,
        highMmol: 10.0,
        veryHighMmol: 13.9,
      );

      final next = policy.updateMarker(
        draft: draft,
        marker: TargetRangeMarker.high,
        valueMmol: 8.912,
        unit: GlucoseUnit.mgDl,
      );

      expect(policy.displayValue(next.highMmol, GlucoseUnit.mgDl), 160);
    });
  });
}

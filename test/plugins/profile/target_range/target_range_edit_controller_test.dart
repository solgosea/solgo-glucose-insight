import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/target_range/editing/target_range_edit_controller.dart';
import 'package:smart_xdrip/plugins/profile/target_range/editing/target_range_validation_result.dart';
import 'package:smart_xdrip/plugins/profile/target_range/target_range_value_policy.dart';

void main() {
  group('TargetRangeEditController', () {
    const controller = TargetRangeEditController();

    test('initial display unit follows app settings without changing draft',
        () {
      final state = controller.initialize(
        const AppSettings(unit: GlucoseUnit.mgDl),
      );

      expect(state.displayUnit, GlucoseUnit.mgDl);
      expect(state.draft.lowMmol, 3.9);
      expect(state.draft.highMmol, 10.0);
      expect(state.draft.veryHighMmol, 13.9);
    });

    test('switching display unit keeps canonical mmol values unchanged', () {
      final state = controller.initialize(
        const AppSettings(unit: GlucoseUnit.mmolL),
      );
      final switched = controller.switchDisplayUnit(state, GlucoseUnit.mgDl);

      expect(switched.displayUnit, GlucoseUnit.mgDl);
      expect(switched.draft.lowMmol, state.draft.lowMmol);
      expect(switched.draft.highMmol, state.draft.highMmol);
      expect(switched.draft.veryHighMmol, state.draft.veryHighMmol);
    });

    test('mg/dL exact input is converted to canonical mmol draft', () {
      final state = controller.switchDisplayUnit(
        controller.initialize(const AppSettings()),
        GlucoseUnit.mgDl,
      );

      final updated = controller.updateExactValue(
        state: state,
        marker: TargetRangeMarker.high,
        rawDisplayValue: '180',
      );

      expect(updated.draft.highMmol, 10.0);
      expect(updated.displayUnit, GlucoseUnit.mgDl);
    });

    test('invalid exact values surface validation instead of clamping gaps',
        () {
      final state = controller.initialize(const AppSettings());
      final updated = controller.updateExactValue(
        state: state,
        marker: TargetRangeMarker.low,
        rawDisplayValue: '9.9',
      );

      expect(updated.validation.isValid, isFalse);
      expect(updated.validation.invalidMarker, TargetRangeMarker.low);
      expect(
        updated.validation.reason,
        TargetRangeValidationReason.lowTooCloseToHigh,
      );
      expect(updated.validation.gapLabel, isNotEmpty);
    });

    test('marker changes clamp through policy and remain valid', () {
      final state = controller.initialize(const AppSettings());
      final updated = controller.updateMarker(
        state: state,
        marker: TargetRangeMarker.low,
        valueMmol: 12,
      );

      expect(updated.validation.isValid, isTrue);
      expect(updated.draft.lowMmol, lessThan(updated.draft.highMmol));
    });
  });
}

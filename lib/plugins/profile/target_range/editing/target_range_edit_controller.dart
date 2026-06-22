import '../../../../domain/entities/app_settings.dart';
import '../target_range_value_policy.dart';
import 'target_range_edit_state.dart';
import 'target_range_input_formatter.dart';
import 'target_range_validation_result.dart';

class TargetRangeEditController {
  static const defaultDraft = TargetRangeDraft(
    lowMmol: 3.9,
    highMmol: 10.0,
    veryHighMmol: 13.9,
  );

  final TargetRangeValuePolicy policy;
  final TargetRangeInputFormatter inputFormatter;

  const TargetRangeEditController({
    this.policy = const TargetRangeValuePolicy(),
    this.inputFormatter = const TargetRangeInputFormatter(),
  });

  TargetRangeEditState initialize(AppSettings settings) {
    final draft = policy.normalized(
      TargetRangeDraft(
        lowMmol: settings.lowThreshold,
        highMmol: settings.highThreshold,
        veryHighMmol: settings.veryHighThreshold,
      ),
    );
    return TargetRangeEditState(
      draft: draft,
      initialDraft: draft,
      displayUnit: settings.unit,
      validation: validate(draft, settings.unit),
    );
  }

  TargetRangeEditState switchDisplayUnit(
    TargetRangeEditState state,
    GlucoseUnit unit,
  ) {
    return state.copyWith(
      displayUnit: unit,
      validation: validate(state.draft, unit),
    );
  }

  TargetRangeEditState updateMarker({
    required TargetRangeEditState state,
    required TargetRangeMarker marker,
    required double valueMmol,
  }) {
    final draft = policy.updateMarker(
      draft: state.draft,
      marker: marker,
      valueMmol: valueMmol,
      unit: state.displayUnit,
    );
    return state.copyWith(
      draft: draft,
      activeMarker: marker,
      validation: validate(draft, state.displayUnit),
    );
  }

  TargetRangeEditState stepValue({
    required TargetRangeEditState state,
    required TargetRangeMarker marker,
    required int direction,
  }) {
    final value = _valueFor(state.draft, marker) +
        inputFormatter.stepMmol(state.displayUnit) * direction;
    return updateMarker(state: state, marker: marker, valueMmol: value);
  }

  TargetRangeEditState updateExactValue({
    required TargetRangeEditState state,
    required TargetRangeMarker marker,
    required String rawDisplayValue,
  }) {
    final parsed = inputFormatter.parseDisplayToMmol(
      rawDisplayValue,
      state.displayUnit,
    );
    final snapped = inputFormatter.snapMmol(parsed, state.displayUnit);
    final bounded = snapped
        .clamp(TargetRangeValuePolicy.minMmol, TargetRangeValuePolicy.maxMmol)
        .toDouble();
    final draft = switch (marker) {
      TargetRangeMarker.low => state.draft.copyWith(lowMmol: bounded),
      TargetRangeMarker.high => state.draft.copyWith(highMmol: bounded),
      TargetRangeMarker.veryHigh => state.draft.copyWith(veryHighMmol: bounded),
    };
    return state.copyWith(
      draft: draft,
      activeMarker: marker,
      validation: validate(draft, state.displayUnit),
    );
  }

  TargetRangeEditState resetToDefault(TargetRangeEditState state) {
    final draft = policy.normalized(defaultDraft);
    return state.copyWith(
      draft: draft,
      validation: validate(draft, state.displayUnit),
    );
  }

  TargetRangeEditState clearActiveMarker(TargetRangeEditState state) {
    return state.copyWith(clearActiveMarker: true);
  }

  TargetRangeValidationResult validate(
    TargetRangeDraft draft,
    GlucoseUnit unit,
  ) {
    final lowHighOk =
        draft.lowMmol + TargetRangeValuePolicy.minimumGapMmol <= draft.highMmol;
    final highVeryHighOk =
        draft.highMmol + TargetRangeValuePolicy.minimumGapMmol <=
            draft.veryHighMmol;
    final gap = inputFormatter.label(
      TargetRangeValuePolicy.minimumGapMmol,
      unit,
    );
    final unitLabel = inputFormatter.unitLabel(unit);
    if (!lowHighOk) {
      return TargetRangeValidationResult(
        isValid: false,
        invalidMarker: TargetRangeMarker.low,
        reason: TargetRangeValidationReason.lowTooCloseToHigh,
        gapLabel: gap,
        unitLabel: unitLabel,
      );
    }
    if (!highVeryHighOk) {
      return TargetRangeValidationResult(
        isValid: false,
        invalidMarker: TargetRangeMarker.high,
        reason: TargetRangeValidationReason.highTooCloseToVeryHigh,
        gapLabel: gap,
        unitLabel: unitLabel,
      );
    }
    return const TargetRangeValidationResult.valid();
  }

  double _valueFor(TargetRangeDraft draft, TargetRangeMarker marker) {
    return switch (marker) {
      TargetRangeMarker.low => draft.lowMmol,
      TargetRangeMarker.high => draft.highMmol,
      TargetRangeMarker.veryHigh => draft.veryHighMmol,
    };
  }
}

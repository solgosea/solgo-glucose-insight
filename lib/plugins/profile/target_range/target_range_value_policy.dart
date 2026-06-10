import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/glucose_unit/glucose_unit_converter.dart';

class TargetRangeDraft {
  final double lowMmol;
  final double highMmol;
  final double veryHighMmol;

  const TargetRangeDraft({
    required this.lowMmol,
    required this.highMmol,
    required this.veryHighMmol,
  });

  TargetRangeDraft copyWith({
    double? lowMmol,
    double? highMmol,
    double? veryHighMmol,
  }) {
    return TargetRangeDraft(
      lowMmol: lowMmol ?? this.lowMmol,
      highMmol: highMmol ?? this.highMmol,
      veryHighMmol: veryHighMmol ?? this.veryHighMmol,
    );
  }
}

enum TargetRangeMarker { low, high, veryHigh }

class TargetRangeValuePolicy {
  static const minMmol = 2.0;
  static const maxMmol = 20.0;
  static const minimumGapMmol = 0.3;

  final GlucoseUnitConverter converter;

  const TargetRangeValuePolicy({this.converter = const GlucoseUnitConverter()});

  TargetRangeDraft normalized(TargetRangeDraft draft) {
    final low = draft.lowMmol.clamp(minMmol, maxMmol - minimumGapMmol * 2);
    final high = draft.highMmol.clamp(
      low + minimumGapMmol,
      maxMmol - minimumGapMmol,
    );
    final veryHigh = draft.veryHighMmol.clamp(high + minimumGapMmol, maxMmol);
    return TargetRangeDraft(
      lowMmol: low.toDouble(),
      highMmol: high.toDouble(),
      veryHighMmol: veryHigh.toDouble(),
    );
  }

  TargetRangeDraft updateMarker({
    required TargetRangeDraft draft,
    required TargetRangeMarker marker,
    required double valueMmol,
    required GlucoseUnit unit,
  }) {
    final snapped = _snap(valueMmol, unit);
    return switch (marker) {
      TargetRangeMarker.low => draft.copyWith(
        lowMmol:
            snapped.clamp(minMmol, draft.highMmol - minimumGapMmol).toDouble(),
      ),
      TargetRangeMarker.high => draft.copyWith(
        highMmol:
            snapped
                .clamp(
                  draft.lowMmol + minimumGapMmol,
                  draft.veryHighMmol - minimumGapMmol,
                )
                .toDouble(),
      ),
      TargetRangeMarker.veryHigh => draft.copyWith(
        veryHighMmol:
            snapped.clamp(draft.highMmol + minimumGapMmol, maxMmol).toDouble(),
      ),
    };
  }

  double displayValue(double mmol, GlucoseUnit unit) {
    return converter.valueFromMmol(mmol, unit);
  }

  double displayToMmol(double value, GlucoseUnit unit) {
    return converter.valueToMmol(value, unit);
  }

  double _snap(double mmol, GlucoseUnit unit) {
    final display = displayValue(mmol, unit);
    final snappedDisplay = switch (unit) {
      GlucoseUnit.mmolL => (display * 10).round() / 10,
      GlucoseUnit.mgDl => display.roundToDouble(),
    };
    return displayToMmol(snappedDisplay, unit);
  }
}

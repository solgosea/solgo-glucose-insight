import '../target_range_value_policy.dart';

enum TargetRangeValidationReason {
  lowTooCloseToHigh,
  highTooCloseToVeryHigh,
}

class TargetRangeValidationResult {
  final bool isValid;
  final TargetRangeMarker? invalidMarker;
  final TargetRangeValidationReason? reason;
  final String gapLabel;
  final String unitLabel;
  final String message;

  const TargetRangeValidationResult({
    required this.isValid,
    this.invalidMarker,
    this.reason,
    this.gapLabel = '',
    this.unitLabel = '',
    this.message = '',
  });

  const TargetRangeValidationResult.valid()
      : isValid = true,
        invalidMarker = null,
        reason = null,
        gapLabel = '',
        unitLabel = '',
        message = '';
}

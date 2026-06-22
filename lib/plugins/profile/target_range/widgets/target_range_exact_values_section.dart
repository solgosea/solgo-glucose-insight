import 'package:flutter/material.dart';

import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../../application/i18n/profile_l10n.dart';
import '../editing/target_range_edit_state.dart';
import '../target_range_value_policy.dart';
import 'target_range_exact_value_card.dart';

class TargetRangeExactValuesSection extends StatelessWidget {
  final TargetRangeEditState state;
  final TextEditingController lowController;
  final TextEditingController highController;
  final TextEditingController veryHighController;
  final FocusNode lowFocusNode;
  final FocusNode highFocusNode;
  final FocusNode veryHighFocusNode;
  final void Function(TargetRangeMarker marker, int direction) onStep;
  final void Function(TargetRangeMarker marker, String value) onChanged;

  const TargetRangeExactValuesSection({
    super.key,
    required this.state,
    required this.lowController,
    required this.highController,
    required this.veryHighController,
    required this.lowFocusNode,
    required this.highFocusNode,
    required this.veryHighFocusNode,
    required this.onStep,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    final unitLabel = const GlucoseUnitFormatService().unitLabel(
      state.displayUnit,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            l10n.targetRangeExactValues,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppColors.textDim,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        TargetRangeExactValueCard(
          marker: TargetRangeMarker.low,
          label: l10n.targetRangeLowLabel,
          color: AppColors.blue,
          unitLabel: unitLabel,
          controller: lowController,
          focusNode: lowFocusNode,
          invalid: _invalid(TargetRangeMarker.low),
          onDecrease: () => onStep(TargetRangeMarker.low, -1),
          onIncrease: () => onStep(TargetRangeMarker.low, 1),
          onChanged: (value) => onChanged(TargetRangeMarker.low, value),
        ),
        TargetRangeExactValueCard(
          marker: TargetRangeMarker.high,
          label: l10n.targetRangeHighLabel,
          color: AppColors.amber,
          unitLabel: unitLabel,
          controller: highController,
          focusNode: highFocusNode,
          invalid: _invalid(TargetRangeMarker.high),
          onDecrease: () => onStep(TargetRangeMarker.high, -1),
          onIncrease: () => onStep(TargetRangeMarker.high, 1),
          onChanged: (value) => onChanged(TargetRangeMarker.high, value),
        ),
        TargetRangeExactValueCard(
          marker: TargetRangeMarker.veryHigh,
          label: l10n.targetRangeVeryHighLabel,
          color: AppColors.rose,
          unitLabel: unitLabel,
          controller: veryHighController,
          focusNode: veryHighFocusNode,
          invalid: _invalid(TargetRangeMarker.veryHigh),
          onDecrease: () => onStep(TargetRangeMarker.veryHigh, -1),
          onIncrease: () => onStep(TargetRangeMarker.veryHigh, 1),
          onChanged: (value) => onChanged(TargetRangeMarker.veryHigh, value),
        ),
      ],
    );
  }

  bool _invalid(TargetRangeMarker marker) {
    if (state.validation.isValid) return false;
    final invalid = state.validation.invalidMarker;
    if (invalid == TargetRangeMarker.low) {
      return marker == TargetRangeMarker.low ||
          marker == TargetRangeMarker.high;
    }
    if (invalid == TargetRangeMarker.high) {
      return marker == TargetRangeMarker.high ||
          marker == TargetRangeMarker.veryHigh;
    }
    return marker == invalid;
  }
}

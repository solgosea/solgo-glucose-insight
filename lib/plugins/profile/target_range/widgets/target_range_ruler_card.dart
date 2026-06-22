import 'package:flutter/material.dart';

import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../../application/i18n/profile_l10n.dart';
import '../target_range_value_policy.dart';
import 'target_range_multi_marker_ruler.dart';

class TargetRangeRulerCard extends StatelessWidget {
  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final TargetRangeMarker? activeMarker;
  final ValueChanged<TargetRangeMarker?> onMarkerActiveChanged;
  final void Function(TargetRangeMarker marker, double valueMmol) onChanged;

  const TargetRangeRulerCard({
    super.key,
    required this.draft,
    required this.unit,
    required this.activeMarker,
    required this.onMarkerActiveChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    final unitLabel = const GlucoseUnitFormatService().unitLabel(unit);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          TargetRangeMultiMarkerRuler(
            draft: draft,
            unit: unit,
            activeMarker: activeMarker,
            onMarkerActiveChanged: onMarkerActiveChanged,
            onChanged: onChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.swipe_rounded,
                color: AppColors.textDim,
                size: 13,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.targetRangeDragHint,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textDim,
                  ),
                ),
              ),
              Text(
                unitLabel,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDim,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

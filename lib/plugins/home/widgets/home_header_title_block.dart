import 'package:flutter/material.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/i18n/home_l10n.dart';
import 'home_unit_quick_switch.dart';

class HomeHeaderTitleBlock extends StatelessWidget {
  final GlucoseUnit unit;
  final ValueChanged<GlucoseUnit> onUnitChanged;

  const HomeHeaderTitleBlock({
    super.key,
    required this.unit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.homeL10n.homeCompanionEyebrow,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.98,
            color: AppColors.textDim,
          ),
        ),
        const SizedBox(height: 8),
        HomeUnitQuickSwitch(
          unit: unit,
          onChanged: onUnitChanged,
        ),
      ],
    );
  }
}

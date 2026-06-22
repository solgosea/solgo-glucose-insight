import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/i18n/home_l10n.dart';

class HomeInspectionBadge extends StatelessWidget {
  final bool visible;

  const HomeInspectionBadge({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        opacity: visible ? 1 : 0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.amber.withOpacity(0.30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Text(
            context.homeL10n.homeInspectingPast,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.amber,
            ),
          ),
        ),
      ),
    );
  }
}

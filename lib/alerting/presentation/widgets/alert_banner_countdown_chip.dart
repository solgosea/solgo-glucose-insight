import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';

class AlertBannerCountdownChip extends StatelessWidget {
  final String label;

  const AlertBannerCountdownChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.amber.withValues(alpha: .35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.amber, size: 11),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.amber,
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

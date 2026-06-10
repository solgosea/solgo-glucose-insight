import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';

class AlertBannerStatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const AlertBannerStatusChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 11),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                color: color == AppColors.textSoft ? AppColors.textSoft : color,
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

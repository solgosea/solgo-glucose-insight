import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';

class DateFilterIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const DateFilterIconButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 20,
              color: AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

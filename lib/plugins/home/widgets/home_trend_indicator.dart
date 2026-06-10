import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class HomeTrendIndicator extends StatelessWidget {
  final String arrow;
  final String label;

  const HomeTrendIndicator({
    super.key,
    required this.arrow,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          child: Text(
            arrow,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w700,
              color: AppColors.amber,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.amber,
          ),
        ),
      ],
    );
  }
}

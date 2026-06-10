import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class HomeValuePill extends StatelessWidget {
  final String text;

  const HomeValuePill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.12),
        border: Border.all(color: AppColors.amber.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          color: AppColors.amber,
        ),
      ),
    );
  }
}

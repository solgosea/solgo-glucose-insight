import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class InsightSectionLabel extends StatelessWidget {
  final String text;

  const InsightSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          color: AppColors.textDim,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

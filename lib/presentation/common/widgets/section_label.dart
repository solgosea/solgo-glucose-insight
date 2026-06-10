import 'package:flutter/material.dart';
import '../../../foundation/theme/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  const SectionLabel(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 8),
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.6,
        color: AppColors.textDim,
      ),
    ),
  );
}

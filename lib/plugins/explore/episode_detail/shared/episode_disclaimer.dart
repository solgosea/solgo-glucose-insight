import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';

/// Centered mono-font disclaimer at the bottom of episode pages.
class EpisodeDisclaimer extends StatelessWidget {
  final String text;
  const EpisodeDisclaimer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          color: AppColors.textDim,
          height: 1.6,
        ),
      ),
    );
  }
}

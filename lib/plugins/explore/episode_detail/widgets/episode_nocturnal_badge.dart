import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class EpisodeNocturnalBadge extends StatelessWidget {
  const EpisodeNocturnalBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.18),
        border: Border.all(color: AppColors.blue.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.nightlight_round, size: 10, color: AppColors.blue),
          SizedBox(width: 4),
          Text(
            'Nocturnal',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

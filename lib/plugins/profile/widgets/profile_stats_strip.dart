import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/profile_view_model.dart';

class ProfileStatsStrip extends StatelessWidget {
  final List<ProfileStatViewModel> stats;

  const ProfileStatsStrip({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: SizedBox(
        height: 82,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < stats.length; index++) ...[
              Expanded(child: _StatCard(stat: stats[index])),
              if (index != stats.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final ProfileStatViewModel stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat.value,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: stat.valueColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
            child: Text(
              stat.unit ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: AppColors.textSoft,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              color: AppColors.textDim,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

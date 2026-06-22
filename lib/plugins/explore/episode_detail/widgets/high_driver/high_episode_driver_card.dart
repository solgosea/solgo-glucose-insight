import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../shared/episode_section_label.dart';

class HighEpisodeDriverCard extends StatelessWidget {
  final HighEpisodeDriverViewModel viewModel;

  const HighEpisodeDriverCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    final bars = [
      (l10n.peak, viewModel.peakScore),
      (l10n.duration, viewModel.durationScore),
      (l10n.rise, viewModel.riseScore),
      (l10n.recovery, viewModel.recoveryScore),
      (l10n.repeatPattern, viewModel.repeatScore),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EpisodeSectionLabel(index: '05', title: l10n.mainDriver),
        EpisodeSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                viewModel.body,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSoft,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              for (final item in bars)
                _DriverBar(label: item.$1, value: item.$2),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriverBar extends StatelessWidget {
  final String label;
  final double value;

  const _DriverBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 1).toDouble();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textDim,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 7,
                value: clamped,
                backgroundColor: AppColors.bgCard2,
                valueColor: const AlwaysStoppedAnimation(AppColors.rose),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

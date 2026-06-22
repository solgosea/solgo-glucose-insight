import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../shared/episode_section_label.dart';

class HighEpisodeReliabilityCard extends StatelessWidget {
  final HighEpisodeReliabilityViewModel viewModel;

  const HighEpisodeReliabilityCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EpisodeSectionLabel(
          index: '09',
          title: l10n.dataQuality,
          trailing: l10n.episodeWindow,
        ),
        EpisodeSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final metric in viewModel.metrics) _Metric(metric: metric),
              const SizedBox(height: 4),
              Text(
                viewModel.note,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSoft,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final HighEpisodeContextMetricViewModel metric;

  const _Metric({required this.metric});

  @override
  Widget build(BuildContext context) {
    final accent = metric.accent ?? AppColors.green;
    final progress = (metric.progress ?? 0.5).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: AppColors.textSoft,
                  ),
                ),
              ),
              Text(
                metric.value,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress,
              backgroundColor: AppColors.bgCard2,
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
        ],
      ),
    );
  }
}

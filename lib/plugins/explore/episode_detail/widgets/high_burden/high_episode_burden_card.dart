import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../shared/episode_section_label.dart';

class HighEpisodeBurdenCard extends StatelessWidget {
  final HighEpisodeBurdenViewModel viewModel;

  const HighEpisodeBurdenCard({
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
          index: '02',
          title: l10n.burdenBreakdown,
          trailing: l10n.toBelowHighThreshold,
        ),
        EpisodeSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (var i = 0; i < viewModel.metrics.length; i++) ...[
                    Expanded(child: _Metric(metric: viewModel.metrics[i])),
                    if (i != viewModel.metrics.length - 1)
                      const SizedBox(width: 7),
                  ],
                ],
              ),
              const SizedBox(height: 12),
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
  final HighEpisodeBurdenMetricViewModel metric;

  const _Metric({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: metric.accent,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _shortLabel(metric.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 7,
              color: AppColors.textDim,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  String _shortLabel(String label) {
    switch (label.toLowerCase()) {
      case 'peak':
        return 'PEAK OVER';
      case 'exposure':
        return 'AREA';
      case 'duration':
        return 'DURATION';
      case 'recovery':
        return 'RECOVERED';
      default:
        return label.toUpperCase();
    }
  }
}

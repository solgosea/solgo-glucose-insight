import 'package:flutter/material.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../shared/episode_section_label.dart';

class LowEpisodeBurdenCard extends StatelessWidget {
  final LowEpisodeBurdenViewModel viewModel;

  const LowEpisodeBurdenCard({
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
          trailing: l10n.belowTarget,
          accent: LowEpisodeStyle.blue,
        ),
        EpisodeSectionCard(
          color: LowEpisodeStyle.panel,
          borderColor: LowEpisodeStyle.line,
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
                  color: LowEpisodeStyle.soft,
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
  final LowEpisodeBurdenMetricViewModel metric;

  const _Metric({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: LowEpisodeStyle.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LowEpisodeStyle.line),
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
              fontSize: 12,
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
              color: LowEpisodeStyle.muted,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  String _shortLabel(String label) {
    switch (label.toLowerCase()) {
      case 'nadir gap':
        return 'NADIR GAP';
      case 'area':
        return 'AREA';
      case 'drop/min':
        return 'DROP/MIN';
      case 'recovered':
        return 'RECOVERED';
      default:
        return label.toUpperCase();
    }
  }
}

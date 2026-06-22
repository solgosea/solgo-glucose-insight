import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../shared/episode_section_label.dart';

class LowEpisodeContextCard extends StatelessWidget {
  final LowEpisodeContextViewModel viewModel;

  const LowEpisodeContextCard({
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
          index: '07',
          title: l10n.personalContext,
          trailing: l10n.baseline,
          accent: LowEpisodeStyle.blue,
        ),
        EpisodeSectionCard(
          color: LowEpisodeStyle.panel,
          borderColor: LowEpisodeStyle.line,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: LowEpisodeStyle.line)),
                ),
                child: Column(
                  children: [
                    for (final metric in viewModel.metrics)
                      _MetricRow(metric: metric),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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

class _MetricRow extends StatelessWidget {
  final HighEpisodeContextMetricViewModel metric;

  const _MetricRow({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LowEpisodeStyle.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LowEpisodeStyle.text,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${metric.value} · ${metric.detail}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: LowEpisodeStyle.soft,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _Badge(
            label: metric.badgeLabel ?? context.episodeDetailL10n.note,
            color: metric.badgeColor ?? AppColors.amber,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color == AppColors.green || color == AppColors.blue
        ? const Color(0xFF061019)
        : const Color(0xFF171006);
    return Container(
      constraints: const BoxConstraints(minWidth: 56),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: textColor,
          height: 1,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';

class LowEpisodeSummaryCard extends StatelessWidget {
  final LowEpisodeSummaryViewModel viewModel;

  const LowEpisodeSummaryCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            LowEpisodeStyle.blue.withOpacity(0.11),
            LowEpisodeStyle.panel.withOpacity(0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LowEpisodeStyle.lineStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: LowEpisodeStyle.text,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      viewModel.subtitle,
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
              const SizedBox(width: 14),
              _PriorityPill(
                label: viewModel.priorityLabel,
                color: viewModel.priorityColor,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: l10n.nadir,
                  value: _compactMetric(viewModel.nadirText),
                  color: LowEpisodeStyle.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Stat(
                  label: l10n.duration,
                  value: _compactMetric(viewModel.durationText),
                  color: LowEpisodeStyle.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Stat(
                  label: l10n.recovery,
                  value: viewModel.recoveryTimeText,
                  color: LowEpisodeStyle.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _compactMetric(String value) {
    if (value == 'Unknown') return value;
    if (value.endsWith(' min')) return '${value.replaceAll(' min', '')}m';
    final parts = value.split(' ');
    return parts.isEmpty ? value : parts.first;
  }
}

class _PriorityPill extends StatelessWidget {
  final String label;
  final Color color;

  const _PriorityPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = color == AppColors.blue || color == LowEpisodeStyle.blue
        ? const Color(0xFF061019)
        : const Color(0xFF171006);
    return SizedBox(
      width: 94,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: textColor,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.episodeDetailL10n.reviewPriority.toUpperCase(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              color: LowEpisodeStyle.muted,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: LowEpisodeStyle.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LowEpisodeStyle.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 7.5,
              color: LowEpisodeStyle.muted,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

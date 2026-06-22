import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../shared/episode_section_label.dart';

class LowEpisodeLifecycleCard extends StatelessWidget {
  final LowEpisodeLifecycleViewModel viewModel;

  const LowEpisodeLifecycleCard({
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
          index: '03',
          title: l10n.episodeLifecycle,
          trailing: l10n.episodeWindow,
          accent: LowEpisodeStyle.blue,
        ),
        EpisodeSectionCard(
          color: LowEpisodeStyle.panel,
          borderColor: LowEpisodeStyle.line,
          child: SizedBox(
            height: 92,
            child: Stack(
              children: [
                Positioned(
                  left: 28,
                  right: 28,
                  top: 16,
                  child:
                      Container(height: 1, color: LowEpisodeStyle.lineStrong),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final step in viewModel.steps)
                      Expanded(child: _Step(step: step)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final LowEpisodeLifecycleStepViewModel step;

  const _Step({required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _filled ? step.color : LowEpisodeStyle.panel2,
            border: Border.all(
              color: _filled ? step.color : LowEpisodeStyle.lineStrong,
            ),
          ),
          child: Text(
            step.code,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: _filled ? const Color(0xFF06121A) : step.color,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          step.label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: LowEpisodeStyle.text,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          step.value,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 7.5,
            color: LowEpisodeStyle.muted,
            height: 1.25,
          ),
        ),
      ],
    );
  }

  bool get _filled =>
      step.color == AppColors.blue || step.color == AppColors.amber;
}

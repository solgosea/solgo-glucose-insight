import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../shared/episode_section_label.dart';

class HighEpisodeLifecycleCard extends StatelessWidget {
  final HighEpisodeLifecycleViewModel viewModel;

  const HighEpisodeLifecycleCard({
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
        ),
        EpisodeSectionCard(
          child: SizedBox(
            height: 92,
            child: Stack(
              children: [
                Positioned(
                  left: 28,
                  right: 28,
                  top: 16,
                  child: Container(height: 1, color: AppColors.border),
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
  final HighEpisodeLifecycleStepViewModel step;

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
            color: _filled ? step.color : AppColors.bgCard2,
            border: Border.all(
              color: _filled ? step.color : AppColors.border,
            ),
          ),
          child: Text(
            step.code,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: _filled ? _filledTextColor : step.color,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          step.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
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
            color: AppColors.textDim,
            height: 1.25,
          ),
        ),
      ],
    );
  }

  bool get _filled =>
      step.color == AppColors.rose || step.color == AppColors.amber;

  Color get _filledTextColor => step.color == AppColors.rose
      ? const Color(0xFF160907)
      : const Color(0xFF171006);
}

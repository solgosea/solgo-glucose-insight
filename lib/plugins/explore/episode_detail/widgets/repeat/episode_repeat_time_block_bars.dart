import 'package:flutter/material.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';

class EpisodeRepeatTimeBlockBars extends StatelessWidget {
  final List<EpisodeRepeatTimeBlockViewModel> blocks;
  final Color panelColor;
  final Color borderColor;
  final Color dominantColor;
  final Color secondaryColor;
  final Color mutedColor;
  final Color textColor;

  const EpisodeRepeatTimeBlockBars({
    super.key,
    required this.blocks,
    required this.panelColor,
    required this.borderColor,
    required this.dominantColor,
    required this.secondaryColor,
    required this.mutedColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 9),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.episodeDetailL10n.repeatByTimeOfDay.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 8,
                    color: mutedColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Text(
                context.episodeDetailL10n.episodeCount.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 8,
                  color: mutedColor,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 104,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final block in blocks) ...[
                  Expanded(
                    child: _BlockBar(
                      block: block,
                      dominantColor: dominantColor,
                      secondaryColor: secondaryColor,
                      mutedColor: mutedColor,
                      textColor: textColor,
                      borderColor: borderColor,
                    ),
                  ),
                  if (block != blocks.last) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockBar extends StatelessWidget {
  final EpisodeRepeatTimeBlockViewModel block;
  final Color dominantColor;
  final Color secondaryColor;
  final Color mutedColor;
  final Color textColor;
  final Color borderColor;

  const _BlockBar({
    required this.block,
    required this.dominantColor,
    required this.secondaryColor,
    required this.mutedColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = block.isDominant
        ? dominantColor
        : block.isSecondary
            ? secondaryColor
            : mutedColor.withOpacity(0.52);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: mutedColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: borderColor),
              ),
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: block.normalizedHeight.clamp(0.05, 1.0),
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${block.count}',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          block.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 7,
            color: mutedColor,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';

class EpisodeRepeatDayStrip extends StatelessWidget {
  final List<EpisodeRepeatDayMarkViewModel> marks;
  final Color panelColor;
  final Color borderColor;
  final Color hitColor;
  final Color strongColor;
  final Color currentColor;
  final Color mutedColor;

  const EpisodeRepeatDayStrip({
    super.key,
    required this.marks,
    required this.panelColor,
    required this.borderColor,
    required this.hitColor,
    required this.strongColor,
    required this.currentColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 10, 9, 9),
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
                  l10n.thirtyDayOccurrenceStrip.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 8,
                    color: mutedColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Text(
                l10n.olderToToday.toUpperCase(),
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: marks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 15,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              final mark = marks[index];
              return _DayCell(
                mark: mark,
                hitColor: hitColor,
                strongColor: strongColor,
                currentColor: currentColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              );
            },
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 10,
            runSpacing: 5,
            children: [
              _Legend(color: mutedColor, label: l10n.noEpisode),
              _Legend(color: hitColor, label: l10n.episode),
              _Legend(color: currentColor, label: l10n.current),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final EpisodeRepeatDayMarkViewModel mark;
  final Color hitColor;
  final Color strongColor;
  final Color currentColor;
  final Color mutedColor;
  final Color borderColor;

  const _DayCell({
    required this.mark,
    required this.hitColor,
    required this.strongColor,
    required this.currentColor,
    required this.mutedColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = mark.isCurrent
        ? currentColor
        : mark.isStrong
            ? strongColor
            : mark.hasEpisode
                ? hitColor.withOpacity(0.44)
                : mutedColor.withOpacity(0.18);
    return Tooltip(
      message: mark.label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: mark.hasEpisode || mark.isCurrent
                ? color.withOpacity(0.86)
                : borderColor,
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 8,
            color: color,
          ),
        ),
      ],
    );
  }
}

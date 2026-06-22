import 'package:flutter/material.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../shared/episode_section_label.dart';
import 'episode_repeat_day_strip.dart';
import 'episode_repeat_summary_tiles.dart';
import 'episode_repeat_time_block_bars.dart';

class EpisodeRepeatChartCard extends StatelessWidget {
  final String index;
  final String title;
  final String trailing;
  final String summaryStat;
  final String summaryLabel;
  final String clusterTitle;
  final String clusterBody;
  final List<EpisodeRepeatDayMarkViewModel> dayMarks;
  final List<EpisodeRepeatTimeBlockViewModel> timeBlocks;
  final String takeaway;
  final Color cardColor;
  final Color panelColor;
  final Color borderColor;
  final Color accentColor;
  final Color hitColor;
  final Color strongColor;
  final Color currentColor;
  final Color secondaryColor;
  final Color textColor;
  final Color softColor;
  final Color mutedColor;

  const EpisodeRepeatChartCard({
    super.key,
    required this.index,
    required this.title,
    required this.trailing,
    required this.summaryStat,
    required this.summaryLabel,
    required this.clusterTitle,
    required this.clusterBody,
    required this.dayMarks,
    required this.timeBlocks,
    required this.takeaway,
    required this.cardColor,
    required this.panelColor,
    required this.borderColor,
    required this.accentColor,
    required this.hitColor,
    required this.strongColor,
    required this.currentColor,
    required this.secondaryColor,
    required this.textColor,
    required this.softColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EpisodeSectionLabel(
          index: index,
          title: title,
          trailing: trailing,
          accent: accentColor,
        ),
        EpisodeSectionCard(
          color: cardColor,
          borderColor: borderColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EpisodeRepeatSummaryTiles(
                summaryStat: summaryStat,
                summaryLabel: summaryLabel,
                clusterTitle: clusterTitle,
                clusterBody: clusterBody,
                panelColor: panelColor,
                borderColor: borderColor,
                accentColor: accentColor,
                textColor: textColor,
                softColor: softColor,
                mutedColor: mutedColor,
              ),
              const SizedBox(height: 12),
              EpisodeRepeatDayStrip(
                marks: dayMarks,
                panelColor: panelColor,
                borderColor: borderColor,
                hitColor: hitColor,
                strongColor: strongColor,
                currentColor: currentColor,
                mutedColor: mutedColor,
              ),
              const SizedBox(height: 12),
              EpisodeRepeatTimeBlockBars(
                blocks: timeBlocks,
                panelColor: panelColor,
                borderColor: borderColor,
                dominantColor: strongColor,
                secondaryColor: secondaryColor,
                mutedColor: mutedColor,
                textColor: textColor,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    height: 1.55,
                    color: softColor,
                  ),
                  children: [
                    TextSpan(
                      text: '${l10n.patternTakeaway}: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    TextSpan(text: takeaway),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

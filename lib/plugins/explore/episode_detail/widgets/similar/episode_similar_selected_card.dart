import 'package:flutter/material.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';

class EpisodeSimilarSelectedCard extends StatelessWidget {
  final EpisodeSimilarSelectionViewModel selection;
  final Color panelColor;
  final Color borderColor;
  final Color textColor;
  final Color softColor;
  final Color mutedColor;

  const EpisodeSimilarSelectedCard({
    super.key,
    required this.selection,
    required this.panelColor,
    required this.borderColor,
    required this.textColor,
    required this.softColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selection.dateLabel,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: selection.badgeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selection.title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selection.description,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        height: 1.42,
                        color: softColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: selection.badgeColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  selection.matchLabel,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: selection.badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              _Metric(
                label: l10n.value,
                value: selection.valueText,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),
              const SizedBox(width: 7),
              _Metric(
                label: l10n.duration,
                value: selection.durationText,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),
              const SizedBox(width: 7),
              _Metric(
                label: l10n.recovery,
                value: selection.recoveryText,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  const _Metric({
    required this.label,
    required this.value,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          color: Colors.black.withOpacity(0.06),
        ),
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 7,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

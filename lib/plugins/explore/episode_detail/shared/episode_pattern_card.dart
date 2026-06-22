import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../application/i18n/episode_detail_l10n.dart';

/// Day indicator (one of N small dots used to visualize past-window
/// occurrences inside the Pattern card).
class PatternDayIndicator {
  final String label; // e.g. "Jun 3"
  final bool active; // colored dot vs dim dot

  const PatternDayIndicator({required this.label, required this.active});
}

/// Pattern Analysis card.
class EpisodePatternCard extends StatelessWidget {
  final String bigStat; // e.g. "5/14"
  final String description; // e.g. "Morning-window highs in the last 14 days"
  final Color statColor; // amber (high) or blue (low)
  final List<PatternDayIndicator> indicators;
  final Color activeDotColor; // dot color when active
  final String patternText; // narrative paragraph
  final String? extraNote; // optional second mono note (low only)
  final String caveat; // e.g. "n=5 · correlation · not causal"

  const EpisodePatternCard({
    super.key,
    required this.bigStat,
    required this.description,
    required this.statColor,
    required this.indicators,
    required this.activeDotColor,
    required this.patternText,
    required this.caveat,
    this.extraNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.episodeDetailL10n.patternAnalysis.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textDim,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                bigStat,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: statColor,
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSoft,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: indicators
                .map((d) => _DayDot(
                      label: d.label,
                      color: d.active ? activeDotColor : AppColors.textDim,
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Text(
            patternText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.textSoft,
              height: 1.6,
            ),
          ),
          if (extraNote != null) ...[
            const SizedBox(height: 8),
            Text(
              extraNote!,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textDim,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            caveat,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String label;
  final Color color;
  const _DayDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 7,
            color: AppColors.textDim,
          ),
        ),
      ],
    );
  }
}

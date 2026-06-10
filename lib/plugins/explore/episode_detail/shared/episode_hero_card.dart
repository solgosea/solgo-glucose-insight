import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';

/// Hero card displayed at the top of an episode detail page.
///
/// Layout:
///   row 1: [PEAK/NADIR VALUE label + 36px value + unit]    [DURATION label + 24px value + range]
///   row 2: 3 mini stats (onset rate / recovery rate / area out of target)
///
/// `themeColor` controls the hero tint, the big value color, and one of the
/// three mini stats (onset for high, descent for low).
class EpisodeHeroCard extends StatelessWidget {
  /// "Peak Value" or "Nadir Value".
  final String valueLabel;
  final String valueText; // e.g. "10.8"
  final String valueUnit; // e.g. "mmol/L"
  final Color valueColor; // rose for high, blue for low

  final String durationText; // e.g. "38 min"
  final String durationRange; // e.g. "07:45 - 08:23"

  final String onsetRateLabel; // "Onset rate" or "Descent rate"
  final String onsetRateText; // e.g. "+0.28 mmol/L/min"
  final Color onsetRateColor; // amber for high, blue for low

  final String recoveryRateText; // e.g. "-0.14 mmol/L/min"

  final String areaLabel; // "Area above target" or "Area below target"
  final String areaText; // e.g. "18.4 mmol-min"
  final Color areaColor; // rose for high, blue for low

  final Color heroBg; // tinted background (rose/blue at 0.06)
  final Color heroBorder; // tinted border  (rose/blue at 0.20)

  /// Optional badge rendered next to duration range (used for nocturnal lows).
  final Widget? trailingBadge;

  const EpisodeHeroCard({
    super.key,
    required this.valueLabel,
    required this.valueText,
    required this.valueUnit,
    required this.valueColor,
    required this.durationText,
    required this.durationRange,
    required this.onsetRateLabel,
    required this.onsetRateText,
    required this.onsetRateColor,
    required this.recoveryRateText,
    required this.areaLabel,
    required this.areaText,
    required this.areaColor,
    required this.heroBg,
    required this.heroBorder,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: heroBg,
        border: Border.all(color: heroBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: peak/nadir on the left, duration on the right.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label(text: valueLabel),
                    const SizedBox(height: 4),
                    Text(
                      valueText,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: valueColor,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      valueUnit,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const _Label(text: 'DURATION'),
                  const SizedBox(height: 4),
                  Text(
                    durationText,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    durationRange,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textDim,
                    ),
                  ),
                  if (trailingBadge != null) ...[
                    const SizedBox(height: 6),
                    trailingBadge!,
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Row 2: 3 mini stats with semantic coloring.
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: onsetRateLabel.toUpperCase(),
                  value: onsetRateText,
                  color: onsetRateColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HeroStat(
                  label: 'RECOVERY',
                  value: recoveryRateText,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HeroStat(
                  label: areaLabel.toUpperCase(),
                  value: areaText,
                  color: areaColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 8,
        color: AppColors.textDim,
        letterSpacing: 0.96,
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _HeroStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 8,
            color: AppColors.textDim,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

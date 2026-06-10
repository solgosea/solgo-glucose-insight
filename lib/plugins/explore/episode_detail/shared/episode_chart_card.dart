import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../domain/entities/glucose_reading.dart';
import '../../../../presentation/common/widgets/charts/glucose_line_chart.dart';

/// Card wrapping the GlucoseLineChart for an episode page.
///
/// Renders the section label inside the card (matches HTML's "sc-label inside
/// the card" convention used on the Stats page) and feeds three event markers
/// to the chart: onset (amber), peak/nadir (theme color), recovery (green).
///
/// `peakOrNadirTime` is computed by the caller from the readings window
/// (argmax / argmin around the episode window). The shared widget does not
/// touch the GlucoseEvent entity to keep the engine layer untouched.
class EpisodeChartCard extends StatelessWidget {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final DateTime onsetTime;
  final DateTime peakOrNadirTime;
  final DateTime? recoveryTime;
  final Color themeColor; // rose for high, blue for low
  final ChartEpisode? episode; // tinted segment for the episode duration

  const EpisodeChartCard({
    super.key,
    required this.readings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.onsetTime,
    required this.peakOrNadirTime,
    required this.themeColor,
    this.recoveryTime,
    this.episode,
  });

  @override
  Widget build(BuildContext context) {
    final markers = <ChartEventMarker>[
      ChartEventMarker(time: onsetTime, color: AppColors.amber),
      ChartEventMarker(time: peakOrNadirTime, color: themeColor),
      if (recoveryTime != null)
        ChartEventMarker(time: recoveryTime!, color: AppColors.green),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EPISODE TIMELINE',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textDim,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          GlucoseLineChart(
            readings: readings,
            unit: unit,
            low: lowThreshold,
            high: highThreshold,
            height: 180,
            showCurrentDot: false,
            thresholdLineMode: ThresholdLineMode.colored,
            showMidYLabel: true,
            episodes: episode != null ? [episode!] : const [],
            markers: markers,
            coloringMode: ChartColoringMode.byEpisode,
          ),
        ],
      ),
    );
  }
}

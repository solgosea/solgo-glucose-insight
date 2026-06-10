import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';

/// "Similar episodes" list section.
///
/// `themeColor` is the bar + peak color (rose for high, blue for low).
/// `rightCol` is optional; high page shows time + onset slope, low page omits.
class EpisodeSimilarSectionHeader extends StatelessWidget {
  final String text;
  const EpisodeSimilarSectionHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.textDim,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class EpisodeSimilarCardData {
  final String date; // e.g. "May 29"
  final String peakOrNadir; // numeric only, e.g. "11.2"
  final String unit; // typically "mmol/L"
  final String durationText; // e.g. "52 min" or "18 min - 02:45-03:03"
  final String? rightTime; // e.g. "07:32" (high page); null to omit
  final String? rightSlope; // e.g. "+0.31/min"

  const EpisodeSimilarCardData({
    required this.date,
    required this.peakOrNadir,
    required this.unit,
    required this.durationText,
    this.rightTime,
    this.rightSlope,
  });
}

class EpisodeSimilarCard extends StatelessWidget {
  final EpisodeSimilarCardData data;
  final Color themeColor;

  const EpisodeSimilarCard({
    super.key,
    required this.data,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.date,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textDim,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: themeColor,
                                height: 1.2,
                              ),
                              children: [
                                TextSpan(text: data.peakOrNadir),
                                TextSpan(
                                  text: ' ${data.unit}',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.durationText,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              color: AppColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (data.rightTime != null || data.rightSlope != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (data.rightTime != null)
                            Text(
                              data.rightTime!,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 10,
                                color: AppColors.textDim,
                              ),
                            ),
                          if (data.rightSlope != null) ...[
                            const SizedBox(height: 1),
                            Text(
                              data.rightSlope!,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 10,
                                color: AppColors.textDim,
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

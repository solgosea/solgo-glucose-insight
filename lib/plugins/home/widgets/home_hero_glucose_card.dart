import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/foundation/theme/app_text_styles.dart';
import '../models/home_glucose_summary_view_model.dart';
import 'home_trend_indicator.dart';
import 'home_value_pill.dart';

class HomeHeroGlucoseCard extends StatelessWidget {
  final HomeGlucoseSummaryViewModel glucose;

  const HomeHeroGlucoseCard({super.key, required this.glucose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            glucose.value,
            textAlign: TextAlign.center,
            style: AppTextStyles.heroValue.copyWith(
              shadows: [
                Shadow(
                  color: AppColors.green.withOpacity(0.35),
                  blurRadius: 20,
                ),
                Shadow(
                  color: AppColors.green.withOpacity(0.12),
                  blurRadius: 60,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            glucose.unit,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
              letterSpacing: 1.56,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeTrendIndicator(
                arrow: glucose.trendArrow,
                label: glucose.trendLabel,
              ),
              const SizedBox(width: 16),
              HomeValuePill(text: glucose.rateText),
              const SizedBox(width: 16),
              Text(
                glucose.timestampText,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: AppColors.textDim,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

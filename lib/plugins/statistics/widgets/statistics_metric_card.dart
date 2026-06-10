import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/statistics_view_model.dart';

class StatisticsMetricCard extends StatelessWidget {
  final StatisticsMetricCardViewModel viewModel;

  const StatisticsMetricCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppColors.textDim,
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: viewModel.valueColor,
              ),
              children: [
                TextSpan(text: viewModel.value),
                if (viewModel.suffix != null)
                  TextSpan(
                    text: viewModel.suffix,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            viewModel.unit,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: _deltaBackground(viewModel.deltaTone),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              viewModel.deltaText,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _deltaForeground(viewModel.deltaTone),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _deltaBackground(StatisticsDeltaTone tone) {
    return switch (tone) {
      StatisticsDeltaTone.up ||
      StatisticsDeltaTone.down => AppColors.green.withOpacity(0.10),
      StatisticsDeltaTone.flat => const Color(0x14C8D9CC),
    };
  }

  Color _deltaForeground(StatisticsDeltaTone tone) {
    return switch (tone) {
      StatisticsDeltaTone.up || StatisticsDeltaTone.down => AppColors.green,
      StatisticsDeltaTone.flat => AppColors.textSoft,
    };
  }
}

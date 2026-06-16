import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp_chart.dart';
import '../models/statistics_view_model.dart';
import 'statistics_section_card.dart';

class StatisticsAgpCard extends StatelessWidget {
  final StatisticsAgpViewModel viewModel;

  const StatisticsAgpCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticsSectionCard(
      title: viewModel.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AgpChart(
            slots: viewModel.slots,
            unit: viewModel.unit,
            low: viewModel.lowThreshold,
            high: viewModel.highThreshold,
            profile: const AgpCompactChartProfile(),
            height: 180,
            annotations: viewModel.annotations,
            showLegend: true,
            enableScrub: true,
          ),
          if (viewModel.guidanceText.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.amber.withValues(alpha: 0.28),
                ),
              ),
              child: Text(
                viewModel.guidanceText,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.amber,
                  height: 1.35,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            viewModel.note,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textSoft,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

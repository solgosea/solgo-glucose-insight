import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp_chart.dart';
import '../models/statistics_view_model.dart';
import 'statistics_section_card.dart';

class StatisticsAgpCard extends StatelessWidget {
  final StatisticsAgpViewModel viewModel;

  const StatisticsAgpCard({super.key, required this.viewModel});

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
            height: 180,
            annotations: viewModel.annotations,
          ),
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

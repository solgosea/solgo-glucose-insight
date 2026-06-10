import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/statistics_view_model.dart';

class StatisticsExtremeCell extends StatelessWidget {
  final StatisticsExtremeCellViewModel viewModel;

  const StatisticsExtremeCell({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: AppColors.textDim,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          viewModel.value,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          viewModel.subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

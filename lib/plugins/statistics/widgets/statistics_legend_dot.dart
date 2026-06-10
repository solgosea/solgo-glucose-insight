import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/statistics_view_model.dart';

class StatisticsLegendDot extends StatelessWidget {
  final StatisticsLegendItemViewModel viewModel;

  const StatisticsLegendDot({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          viewModel.text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

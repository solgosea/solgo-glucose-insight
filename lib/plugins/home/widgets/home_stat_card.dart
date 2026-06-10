import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/home_stat_card_view_model.dart';

class HomeStatCard extends StatelessWidget {
  final HomeStatCardViewModel viewModel;

  const HomeStatCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            viewModel.label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: 1.08,
              color: AppColors.textDim,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            viewModel.value,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1,
              color: viewModel.valueColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            viewModel.unit,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

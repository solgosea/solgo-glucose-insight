import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/history_view_model.dart';

class HistoryStatCard extends StatelessWidget {
  final HistoryStatCardViewModel viewModel;

  const HistoryStatCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            viewModel.label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textDim,
              letterSpacing: 0.54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.value,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: viewModel.color,
            ),
          ),
          if (viewModel.unit != null) ...[
            const SizedBox(height: 2),
            Text(
              viewModel.unit!,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

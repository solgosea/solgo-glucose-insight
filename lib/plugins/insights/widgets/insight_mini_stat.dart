import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/insights_view_model.dart';

class InsightMiniStat extends StatelessWidget {
  final InsightMiniStatViewModel viewModel;

  const InsightMiniStat({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.value,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _valueColor(viewModel.tone),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            viewModel.label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              color: AppColors.textDim,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Color _valueColor(InsightMiniStatTone tone) {
    return switch (tone) {
      InsightMiniStatTone.positive => AppColors.green,
      InsightMiniStatTone.warning => AppColors.rose,
      InsightMiniStatTone.neutral => AppColors.text,
    };
  }
}

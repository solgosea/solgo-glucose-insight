import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/insights_view_model.dart';

class InsightPatternCard extends StatelessWidget {
  final InsightPatternViewModel viewModel;

  const InsightPatternCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  _symbol(viewModel.icon),
                  style: TextStyle(
                    fontSize: 18,
                    color: _symbolColor(viewModel.icon),
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  viewModel.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            viewModel.body,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textSoft,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.footer,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textDim,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  String _symbol(InsightPatternIcon icon) {
    return switch (icon) {
      InsightPatternIcon.dawn => 'D',
      InsightPatternIcon.volatility => 'V',
      InsightPatternIcon.stability => 'S',
      InsightPatternIcon.weekday => 'W',
      InsightPatternIcon.generic => 'I',
    };
  }

  Color _symbolColor(InsightPatternIcon icon) {
    return switch (icon) {
      InsightPatternIcon.dawn => AppColors.amber,
      InsightPatternIcon.volatility => AppColors.rose,
      InsightPatternIcon.stability => AppColors.green,
      InsightPatternIcon.weekday => AppColors.blue,
      InsightPatternIcon.generic => AppColors.textSoft,
    };
  }
}

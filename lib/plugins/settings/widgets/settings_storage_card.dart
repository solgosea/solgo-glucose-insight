import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/settings_view_model.dart';

class SettingsStorageCard extends StatelessWidget {
  final SettingsStorageViewModel viewModel;

  const SettingsStorageCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  viewModel.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
              ),
              Text(
                viewModel.usedLabel,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: viewModel.fillRatio,
              minHeight: 6,
              backgroundColor: AppColors.green.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation(AppColors.green),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Label(viewModel.leftLabel),
              _Label(viewModel.coveredLabel),
              _Label(viewModel.maxLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.retentionSummary,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 9,
        color: AppColors.textDim,
      ),
    );
  }
}

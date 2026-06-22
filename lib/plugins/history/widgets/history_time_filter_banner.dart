import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../application/i18n/history_l10n.dart';
import '../models/history_view_model.dart';

class HistoryTimeFilterBanner extends StatelessWidget {
  final HistoryTimeFilterViewModel viewModel;
  final VoidCallback onClear;

  const HistoryTimeFilterBanner({
    super.key,
    required this.viewModel,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withOpacity(0.28)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_alt_rounded,
            color: AppColors.green,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              viewModel.label,
              style: const TextStyle(
                color: AppColors.textSoft,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.green,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              context.historyL10n.filterClear,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

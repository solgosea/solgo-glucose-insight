import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/history_view_model.dart';
import 'history_nav_button.dart';

class HistoryDateNav extends StatelessWidget {
  final HistoryDateNavViewModel viewModel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const HistoryDateNav({
    super.key,
    required this.viewModel,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          HistoryNavButton(
            icon: Icons.chevron_left_rounded,
            onTap: onPrevious,
            dim: false,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text(
                  viewModel.dateLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  viewModel.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color:
                        viewModel.isToday ? AppColors.green : AppColors.textDim,
                    letterSpacing: 0.8,
                    fontWeight:
                        viewModel.isToday ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          HistoryNavButton(
            icon: Icons.chevron_right_rounded,
            onTap: viewModel.isToday ? null : onNext,
            dim: viewModel.isToday,
          ),
        ],
      ),
    );
  }
}

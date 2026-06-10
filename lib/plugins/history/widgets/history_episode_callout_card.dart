import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/history_view_model.dart';

class HistoryEpisodeCalloutCard extends StatelessWidget {
  final HistoryEpisodeCalloutViewModel viewModel;
  final VoidCallback onTap;

  const HistoryEpisodeCalloutCard({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: viewModel.color.withOpacity(0.07),
          border: Border.all(color: viewModel.color.withOpacity(0.20)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1, right: 10),
              child: Icon(viewModel.icon, size: 16, color: viewModel.color),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSoft,
                        height: 1.6,
                      ),
                      children: [
                        TextSpan(
                          text: viewModel.label,
                          style: TextStyle(
                            color: viewModel.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: ' ${viewModel.summary}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    viewModel.actionLabel,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: viewModel.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/history_view_model.dart';

class HistoryEventRow extends StatelessWidget {
  final HistoryEventRowViewModel viewModel;
  final bool isLast;

  const HistoryEventRow({
    super.key,
    required this.viewModel,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : const Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                viewModel.time,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: AppColors.textDim,
                ),
              ),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: viewModel.iconBackground,
              border: Border.all(color: viewModel.iconBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(viewModel.icon, size: 16, color: viewModel.iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                if (viewModel.detail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    viewModel.detail,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
                const SizedBox(height: 3),
                Text(
                  viewModel.valueLabel,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: viewModel.valueColor,
                  ),
                ),
                if (viewModel.tag != null) ...[
                  const SizedBox(height: 4),
                  _EventTag(viewModel: viewModel.tag!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventTag extends StatelessWidget {
  final HistoryEventTagViewModel viewModel;

  const _EventTag({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: viewModel.color.withOpacity(0.08),
        border: Border.all(color: viewModel.color.withOpacity(0.30)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        viewModel.text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: viewModel.color,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/history_view_model.dart';

class HistorySummaryChip extends StatelessWidget {
  final HistorySummaryChipViewModel viewModel;

  const HistorySummaryChip({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: viewModel.color.withOpacity(0.08),
        border: Border.all(color: viewModel.color.withOpacity(0.30)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        viewModel.text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: viewModel.color,
        ),
      ),
    );
  }
}

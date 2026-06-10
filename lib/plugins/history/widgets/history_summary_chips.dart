import 'package:flutter/material.dart';
import '../models/history_view_model.dart';
import 'history_summary_chip.dart';

class HistorySummaryChips extends StatelessWidget {
  final List<HistorySummaryChipViewModel> chips;

  const HistorySummaryChips({super.key, required this.chips});

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            HistorySummaryChip(viewModel: chips[i]),
            if (i < chips.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

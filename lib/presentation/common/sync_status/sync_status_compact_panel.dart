import 'package:flutter/material.dart';

import 'sync_countdown_badge.dart';
import 'sync_status_chip.dart';
import 'sync_status_view_model.dart';

class SyncStatusCompactPanel extends StatelessWidget {
  final SyncStatusViewModel viewModel;

  const SyncStatusCompactPanel({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SyncStatusChip(viewModel: viewModel),
        const SizedBox(height: 5),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: SyncCountdownBadge(viewModel: viewModel),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'sync_runtime_limitation_notice.dart';
import 'sync_status_chip.dart';
import 'sync_status_meta_line.dart';
import 'sync_status_view_model.dart';

class SyncStatusCompactPanel extends StatelessWidget {
  final SyncStatusViewModel viewModel;

  const SyncStatusCompactPanel({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SyncStatusChip(viewModel: viewModel),
        if (viewModel.syncCountLabel.isNotEmpty ||
            viewModel.scheduleLabel.isNotEmpty ||
            viewModel.countdownLabel.isNotEmpty ||
            viewModel.nextSyncAt != null) ...[
          const SizedBox(height: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: SyncStatusMetaLine(
              viewModel: viewModel,
              alignment: MainAxisAlignment.end,
            ),
          ),
        ],
        if (viewModel.runtimeLimitationText.isNotEmpty) ...[
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 210),
            child: SyncRuntimeLimitationNotice(
              message: viewModel.runtimeLimitationText,
              foregroundLabel: viewModel.lastForegroundReconcileLabel,
            ),
          ),
        ],
      ],
    );
  }
}

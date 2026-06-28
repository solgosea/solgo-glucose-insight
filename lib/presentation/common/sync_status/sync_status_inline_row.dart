import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import 'sync_status_meta_line.dart';
import 'sync_status_view_model.dart';

class SyncStatusInlineRow extends StatefulWidget {
  final SyncStatusViewModel viewModel;
  final bool muted;
  final VoidCallback? onCountdownDue;

  const SyncStatusInlineRow({
    super.key,
    required this.viewModel,
    this.muted = false,
    this.onCountdownDue,
  });

  @override
  State<SyncStatusInlineRow> createState() => _SyncStatusInlineRowState();
}

class _SyncStatusInlineRowState extends State<SyncStatusInlineRow> {
  @override
  Widget build(BuildContext context) {
    final color = widget.muted ? AppColors.textDim : widget.viewModel.color;
    return Semantics(
      label: widget.viewModel.semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.viewModel.icon, color: color, size: 12),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  widget.viewModel.statusLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color:
                        widget.muted ? AppColors.textDim : AppColors.textSoft,
                  ),
                ),
              ),
            ],
          ),
          if (widget.viewModel.syncCountLabel.isNotEmpty ||
              widget.viewModel.scheduleLabel.isNotEmpty ||
              widget.viewModel.countdownLabel.isNotEmpty ||
              widget.viewModel.nextSyncAt != null) ...[
            const SizedBox(height: 5),
            SyncStatusMetaLine(
              viewModel: widget.viewModel,
              muted: widget.muted,
              onCountdownDue: widget.onCountdownDue,
            ),
          ],
        ],
      ),
    );
  }
}

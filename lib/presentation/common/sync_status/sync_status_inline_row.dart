import 'dart:async';

import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import 'sync_status_view_model.dart';

class SyncStatusInlineRow extends StatefulWidget {
  final SyncStatusViewModel viewModel;
  final bool muted;

  const SyncStatusInlineRow({
    super.key,
    required this.viewModel,
    this.muted = false,
  });

  @override
  State<SyncStatusInlineRow> createState() => _SyncStatusInlineRowState();
}

class _SyncStatusInlineRowState extends State<SyncStatusInlineRow> {
  Timer? _timer;
  late String _countdownLabel;

  @override
  void initState() {
    super.initState();
    _countdownLabel = _computeCountdown();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant SyncStatusInlineRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.nextSyncAt != widget.viewModel.nextSyncAt ||
        oldWidget.viewModel.countdownLabel != widget.viewModel.countdownLabel) {
      _countdownLabel = _computeCountdown();
      _syncTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.muted ? AppColors.textDim : widget.viewModel.color;
    return Semantics(
      label: widget.viewModel.semanticLabel,
      child: Row(
        children: [
          Icon(widget.viewModel.icon, color: color, size: 12),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              _primaryLabel(widget.viewModel.label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: widget.muted ? AppColors.textDim : AppColors.textSoft,
              ),
            ),
          ),
          if (_countdownLabel.isNotEmpty) ...[
            const SizedBox(width: 7),
            Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textDim.withValues(alpha: .72),
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                _countdownLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _syncTimer() {
    _timer?.cancel();
    if (widget.viewModel.nextSyncAt == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _computeCountdown();
      if (next == _countdownLabel) return;
      setState(() {
        _countdownLabel = next;
      });
    });
  }

  String _primaryLabel(String label) {
    final delimiter = label.indexOf(' - ');
    if (delimiter >= 0 && delimiter + 3 < label.length) {
      return label.substring(delimiter + 3);
    }
    return label;
  }

  String _computeCountdown() {
    final nextSyncAt = widget.viewModel.nextSyncAt;
    if (nextSyncAt == null) return widget.viewModel.countdownLabel;
    final remaining = nextSyncAt.difference(DateTime.now());
    if (remaining <= Duration.zero) return 'due';
    final prefix = widget.viewModel.scheduleEstimated ? 'est. next ' : 'next ';
    return '$prefix${_format(remaining)}';
  }

  String _format(Duration duration) {
    final seconds = duration.inSeconds;
    if (seconds < 60) return '${seconds}s';
    final minutes = duration.inMinutes;
    final remainderSeconds = seconds % 60;
    if (minutes < 60) {
      return '$minutes:${remainderSeconds.toString().padLeft(2, '0')}';
    }
    return '${duration.inHours}h';
  }
}

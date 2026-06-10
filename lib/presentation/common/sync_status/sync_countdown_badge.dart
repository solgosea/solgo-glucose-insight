import 'dart:async';

import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import 'sync_status_view_model.dart';

class SyncCountdownBadge extends StatefulWidget {
  final SyncStatusViewModel viewModel;

  const SyncCountdownBadge({super.key, required this.viewModel});

  @override
  State<SyncCountdownBadge> createState() => _SyncCountdownBadgeState();
}

class _SyncCountdownBadgeState extends State<SyncCountdownBadge> {
  Timer? _timer;
  late String _label;

  @override
  void initState() {
    super.initState();
    _label = _computeLabel();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant SyncCountdownBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.nextSyncAt != widget.viewModel.nextSyncAt ||
        oldWidget.viewModel.countdownLabel != widget.viewModel.countdownLabel) {
      _label = _computeLabel();
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
    if (!widget.viewModel.scheduleActive &&
        widget.viewModel.nextSyncAt == null &&
        widget.viewModel.countdownLabel.isEmpty) {
      return const SizedBox.shrink();
    }
    return Semantics(
      label: _label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bgCard2.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: widget.viewModel.color,
                size: 11,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  _label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSoft,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncTimer() {
    _timer?.cancel();
    if (widget.viewModel.nextSyncAt == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _computeLabel();
      if (next == _label) return;
      setState(() {
        _label = next;
      });
    });
  }

  String _computeLabel() {
    final nextSyncAt = widget.viewModel.nextSyncAt;
    if (nextSyncAt == null) return widget.viewModel.countdownLabel;
    final remaining = nextSyncAt.difference(DateTime.now());
    if (remaining <= Duration.zero) return 'Sync due';
    final prefix = widget.viewModel.scheduleEstimated ? 'Est. ' : '';
    return '${prefix}Next ${_format(remaining)}';
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

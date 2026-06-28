import 'dart:async';

import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import 'sync_status_view_model.dart';

class SyncStatusMetaLine extends StatefulWidget {
  final SyncStatusViewModel viewModel;
  final bool muted;
  final MainAxisAlignment alignment;
  final VoidCallback? onCountdownDue;

  const SyncStatusMetaLine({
    super.key,
    required this.viewModel,
    this.muted = false,
    this.alignment = MainAxisAlignment.start,
    this.onCountdownDue,
  });

  @override
  State<SyncStatusMetaLine> createState() => _SyncStatusMetaLineState();
}

class _SyncStatusMetaLineState extends State<SyncStatusMetaLine> {
  Timer? _timer;
  late String _countdownLabel;

  @override
  void initState() {
    super.initState();
    _countdownLabel = _computeCountdown();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant SyncStatusMetaLine oldWidget) {
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
    final hasNew = widget.viewModel.syncCountLabel.isNotEmpty;
    final hasNext = _countdownLabel.isNotEmpty;
    if (!hasNew && !hasNext) return const SizedBox.shrink();
    final color = widget.muted ? AppColors.textDim : widget.viewModel.color;
    return Semantics(
      label: [
        if (hasNew) widget.viewModel.syncCountLabel,
        if (hasNext) _countdownLabel,
      ].join(', '),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.alignment,
        children: [
          if (hasNew) ...[
            Icon(Icons.add_chart_rounded, color: color, size: 11),
            const SizedBox(width: 5),
            Flexible(
              child: _MetaText(
                text: widget.viewModel.syncCountLabel,
                color: widget.muted ? AppColors.textDim : AppColors.textSoft,
              ),
            ),
          ],
          if (hasNew && hasNext) ...[
            const SizedBox(width: 7),
            _Separator(muted: widget.muted),
            const SizedBox(width: 7),
          ],
          if (hasNext) ...[
            Icon(Icons.timer_outlined, color: color, size: 11),
            const SizedBox(width: 5),
            Flexible(
              child: _MetaText(
                text: _countdownLabel,
                color: widget.muted ? AppColors.textDim : AppColors.textSoft,
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

  String _computeCountdown() {
    final nextSyncAt = widget.viewModel.nextSyncAt;
    if (nextSyncAt == null) {
      return widget.viewModel.scheduleLabel.isNotEmpty
          ? widget.viewModel.scheduleLabel
          : widget.viewModel.countdownLabel;
    }
    final remaining = nextSyncAt.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      widget.onCountdownDue?.call();
      return widget.viewModel.countdownFormatter?.call(remaining) ??
          widget.viewModel.scheduleLabel;
    }
    return widget.viewModel.countdownFormatter?.call(remaining) ??
        widget.viewModel.scheduleLabel;
  }
}

class _MetaText extends StatelessWidget {
  final String text;
  final Color color;

  const _MetaText({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: color,
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  final bool muted;

  const _Separator({required this.muted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (muted ? AppColors.textDim : AppColors.textDim)
            .withValues(alpha: .72),
      ),
    );
  }
}

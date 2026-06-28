import 'dart:async';

import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import 'sync_status_view_model.dart';

class SyncStatusStrip extends StatefulWidget {
  final SyncStatusViewModel viewModel;
  final bool muted;
  final VoidCallback? onCountdownDue;

  const SyncStatusStrip({
    super.key,
    required this.viewModel,
    this.muted = false,
    this.onCountdownDue,
  });

  @override
  State<SyncStatusStrip> createState() => _SyncStatusStripState();
}

class _SyncStatusStripState extends State<SyncStatusStrip> {
  Timer? _timer;
  late String _countdownLabel;

  @override
  void initState() {
    super.initState();
    _countdownLabel = _computeCountdown();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant SyncStatusStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.nextSyncAt != widget.viewModel.nextSyncAt ||
        oldWidget.viewModel.scheduleLabel != widget.viewModel.scheduleLabel ||
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
    final detail = [
      if (widget.viewModel.syncCountLabel.isNotEmpty)
        widget.viewModel.syncCountLabel,
      if (_countdownLabel.isNotEmpty) _countdownLabel,
      if (widget.viewModel.intervalLabel.isNotEmpty)
        widget.viewModel.intervalLabel,
    ].join('  ·  ');
    return Semantics(
      label: widget.viewModel.semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bg.withValues(alpha: .30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: .50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              _StatusDot(color: color, pulsing: widget.viewModel.pulsing),
              const SizedBox(width: 8),
              Icon(widget.viewModel.icon, color: color, size: 12),
              const SizedBox(width: 5),
              _Label(
                text: widget.viewModel.statusLabel,
                color: color,
                size: 10,
                weight: FontWeight.w900,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Label(
                  text: detail,
                  color: AppColors.textDim,
                  align: TextAlign.right,
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
      final next = _computeCountdown();
      if (next == _countdownLabel) return;
      setState(() => _countdownLabel = next);
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
    }
    return widget.viewModel.countdownFormatter?.call(remaining) ??
        widget.viewModel.scheduleLabel;
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight weight;
  final TextAlign align;
  final double size;

  const _Label({
    required this.text,
    required this.color,
    this.weight = FontWeight.w700,
    this.align = TextAlign.left,
    this.size = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}

class _StatusDot extends StatefulWidget {
  final Color color;
  final bool pulsing;

  const _StatusDot({
    required this.color,
    required this.pulsing,
  });

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulsing) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pulsing == widget.pulsing) return;
    if (widget.pulsing) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = widget.pulsing ? .65 + _controller.value * .35 : 1.0;
        return Opacity(
          opacity: opacity,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

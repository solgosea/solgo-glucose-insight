import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import 'sync_status_view_model.dart';

class SyncStatusChip extends StatelessWidget {
  final SyncStatusViewModel viewModel;

  const SyncStatusChip({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: viewModel.semanticLabel,
      child: Tooltip(
        message: '${viewModel.title}\n${viewModel.detail}',
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: viewModel.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: viewModel.color.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: viewModel.color.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SyncDot(color: viewModel.color, pulsing: viewModel.pulsing),
                const SizedBox(width: 7),
                Icon(viewModel.icon, color: viewModel.color, size: 13),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    viewModel.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SyncDot extends StatefulWidget {
  final Color color;
  final bool pulsing;

  const _SyncDot({required this.color, required this.pulsing});

  @override
  State<_SyncDot> createState() => _SyncDotState();
}

class _SyncDotState extends State<_SyncDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulsing) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _SyncDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulsing && _controller.isAnimating) {
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
      builder: (_, __) {
        final opacity =
            widget.pulsing ? (0.35 + 0.65 * _controller.value) : 1.0;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(opacity),
          ),
        );
      },
    );
  }
}

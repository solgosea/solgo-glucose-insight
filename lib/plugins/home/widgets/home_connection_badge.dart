import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class HomeConnectionBadge extends StatelessWidget {
  final bool isConnected;
  final String text;

  const HomeConnectionBadge({
    super.key,
    required this.isConnected,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PulseDot(active: isConnected),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  final bool active;

  const _PulseDot({required this.active});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

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
        final color = widget.active ? AppColors.green : AppColors.rose;
        final opacity = widget.active ? (0.3 + 0.7 * _controller.value) : 1.0;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(opacity),
          ),
        );
      },
    );
  }
}

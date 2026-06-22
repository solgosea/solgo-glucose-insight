import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class NightscoutAnimatedValue extends StatelessWidget {
  final double value;
  final Widget Function(BuildContext context, double value) builder;

  const NightscoutAnimatedValue({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0, 1).toDouble()),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) => builder(context, animated),
    );
  }
}

class NightscoutUnavailableVisual extends StatelessWidget {
  final IconData icon;

  const NightscoutUnavailableVisual({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: StatusMonitorTheme.dim.withOpacity(.10),
              border: Border.all(
                color: StatusMonitorTheme.dim.withOpacity(.30),
                width: 1.2,
              ),
            ),
            child: Icon(icon, size: 18, color: StatusMonitorTheme.dim),
          ),
          const SizedBox(height: 8),
          Text(
            'not reported',
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

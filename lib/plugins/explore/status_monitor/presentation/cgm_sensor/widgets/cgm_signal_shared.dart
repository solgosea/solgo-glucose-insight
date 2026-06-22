import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class CgmAnimatedValue extends StatelessWidget {
  final double value;
  final bool animate;
  final Widget Function(BuildContext context, double value) builder;

  const CgmAnimatedValue({
    super.key,
    required this.value,
    required this.builder,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) return builder(context, value);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0, 1)),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) => builder(context, animated),
    );
  }
}

class CgmScaleAxis extends StatelessWidget {
  final List<String> labels;

  const CgmScaleAxis(this.labels, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final label in labels)
          Text(
            label,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),
      ],
    );
  }
}

class CgmZoneLegend extends StatelessWidget {
  final String low;
  final String mid;
  final String high;

  const CgmZoneLegend({
    super.key,
    required this.low,
    required this.mid,
    required this.high,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _zone(low, StatusMonitorTheme.green, Alignment.centerLeft),
        _zone(mid, StatusMonitorTheme.amber, Alignment.center),
        _zone(high, StatusMonitorTheme.rose, Alignment.centerRight),
      ],
    );
  }

  Widget _zone(String label, Color color, Alignment align) {
    return Expanded(
      child: Align(
        alignment: align,
        child: Text(
          label,
          style: StatusMonitorTheme.mono.copyWith(
            color: color.withOpacity(.85),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      ),
    );
  }
}

class CgmUnavailableVisual extends StatelessWidget {
  final IconData icon;

  const CgmUnavailableVisual({super.key, required this.icon});

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

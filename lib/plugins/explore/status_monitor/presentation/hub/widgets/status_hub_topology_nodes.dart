import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/status_hub_view_model.dart';
import 'status_hub_visuals.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubPositionedMapNode extends StatelessWidget {
  final Size size;
  final double left;
  final double top;
  final double width;
  final double height;
  final Widget child;

  const StatusHubPositionedMapNode({
    super.key,
    required this.size,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: size.width * left,
      top: size.height * top,
      width: size.width * width,
      height: size.height * height,
      child: child,
    );
  }
}

class StatusHubCenterNode extends StatelessWidget {
  final StatusHubNodeViewModel node;

  const StatusHubCenterNode({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(node.state);
    return InkWell(
      onTap: node.route == null ? null : () => context.push(node.route!),
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Outer concentric ring (HTML .hub-ring2).
          Positioned.fill(
            child: CustomPaint(
              painter: _HubRingPainter(color: color.withOpacity(.22)),
            ),
          ),
          // Hub body: radial gradient fill + glow.
          FractionallySizedBox(
            widthFactor: 92 / 110,
            heightFactor: 88 / 110,
            child: Container(
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment(0, -0.24),
                  radius: .9,
                  colors: [Color(0xFF1D4A34), Color(0xFF0F211A)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(.7), width: 1.6),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(.32),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      node.label,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: const Color(0xFFEAFFF2),
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        letterSpacing: -.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LOCAL HUB',
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.green,
                        fontSize: 8.6,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubRingPainter extends CustomPainter {
  final Color color;

  const _HubRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * .49;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(covariant _HubRingPainter oldDelegate) =>
      oldDelegate.color != color;
}

class StatusHubOuterNode extends StatelessWidget {
  final StatusHubNodeViewModel node;
  final bool muted;

  const StatusHubOuterNode({
    super.key,
    required this.node,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(node.state);
    return InkWell(
      onTap: node.route == null ? null : () => context.push(node.route!),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121F18).withOpacity(.96),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(muted ? .34 : .5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Status dot, top-left (HTML n-dot).
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 6.8,
                height: 6.8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      node.label,
                      textAlign: TextAlign.center,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: const Color(0xFFEDF7EF),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      node.stateLabel.toLowerCase(),
                      style: StatusMonitorTheme.mono.copyWith(
                        color: color,
                        fontSize: 8.4,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

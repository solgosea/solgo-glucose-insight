import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/cgm_sensor_signal_view_model.dart';
import 'cgm_signal_panel.dart';
import 'cgm_signal_shared.dart';

class CgmFlatPeriodPanel extends StatelessWidget {
  static const _icon = Icons.horizontal_rule_rounded;
  static const _watchFraction = 0.5;

  final CgmSensorSignalViewModel signal;

  const CgmFlatPeriodPanel({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    if (!signal.available) {
      return CgmSignalPanel(
        signal: signal,
        icon: _icon,
        visual: const CgmUnavailableVisual(icon: _icon),
      );
    }

    final crossed = signal.progress >= _watchFraction;
    final fillColor = crossed ? color : StatusMonitorTheme.green;
    return CgmSignalPanel(
      signal: signal,
      icon: _icon,
      visual: LayoutBuilder(
        builder: (context, constraints) {
          final tight = constraints.maxHeight < 84;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                signal.valueLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StatusMonitorTheme.mono.copyWith(
                  color: fillColor,
                  fontSize: tight ? 20 : 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: tight ? 8 : 14),
              SizedBox(
                height: tight ? 22 : 26,
                child: CgmAnimatedValue(
                  value: signal.progress,
                  builder: (context, animated) => LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final markerX = (width * animated).clamp(0.0, width);
                      final watchX = width * _watchFraction;
                      final trackInset = tight ? 8.0 : 9.0;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: trackInset,
                            bottom: trackInset,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: Container(
                                color: StatusMonitorTheme.dim.withOpacity(.16),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: trackInset,
                            bottom: trackInset,
                            width: markerX,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: Container(color: fillColor),
                            ),
                          ),
                          Positioned(
                            left: watchX - 1,
                            top: 2,
                            bottom: 2,
                            child: Container(
                              width: 2,
                              decoration: BoxDecoration(
                                color: StatusMonitorTheme.amber.withOpacity(.9),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                          Positioned(
                            left: markerX.clamp(5, width - 5) - 5,
                            top: 0,
                            child: CustomPaint(
                              size: const Size(10, 7),
                              painter: _CaretPainter(fillColor),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: tight ? 5 : 7),
              const CgmScaleAxis(['0m', '30m', '60m']),
            ],
          );
        },
      ),
    );
  }
}

class _CaretPainter extends CustomPainter {
  final Color color;

  const _CaretPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CaretPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

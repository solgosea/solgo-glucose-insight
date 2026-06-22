import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/xdrip_signal_view_model.dart';
import 'xdrip_signal_panel.dart';
import 'xdrip_signal_shared.dart';

class XdripLatencyGauge extends StatelessWidget {
  static const _icon = Icons.network_check_rounded;

  static const _watchFraction = 0.5;

  final XdripSignalViewModel signal;

  const XdripLatencyGauge({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    if (!signal.available) {
      return XdripSignalPanel(
        signal: signal,
        icon: _icon,
        visual: const XdripUnavailableVisual(icon: _icon),
      );
    }
    return XdripSignalPanel(
      signal: signal,
      icon: _icon,
      visual: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            signal.valueLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 28,
            child: XdripAnimatedValue(
              value: signal.progress,
              builder: (context, animated) => LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final x = (width * animated).clamp(0.0, width);
                  final watchX = width * _watchFraction;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  StatusMonitorTheme.rose.withOpacity(.72),
                                  StatusMonitorTheme.amber.withOpacity(.76),
                                  StatusMonitorTheme.green.withOpacity(.82),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: watchX - 1,
                        top: 3,
                        bottom: 3,
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            color: StatusMonitorTheme.bg.withOpacity(.55),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      Positioned(
                        left: x.clamp(7, width - 7) - 7,
                        top: 4,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: StatusMonitorTheme.bg,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(.36),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 7),
          const XdripScaleAxis(['30s+', '15s', '0s']),
        ],
      ),
    );
  }
}

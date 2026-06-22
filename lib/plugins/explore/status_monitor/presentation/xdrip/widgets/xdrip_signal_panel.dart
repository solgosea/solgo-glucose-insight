import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/xdrip_signal_view_model.dart';

class XdripSignalPanel extends StatelessWidget {
  final XdripSignalViewModel signal;
  final Widget visual;
  final IconData icon;

  const XdripSignalPanel({
    super.key,
    required this.signal,
    required this.visual,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card,
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: color.withOpacity(signal.available ? .34 : .18)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(signal.available ? .10 : .04),
            StatusMonitorTheme.card,
            StatusMonitorTheme.card2.withOpacity(.66),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  signal.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _SignalDot(level: signal.level),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: visual),
          const SizedBox(height: 8),
          Text(
            signal.sourceLabel.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            signal.detailLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10.5,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalDot extends StatelessWidget {
  final StatusLevel level;

  const _SignalDot({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.36),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../domain/floating/status_floating_component_payload.dart';
import '../../domain/floating/status_floating_payload.dart';
import '../../domain/status_level.dart';
import '../styles/status_monitor_theme.dart';

class StatusMonitorFloatingPreview extends StatelessWidget {
  final StatusFloatingPayload payload;

  const StatusMonitorFloatingPreview({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(payload.level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xEE121C18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.58)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.drag_indicator_rounded, size: 15, color: color),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                for (final component in payload.components)
                  _ComponentChip(component: component),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentChip extends StatelessWidget {
  final StatusFloatingComponentPayload component;

  const _ComponentChip({required this.component});

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(component.level);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          component.glyph,
          style: StatusMonitorTheme.mono.copyWith(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${component.label} ${component.scoreLabel}',
          style: StatusMonitorTheme.inter.copyWith(
            color: StatusMonitorTheme.text,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

Color _levelColor(StatusLevel level) {
  return switch (level) {
    StatusLevel.healthy => StatusMonitorTheme.green,
    StatusLevel.watch => StatusMonitorTheme.amber,
    StatusLevel.issue => StatusMonitorTheme.rose,
    StatusLevel.unknown => StatusMonitorTheme.dim,
  };
}

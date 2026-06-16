import 'package:flutter/material.dart';

import '../../domain/glance_snapshot.dart';
import '../styles/glance_theme.dart';

class FloatingGlancePreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final bool collapsed;

  const FloatingGlancePreview({
    super.key,
    required this.snapshot,
    this.collapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = GlanceTheme.stateColor(snapshot.rangeState);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: collapsed ? 12 : 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xEE17211D),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.55)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.drag_indicator_rounded, size: 15, color: color),
          const SizedBox(width: 6),
          if (collapsed)
            Text(
              snapshot.trendArrow,
              style: GlanceTheme.mono.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            )
          else ...[
            Text(
              '${snapshot.valueLabel} ${snapshot.unitLabel}',
              style: GlanceTheme.mono.copyWith(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '${snapshot.trendArrow} ${snapshot.deltaLabel}',
              style: GlanceTheme.mono.copyWith(
                color: GlanceTheme.soft,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../domain/glance_snapshot.dart';
import '../styles/glance_theme.dart';

class PersistentNotificationPreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final bool expanded;
  final bool privateMode;

  const PersistentNotificationPreview({
    super.key,
    required this.snapshot,
    this.expanded = false,
    this.privateMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = GlanceTheme.stateColor(snapshot.rangeState);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2420),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GlanceTheme.border),
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
                  color: GlanceTheme.green.withOpacity(.13),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: GlanceTheme.green,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  privateMode ? 'Glucose data available' : 'Solgo Insight',
                  style: GlanceTheme.mono.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                snapshot.freshness.label,
                style: GlanceTheme.mono.copyWith(
                  fontSize: 10.5,
                  color: GlanceTheme.dim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            privateMode
                ? 'Unlock to view current glucose'
                : '${snapshot.valueLabel} ${snapshot.unitLabel}  '
                    '${snapshot.trendArrow}  ${snapshot.deltaLabel}',
            style: GlanceTheme.mono.copyWith(
              fontSize: privateMode ? 13 : 20,
              fontWeight: FontWeight.w900,
              color: privateMode ? GlanceTheme.soft : color,
            ),
          ),
          if (expanded && !privateMode) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _Kv(label: 'Trend', value: '${snapshot.trendArrow} Flat'),
                const SizedBox(width: 12),
                _Kv(label: 'Source', value: snapshot.sourceLabel),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Action(label: 'Open'),
                const SizedBox(width: 8),
                _Action(label: 'Data source'),
                const SizedBox(width: 8),
                _Action(label: 'Settings'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Kv extends StatelessWidget {
  final String label;
  final String value;

  const _Kv({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GlanceTheme.mono.copyWith(
                color: GlanceTheme.dim,
                fontSize: 9.5,
              )),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GlanceTheme.mono.copyWith(
                color: GlanceTheme.soft,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final String label;

  const _Action({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: GlanceTheme.card2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: GlanceTheme.border),
        ),
        child: Text(label,
            style: GlanceTheme.mono.copyWith(
              color: GlanceTheme.soft,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            )),
      ),
    );
  }
}

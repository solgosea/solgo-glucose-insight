// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../application/i18n/glance_l10n.dart';
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
    final l10n = context.glanceL10n;
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
                  privateMode
                      ? l10n.glancePrivateDataAvailable
                      : 'SolgoInsight',
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
                ? l10n.glancePrivateUnlockToView
                : '${snapshot.valueLabel} ${snapshot.unitLabel}  '
                    '${snapshot.tir24h.compactLabel}',
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
                _Kv(
                  label: l10n.glanceNotificationPreviewTrend,
                  value:
                      '${snapshot.trendArrow} ${l10n.glanceNotificationPreviewFlat}',
                ),
                const SizedBox(width: 12),
                _Kv(
                  label: l10n.glanceNotificationPreviewTir24h,
                  value: snapshot.tir24h.percentLabel,
                ),
                const SizedBox(width: 12),
                _Kv(
                  label: l10n.glanceNotificationPreviewSource,
                  value: snapshot.sourceLabel,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Action(label: l10n.glanceNotificationPreviewOpen),
                const SizedBox(width: 8),
                _Action(label: l10n.glanceNotificationPreviewDataSource),
                const SizedBox(width: 8),
                _Action(label: l10n.glanceNotificationPreviewSettings),
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

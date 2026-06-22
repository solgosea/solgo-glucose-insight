import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_aaps_detail_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/aaps/aaps_detail_data.dart';
import '../../../../domain/status_level.dart';
import '../../../../l10n/generated/status_monitor_localizations.dart';
import '../../../styles/status_monitor_theme.dart';
import '../aaps_detail_section_frame.dart';

class AapsIobCobProfilePanel extends StatelessWidget {
  final AapsDetailData data;

  const AapsIobCobProfilePanel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return AapsDetailSectionFrame(
      title: l10n.pageAapsIobCobProfile,
      trailing: l10n.pageContextVisibility,
      child: AapsGlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContextMatrixRow(
              title: 'IOB',
              card: data.iobContext,
              body: data.iobContext.body,
              l10n: l10n,
            ),
            _ContextMatrixRow(
              title: 'COB',
              card: data.cobContext,
              body: data.cobContext.body,
              l10n: l10n,
            ),
            _ContextMatrixRow(
              title: l10n.pageProfileTempTarget,
              card: data.profileContext,
              body: data.profileContext.body,
              l10n: l10n,
              last: true,
            ),
            const SizedBox(height: 12),
            _SourcePills(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _ContextMatrixRow extends StatelessWidget {
  final AapsContextCardData card;
  final String title;
  final String body;
  final bool last;
  final StatusMonitorLocalizations l10n;

  const _ContextMatrixRow({
    required this.card,
    required this.title,
    required this.body,
    required this.l10n,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(
                bottom: BorderSide(color: StatusMonitorTheme.line),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  statusMonitorAapsBody(body, l10n),
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AapsBadge(label: _badgeFor(card), level: card.level),
        ],
      ),
    );
  }

  String _badgeFor(AapsContextCardData card) {
    return switch (card.level) {
      StatusLevel.healthy => l10n.pageStatusHealthy,
      StatusLevel.watch => l10n.pageStatusWatch,
      StatusLevel.issue => l10n.pageStatusIssue,
      StatusLevel.unknown => l10n.pageStatusUnknown,
    };
  }
}

class _SourcePills extends StatelessWidget {
  final StatusMonitorLocalizations l10n;

  const _SourcePills({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Pill(l10n.pageSourceNightscoutDeviceStatus),
        _Pill(l10n.pageNoLocalAapsRestAssumed),
        _Pill(l10n.pageMissingFieldsReduceConfidence),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.025),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.line),
      ),
      child: Text(
        label,
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

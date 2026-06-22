import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_aaps_detail_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/aaps/aaps_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../aaps_detail_section_frame.dart';

class AapsPumpLoopContextCards extends StatelessWidget {
  final AapsDetailData data;

  const AapsPumpLoopContextCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return AapsDetailSectionFrame(
      title: l10n.pagePumpLoopContext,
      trailing: l10n.pageFactualChecksOnly,
      child: _InlineTwoColumn(
        children: [
          AapsContextCard(card: data.loopContext),
          AapsContextCard(card: data.pumpContext),
        ],
      ),
    );
  }
}

class _InlineTwoColumn extends StatelessWidget {
  final List<Widget> children;

  const _InlineTwoColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 520 ? 2 : 1;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(growable: false),
        );
      },
    );
  }
}

class AapsContextCard extends StatelessWidget {
  final AapsContextCardData card;

  const AapsContextCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final color = StatusMonitorTheme.colorFor(card.level);
    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(14),
      decoration: StatusMonitorTheme.glassCardDecoration(level: card.level),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statusMonitorAapsLabel(card.label, l10n).toUpperCase(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            statusMonitorAapsValue(card.value, l10n),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 27,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusMonitorAapsBody(card.body, l10n),
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          StatusGaugeBar(value: card.fraction, level: card.level),
        ],
      ),
    );
  }
}

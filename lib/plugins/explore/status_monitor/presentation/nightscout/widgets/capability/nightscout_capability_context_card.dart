import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/nightscout/nightscout_capability_context.dart';
import '../../../../domain/nightscout/nightscout_detail_data.dart';
import '../../../../domain/status_level.dart';
import '../../../styles/status_monitor_theme.dart';
import '../nightscout_detail_section_frame.dart';

class NightscoutCapabilityContextCard extends StatelessWidget {
  final NightscoutDetailData data;

  const NightscoutCapabilityContextCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final rows = data.capabilityContext
        .map(
          (capability) => _ContextRowModel.fromCapability(
            capability,
            fallbackCopy: l10n.pageObservedNightscoutApiProbes,
          ),
        )
        .toList(growable: false);
    return NightscoutDetailSectionFrame(
      title: l10n.pageCapabilityContext,
      trailing: l10n.pageWhatSiteExposes,
      child: _ContextPanel(rows: rows),
    );
  }
}

class _ContextPanel extends StatelessWidget {
  final List<_ContextRowModel> rows;

  const _ContextPanel({required this.rows});

  @override
  Widget build(BuildContext context) {
    return NightscoutGlassPanel(
      child: Column(
        children:
            rows.map((row) => _ContextRow(model: row)).toList(growable: false),
      ),
    );
  }
}

class _ContextRow extends StatelessWidget {
  final _ContextRowModel model;

  const _ContextRow({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(
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
                  model.title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  model.copy,
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
          NightscoutBadge(label: model.badge, level: model.level),
        ],
      ),
    );
  }
}

class _ContextRowModel {
  final String title;
  final String copy;
  final String badge;
  final StatusLevel level;

  const _ContextRowModel({
    required this.title,
    required this.copy,
    required this.badge,
    required this.level,
  });

  factory _ContextRowModel.fromCapability(
    NightscoutCapabilityContext context, {
    required String fallbackCopy,
  }) {
    return _ContextRowModel(
      title: context.label,
      copy: context.note ?? fallbackCopy,
      badge: context.valueLabel,
      level: context.level,
    );
  }
}

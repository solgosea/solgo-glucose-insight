import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/xdrip/xdrip_context_signal.dart';
import '../../../../domain/xdrip/xdrip_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../xdrip_detail_section_frame.dart';

class XdripContextPanel extends StatelessWidget {
  final XdripDetailData data;

  const XdripContextPanel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final rows = [
      ...data.contextSignals.map(
        (signal) => _ContextRowModel.fromSignal(
          signal,
          fallbackCopy: l10n.pageObservedActiveXdripSource,
        ),
      ),
      _ContextRowModel(
        title: l10n.pageUploadLatency,
        copy: l10n.pageUploadLatencyUnavailable,
        badge: l10n.pageStatusUnknown,
        level: StatusLevel.unknown,
      ),
    ];
    return XdripDetailSectionFrame(
      title: l10n.pageSensorCollectorContext,
      trailing: l10n.pageOptionalChecks,
      child: _ContextRows(rows: rows),
    );
  }
}

class _ContextRows extends StatelessWidget {
  final List<_ContextRowModel> rows;

  const _ContextRows({required this.rows});

  @override
  Widget build(BuildContext context) {
    return XdripGlassPanel(
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
    final color = StatusMonitorTheme.colorFor(model.level);
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color.withOpacity(.28)),
            ),
            child: Text(
              model.badge,
              style: StatusMonitorTheme.mono.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
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

  factory _ContextRowModel.fromSignal(
    XdripContextSignal signal, {
    required String fallbackCopy,
  }) {
    return _ContextRowModel(
      title: signal.label,
      copy: signal.note ?? fallbackCopy,
      badge: signal.valueLabel,
      level: signal.level,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_level.dart';
import '../../../l10n/generated/status_monitor_localizations.dart';
import '../../styles/status_monitor_theme.dart';
import 'cgm_sensor_detail_section_frame.dart';
import 'cgm_sensor_signal_grid.dart';
import 'flat_periods/cgm_flat_period_card.dart';
import 'jumps/cgm_sudden_jump_card.dart';
import 'quality/cgm_sensor_quality_timeline_card.dart';
import 'variability/cgm_variability_noise_card.dart';

class CgmSensorDetailBody extends StatelessWidget {
  final ComponentHealth component;

  const CgmSensorDetailBody({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final data = component.detailData;
    if (data is! CgmSensorDetailData) {
      return CgmSensorSignalGrid(component: component);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CgmSensorQualityTimelineCard(data: data),
              CgmVariabilityNoiseCard(data: data),
            ],
          ),
        ),
        CgmSuddenJumpCard(data: data),
        CgmFlatPeriodCard(data: data),
        _ContextSection(data: data),
        const _NoticeCard(),
      ],
    );
  }
}

class _ContextSection extends StatelessWidget {
  final CgmSensorDetailData data;

  const _ContextSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final missingSession = data.contextLabel.toLowerCase().contains('not');
    final l10n = context.statusMonitorL10n;
    return CgmSensorDetailSectionFrame(
      title: l10n.pageSensorContext,
      trailing: l10n.pageOptionalSourceData,
      child: _ContextPanel(
        rows: [
          _ContextRowModel(
            title: l10n.pageSessionAgeRemaining,
            copy: data.contextLabel,
            badge: missingSession
                ? l10n.pageStatusUnknown
                : l10n.pageStatusAvailable,
            level: missingSession ? StatusLevel.unknown : StatusLevel.healthy,
          ),
          _ContextRowModel(
            title: l10n.pageCollectorContext,
            copy: l10n.pageCollectorHealthyCopy,
            badge: l10n.pageStatusHealthy,
            level: StatusLevel.healthy,
          ),
          _ContextRowModel(
            title: l10n.pageReadingSource,
            copy: l10n.pageReadingSourceCopy(data.sourceModeLabel),
            badge: _shortSourceBadge(data.sourceModeLabel, l10n),
            level: StatusLevel.healthy,
          ),
        ],
      ),
    );
  }

  String _shortSourceBadge(
    String source,
    StatusMonitorLocalizations l10n,
  ) {
    final lower = source.toLowerCase();
    if (lower.contains('no live')) return l10n.pageStatusHistory;
    if (lower.contains('history')) return l10n.pageStatusMixed;
    if (lower.contains('nightscout')) return 'Nightscout';
    if (lower.contains('xdrip')) return 'xDrip+';
    if (source.trim().isEmpty) return l10n.pageStatusUnknown;
    return l10n.pageStatusLive;
  }
}

class _ContextPanel extends StatelessWidget {
  final List<_ContextRowModel> rows;

  const _ContextPanel({required this.rows});

  @override
  Widget build(BuildContext context) {
    return CgmSensorGlassPanel(
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
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.06),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.20)),
      ),
      child: Text(
        l10n.pageSensorNotice,
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 11.5,
          height: 1.45,
        ),
      ),
    );
  }
}

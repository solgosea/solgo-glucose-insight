import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_aaps_detail_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/aaps/aaps_detail_data.dart';
import '../../../../domain/aaps/aaps_evidence_matrix_row.dart';
import '../../../styles/status_monitor_theme.dart';
import '../aaps_detail_section_frame.dart';

class AapsEvidenceMatrixCard extends StatelessWidget {
  final AapsDetailData data;

  const AapsEvidenceMatrixCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return AapsDetailSectionFrame(
      title: l10n.pageEvidenceMatrix,
      trailing: l10n.pageLatestProbe,
      child: AapsGlassPanel(
        child: _Matrix(rows: data.evidenceMatrix),
      ),
    );
  }
}

class _Matrix extends StatelessWidget {
  final List<AapsEvidenceMatrixRow> rows;

  const _Matrix({required this.rows});

  @override
  Widget build(BuildContext context) {
    final matrixRows = <Widget>[];
    for (var i = 0; i < rows.length; i += 2) {
      final rowItems = rows.skip(i).take(2).toList(growable: false);
      matrixRows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var j = 0; j < rowItems.length; j++) ...[
              Expanded(child: _MatrixTile(row: rowItems[j])),
              if (j != rowItems.length - 1) const SizedBox(width: 10),
            ],
          ],
        ),
      );
      if (i + 2 < rows.length) matrixRows.add(const SizedBox(height: 10));
    }
    return Column(children: matrixRows);
  }
}

class _MatrixTile extends StatelessWidget {
  final AapsEvidenceMatrixRow row;

  const _MatrixTile({required this.row});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Container(
      constraints: const BoxConstraints(minHeight: 124),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card2.withOpacity(.62),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: StatusMonitorTheme.colorFor(row.level).withOpacity(.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  statusMonitorAapsLabel(row.title, l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AapsBadge(
                label: statusMonitorAapsValue(row.badge, l10n),
                level: row.level,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            statusMonitorAapsBody(row.copy, l10n),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10.8,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

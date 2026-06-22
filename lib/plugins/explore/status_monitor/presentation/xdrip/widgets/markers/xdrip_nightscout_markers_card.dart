import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/nightscout_markers/nightscout_marker.dart';
import '../../../../domain/nightscout_markers/nightscout_marker_confidence.dart';
import '../../../../domain/xdrip/xdrip_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../xdrip_detail_section_frame.dart';

class XdripNightscoutMarkersCard extends StatelessWidget {
  final XdripDetailData data;

  const XdripNightscoutMarkersCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final markers = data.markerAnalysis.markers;
    final l10n = context.statusMonitorL10n;
    return XdripDetailSectionFrame(
      title: l10n.pageDetectedNightscoutMarkers,
      trailing: l10n.pageMarkerEvidenceNote,
      child: XdripGlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MarkerSummaryCard(data: data),
            if (markers.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...markers.map(
                (marker) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _MarkerRow(marker: marker),
                ),
              ),
            ],
            const SizedBox(height: 2),
            if (data.markerAnalysis.notice.trim().isNotEmpty)
              Text(
                data.markerAnalysis.notice,
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MarkerSummaryCard extends StatelessWidget {
  final XdripDetailData data;

  const _MarkerSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final summary = data.markerAnalysis.summary;
    final color = _confidenceColor(summary.confidence);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: color.withOpacity(.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.title,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            summary.body,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkerRow extends StatelessWidget {
  final NightscoutMarker marker;

  const _MarkerRow({required this.marker});

  @override
  Widget build(BuildContext context) {
    final color = _confidenceColor(marker.confidence);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF08110D).withOpacity(.28),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white.withOpacity(.045)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marker.label,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  marker.note,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color.withOpacity(.28)),
            ),
            child: Text(
              marker.value,
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

Color _confidenceColor(NightscoutMarkerConfidence confidence) {
  switch (confidence) {
    case NightscoutMarkerConfidence.high:
    case NightscoutMarkerConfidence.medium:
      return StatusMonitorTheme.green;
    case NightscoutMarkerConfidence.low:
      return StatusMonitorTheme.amber;
    case NightscoutMarkerConfidence.notExplicit:
      return StatusMonitorTheme.muted;
  }
}

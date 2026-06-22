import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/detail/status_endpoint_probe.dart';
import '../../../../domain/detail/status_probe_message_sanitizer.dart';
import '../../../../domain/nightscout/nightscout_detail_data.dart';
import '../../../../l10n/generated/status_monitor_localizations.dart';
import '../../../styles/status_monitor_theme.dart';
import '../nightscout_detail_section_frame.dart';

class NightscoutEndpointMatrixCard extends StatelessWidget {
  final NightscoutDetailData data;

  const NightscoutEndpointMatrixCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return NightscoutDetailSectionFrame(
      title: l10n.pageEndpointMatrix,
      trailing: l10n.pageLatestProbe,
      child: _EndpointMatrix(data: data),
    );
  }
}

class _EndpointMatrix extends StatelessWidget {
  final NightscoutDetailData data;

  const _EndpointMatrix({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.endpointMatrix.endpoints.isEmpty) return const SizedBox.shrink();
    return NightscoutGlassPanel(
      child: _EndpointRows(
        endpoints: data.endpointMatrix.endpoints,
      ),
    );
  }
}

class _EndpointRows extends StatelessWidget {
  final List<StatusEndpointProbe> endpoints;

  const _EndpointRows({required this.endpoints});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final rows = <Widget>[];
    for (var i = 0; i < endpoints.length; i += 3) {
      final rowEndpoints = endpoints.skip(i).take(3).toList(growable: false);
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var j = 0; j < rowEndpoints.length; j++) ...[
              Expanded(
                child: _EndpointTile(
                  endpoint: rowEndpoints[j],
                  l10n: l10n,
                ),
              ),
              if (j != rowEndpoints.length - 1) const SizedBox(width: 10),
            ],
          ],
        ),
      );
      if (i + 3 < endpoints.length) rows.add(const SizedBox(height: 10));
    }
    return Column(children: rows);
  }
}

class _EndpointTile extends StatelessWidget {
  final StatusEndpointProbe endpoint;
  final StatusMonitorLocalizations l10n;

  const _EndpointTile({required this.endpoint, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 118),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card2.withOpacity(.62),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: StatusMonitorTheme.colorFor(endpoint.level).withOpacity(.20),
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
                  endpoint.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              NightscoutBadge(
                  label: endpoint.level.label, level: endpoint.level),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _statusLineFor(endpoint, l10n),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.colorFor(endpoint.level),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _messageFor(endpoint, l10n),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLineFor(
    StatusEndpointProbe endpoint,
    StatusMonitorLocalizations strings,
  ) {
    final status = endpoint.statusCode == null
        ? endpoint.reachable
            ? strings.pageReachable
            : strings.pageNotReachable
        : '${endpoint.statusCode}';
    final elapsed = '${endpoint.elapsed.inMilliseconds}ms';
    return '$status | $elapsed';
  }

  String _messageFor(
    StatusEndpointProbe endpoint,
    StatusMonitorLocalizations strings,
  ) {
    final message = const StatusProbeMessageSanitizer()
        .cleanDisplayMessage(endpoint.message);
    if (message != null && message.isNotEmpty) {
      return message;
    }
    return strings.pageCheckedRecently;
  }
}

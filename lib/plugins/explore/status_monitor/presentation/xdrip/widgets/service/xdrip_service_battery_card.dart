import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/detail/status_signal_summary.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/xdrip/xdrip_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../xdrip_detail_section_frame.dart';

class XdripServiceBatteryCard extends StatelessWidget {
  final XdripDetailData data;

  const XdripServiceBatteryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final battery = _signal(data, 'uploader_battery');
    final serviceLevel = data.localService?.level ?? StatusLevel.unknown;
    final serviceValue = data.localService == null
        ? 'Unknown'
        : data.localService!.reachable
            ? '${data.localService!.elapsed.inMilliseconds}ms'
            : 'Offline';
    final l10n = context.statusMonitorL10n;
    return XdripDetailSectionFrame(
      title: l10n.pageServiceAndBattery,
      trailing: l10n.pageLatestProbe,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final two = constraints.maxWidth >= 320;
          final cards = [
            _MiniMetricCard(
              label: l10n.pageLocalService,
              value: serviceValue,
              body: data.localService?.message ?? l10n.pageXdripLocalModeNote,
              level: serviceLevel,
              fraction: serviceLevel == StatusLevel.healthy ? .86 : .25,
            ),
            _MiniMetricCard(
              label: l10n.pageUploaderBattery,
              value: battery?.valueLabel ?? l10n.pageStatusUnknown,
              body: battery?.note ?? l10n.pageBatteryPebbleNote,
              level: battery?.level ?? StatusLevel.unknown,
              fraction: _percentFraction(battery?.valueLabel),
            ),
          ];
          if (!two) {
            return Column(
              children: [
                cards[0],
                const SizedBox(height: 10),
                cards[1],
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 10),
              Expanded(child: cards[1]),
            ],
          );
        },
      ),
    );
  }

  StatusSignalSummary? _signal(XdripDetailData data, String id) {
    for (final signal in data.signals) {
      if (signal.id == id) return signal;
    }
    return null;
  }

  double _percentFraction(String? label) {
    if (label == null) return 0;
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(label);
    final value = double.tryParse(match?.group(1) ?? '');
    if (value == null) return 0;
    return (value / 100).clamp(0, 1);
  }
}

class _MiniMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String body;
  final StatusLevel level;
  final double fraction;

  const _MiniMetricCard({
    required this.label,
    required this.value,
    required this.body,
    required this.level,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return XdripGlassPanel(
      minHeight: 142,
      level: level,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 28,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          StatusGaugeBar(value: fraction, level: level),
        ],
      ),
    );
  }
}

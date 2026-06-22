import 'package:flutter/material.dart';

import '../mappers/nightscout_signal_mapper.dart';
import '../models/nightscout_signal_kind.dart';
import '../models/nightscout_signal_view_model.dart';
import 'nightscout_device_status_panel.dart';
import 'nightscout_reachability_panel.dart';
import 'nightscout_response_time_gauge.dart';

class NightscoutSignalGrid extends StatelessWidget {
  final dynamic component;
  final NightscoutSignalMapper mapper;

  const NightscoutSignalGrid({
    super.key,
    required this.component,
    this.mapper = const NightscoutSignalMapper(),
  });

  @override
  Widget build(BuildContext context) {
    final signals = mapper.map(component.metrics);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 390;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: signals.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: compact ? 1 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: compact ? 1.68 : .78,
            ),
            itemBuilder: (_, index) => _panel(signals[index]),
          );
        },
      ),
    );
  }

  Widget _panel(NightscoutSignalViewModel signal) {
    return switch (signal.kind) {
      NightscoutSignalKind.reachability =>
        NightscoutReachabilityPanel(signal: signal),
      NightscoutSignalKind.responseTime =>
        NightscoutResponseTimeGauge(signal: signal),
      NightscoutSignalKind.deviceStatus =>
        NightscoutDeviceStatusPanel(signal: signal),
    };
  }
}

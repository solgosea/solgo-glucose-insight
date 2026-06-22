import 'package:flutter/material.dart';

import '../mappers/xdrip_signal_mapper.dart';
import '../models/xdrip_signal_kind.dart';
import '../models/xdrip_signal_view_model.dart';
import 'xdrip_battery_panel.dart';
import 'xdrip_completeness_ring.dart';
import 'xdrip_freshness_gauge.dart';
import 'xdrip_latency_gauge.dart';

class XdripSignalGrid extends StatelessWidget {
  final dynamic component;
  final XdripSignalMapper mapper;

  const XdripSignalGrid({
    super.key,
    required this.component,
    this.mapper = const XdripSignalMapper(),
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
              crossAxisCount: compact ? 1 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: compact ? 1.68 : 1.02,
            ),
            itemBuilder: (_, index) => _panel(signals[index]),
          );
        },
      ),
    );
  }

  Widget _panel(XdripSignalViewModel signal) {
    return switch (signal.kind) {
      XdripSignalKind.freshness => XdripFreshnessGauge(signal: signal),
      XdripSignalKind.completeness => XdripCompletenessRing(signal: signal),
      XdripSignalKind.latency => XdripLatencyGauge(signal: signal),
      XdripSignalKind.battery => XdripBatteryPanel(signal: signal),
    };
  }
}

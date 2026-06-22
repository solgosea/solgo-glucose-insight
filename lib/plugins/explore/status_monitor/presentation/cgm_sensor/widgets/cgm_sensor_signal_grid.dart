import 'package:flutter/material.dart';

import '../mappers/cgm_sensor_signal_mapper.dart';
import '../models/cgm_sensor_signal_kind.dart';
import '../models/cgm_sensor_signal_view_model.dart';
import 'cgm_flat_period_panel.dart';
import 'cgm_jump_signal_panel.dart';
import 'cgm_session_gauge.dart';
import 'cgm_variability_gauge.dart';

class CgmSensorSignalGrid extends StatelessWidget {
  final dynamic component;
  final CgmSensorSignalMapper mapper;

  const CgmSensorSignalGrid({
    super.key,
    required this.component,
    this.mapper = const CgmSensorSignalMapper(),
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
              childAspectRatio: compact ? 1.45 : .94,
            ),
            itemBuilder: (_, index) => _panel(signals[index]),
          );
        },
      ),
    );
  }

  Widget _panel(CgmSensorSignalViewModel signal) {
    return switch (signal.kind) {
      CgmSensorSignalKind.session => CgmSessionGauge(signal: signal),
      CgmSensorSignalKind.variability => CgmVariabilityGauge(signal: signal),
      CgmSensorSignalKind.jumps => CgmJumpSignalPanel(signal: signal),
      CgmSensorSignalKind.flatPeriod => CgmFlatPeriodPanel(signal: signal),
    };
  }
}

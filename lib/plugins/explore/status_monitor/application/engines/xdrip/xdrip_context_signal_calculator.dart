import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/status_level.dart';
import '../../../domain/xdrip/xdrip_context_signal.dart';

class XdripContextSignalCalculator {
  const XdripContextSignalCalculator();

  List<XdripContextSignal> calculate(StatusAnalysisContext context) {
    final xdrip = context.evidence.xdripLocalEvidence;
    return [
      XdripContextSignal(
        label: 'Sensor context',
        valueLabel: xdrip.sensorContext == null ? 'Unknown' : 'Available',
        level: xdrip.sensorContext == null
            ? StatusLevel.unknown
            : StatusLevel.healthy,
        note: xdrip.sensorContext == null
            ? 'Unavailable context lowers confidence, not health.'
            : null,
      ),
      XdripContextSignal(
        label: 'Collector context',
        valueLabel: xdrip.collectorContext == null ? 'Unknown' : 'Available',
        level: xdrip.collectorContext == null
            ? StatusLevel.unknown
            : StatusLevel.healthy,
      ),
    ];
  }
}

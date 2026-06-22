import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/cgm_sensor/cgm_sudden_jump_event.dart';
import '../../../domain/status_level.dart';

class CgmSuddenJumpCalculator {
  const CgmSuddenJumpCalculator();

  List<CgmSuddenJumpEvent> calculate(StatusAnalysisContext context) {
    final readings = [...context.evidence.selection.cgmHistoryReadings.readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final events = <CgmSuddenJumpEvent>[];
    for (var i = 1; i < readings.length; i++) {
      final previous = readings[i - 1];
      final current = readings[i];
      final gap = current.timestamp.difference(previous.timestamp);
      if (gap > const Duration(minutes: 10)) continue;
      final delta = (current.value - previous.value).abs();
      if (delta <= 5.0) continue;
      events.add(
        CgmSuddenJumpEvent(
          at: current.timestamp,
          deltaMmol: delta,
          level: delta > 7.0 ? StatusLevel.issue : StatusLevel.watch,
        ),
      );
    }
    return events;
  }
}

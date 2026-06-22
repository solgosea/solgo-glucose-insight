import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/cgm_sensor/cgm_flat_period.dart';
import '../../../domain/status_level.dart';

class CgmFlatPeriodCalculator {
  const CgmFlatPeriodCalculator();

  List<CgmFlatPeriod> calculate(StatusAnalysisContext context) {
    final readings = [...context.evidence.selection.cgmHistoryReadings.readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    if (readings.length < 2) return const [];
    final periods = <CgmFlatPeriod>[];
    DateTime? start;
    DateTime? end;
    for (var i = 1; i < readings.length; i++) {
      final previous = readings[i - 1];
      final current = readings[i];
      final flat = (current.value - previous.value).abs() < 0.1 &&
          current.timestamp.difference(previous.timestamp) <=
              const Duration(minutes: 10);
      if (flat) {
        start ??= previous.timestamp;
        end = current.timestamp;
      } else {
        _addIfLongEnough(periods, start, end);
        start = null;
        end = null;
      }
    }
    _addIfLongEnough(periods, start, end);
    return periods;
  }

  void _addIfLongEnough(
    List<CgmFlatPeriod> periods,
    DateTime? start,
    DateTime? end,
  ) {
    if (start == null || end == null) return;
    final duration = end.difference(start);
    if (duration < const Duration(minutes: 30)) return;
    periods.add(
      CgmFlatPeriod(
        start: start,
        end: end,
        duration: duration,
        level: duration > const Duration(minutes: 60)
            ? StatusLevel.issue
            : StatusLevel.watch,
      ),
    );
  }
}

import '../../../domain/analysis/analysis_context.dart';
import '../../../domain/analysis/analysis_module_code.dart';
import '../../../domain/analysis/daily_glucose_summary.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../../../engine/statistics/tir_calculator.dart';
import 'analysis_module.dart';

class DailySummaryModule implements AnalysisModule<List<DailyGlucoseSummary>> {
  const DailySummaryModule();

  @override
  AnalysisModuleCode get code => AnalysisModuleCode.dayView;

  @override
  Future<List<DailyGlucoseSummary>> run(AnalysisContext context) async {
    final byDay = <DateTime, List<GlucoseReading>>{};
    for (final r in context.readings) {
      final day = DateTime(
        r.timestamp.year,
        r.timestamp.month,
        r.timestamp.day,
      );
      byDay.putIfAbsent(day, () => []).add(r);
    }

    final result = <DailyGlucoseSummary>[];
    for (final entry in byDay.entries) {
      final rows = [...entry.value]
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      if (rows.length < 12) continue;
      final tir = TirCalculator.calculate(
        rows,
        low: context.settings.lowThreshold,
        high: context.settings.highThreshold,
        veryHigh: context.settings.veryHighThreshold,
      );
      result.add(
        DailyGlucoseSummary(
          day: entry.key,
          readingCount: rows.length,
          tir: tir.tir,
          tar: tir.tar,
          tbr: tir.tbr,
          mean: tir.mean,
          cv: tir.cv,
          minValue: _min(rows),
          maxValue: _max(rows),
          firstReadingValue: rows.first.value,
        ),
      );
    }
    result.sort((a, b) => a.day.compareTo(b.day));
    return result;
  }

  double _min(List<GlucoseReading> readings) =>
      readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);

  double _max(List<GlucoseReading> readings) =>
      readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);
}

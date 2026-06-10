import '../../../domain/analysis/analysis_context.dart';
import '../../../domain/analysis/analysis_module_code.dart';
import '../../../domain/analysis/period_glucose_summary.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../../../engine/statistics/tir_calculator.dart';
import 'analysis_module.dart';

class PeriodSummaryModule
    implements AnalysisModule<List<PeriodGlucoseSummary>> {
  const PeriodSummaryModule();

  @override
  AnalysisModuleCode get code => AnalysisModuleCode.period;

  @override
  Future<List<PeriodGlucoseSummary>> run(AnalysisContext context) async {
    final periods = <_PeriodDefinition>[
      const _PeriodDefinition('night', 'Night', 0, 6),
      const _PeriodDefinition('morning', 'Morning', 6, 12),
      const _PeriodDefinition('afternoon', 'Afternoon', 12, 18),
      const _PeriodDefinition('evening', 'Evening', 18, 24),
    ];

    return periods.map((p) {
      final rows =
          context.readings.where((r) => p.contains(r.timestamp.hour)).toList();
      if (rows.isEmpty) {
        return PeriodGlucoseSummary(
          periodKey: p.key,
          label: p.label,
          readingCount: 0,
          tir: 0,
          tar: 0,
          tbr: 0,
          mean: 0,
          cv: 0,
          minValue: 0,
          maxValue: 0,
        );
      }
      final tir = TirCalculator.calculate(
        rows,
        low: context.settings.lowThreshold,
        high: context.settings.highThreshold,
        veryHigh: context.settings.veryHighThreshold,
      );
      return PeriodGlucoseSummary(
        periodKey: p.key,
        label: p.label,
        readingCount: rows.length,
        tir: tir.tir,
        tar: tir.tar,
        tbr: tir.tbr,
        mean: tir.mean,
        cv: tir.cv,
        minValue: _min(rows),
        maxValue: _max(rows),
      );
    }).toList();
  }

  double _min(List<GlucoseReading> readings) =>
      readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);

  double _max(List<GlucoseReading> readings) =>
      readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);
}

class _PeriodDefinition {
  final String key;
  final String label;
  final int startHour;
  final int endHour;

  const _PeriodDefinition(this.key, this.label, this.startHour, this.endHour);

  bool contains(int hour) => hour >= startHour && hour < endHour;
}

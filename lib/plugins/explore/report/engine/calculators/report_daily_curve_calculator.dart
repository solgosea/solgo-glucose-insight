import '../../../../../domain/entities/app_settings.dart';
import '../../../../../domain/entities/glucose_reading.dart';
import '../../../../../engine/statistics/tir_calculator.dart';
import '../../domain/sections/report_daily_curves_section.dart';
import 'report_coverage_calculator.dart';

class ReportDailyCurveCalculator {
  const ReportDailyCurveCalculator();

  ReportDailyCurvesSection calculate(
    List<GlucoseReading> readings,
    AppSettings settings,
    DateTime anchor,
  ) {
    final result = <ReportDailyCurve>[];
    for (var offset = 0; offset < 14; offset++) {
      final day = DateTime(anchor.year, anchor.month, anchor.day)
          .subtract(Duration(days: offset));
      final start = day;
      final end = start.add(const Duration(days: 1));
      final rows = readings
          .where(
              (r) => !r.timestamp.isBefore(start) && r.timestamp.isBefore(end))
          .toList();
      final sparse = rows.length < 24;
      final tir = sparse
          ? null
          : TirCalculator.calculate(
              rows,
              low: settings.lowThreshold,
              high: settings.highThreshold,
              veryHigh: settings.veryHighThreshold,
              veryLow: ReportCoverageCalculator.veryLowMmol,
            ).tir;
      result.add(
        ReportDailyCurve(
          day: day,
          tir: tir,
          readings: rows,
          sparse: sparse,
        ),
      );
    }
    return ReportDailyCurvesSection(curves: result);
  }
}

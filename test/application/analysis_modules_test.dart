import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/modules/daily_summary_module.dart';
import 'package:smart_xdrip/application/analysis/modules/period_summary_module.dart';
import 'package:smart_xdrip/domain/analysis/analysis_context.dart';
import 'package:smart_xdrip/domain/analysis/analysis_window.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

void main() {
  test('daily and period modules produce summaries from readings', () async {
    final start = DateTime(2026, 6, 3);
    final readings = List.generate(
      24,
      (i) => GlucoseReading(
        timestamp: start.add(Duration(minutes: i * 30)),
        value: 6.0 + (i % 4) * 0.2,
      ),
    );
    final context = AnalysisContext(
      window: AnalysisWindow(
        start: start,
        end: start.add(const Duration(days: 1)),
        label: '1d',
      ),
      settings: const AppSettings(),
      readings: readings,
    );

    final daily = await const DailySummaryModule().run(context);
    final periods = await const PeriodSummaryModule().run(context);

    expect(daily, hasLength(1));
    expect(daily.first.readingCount, 24);
    expect(periods, hasLength(4));
    expect(periods.first.periodKey, 'night');
  });
}

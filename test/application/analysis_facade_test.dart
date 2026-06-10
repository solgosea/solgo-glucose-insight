import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_module_code.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/analysis/daily_glucose_summary.dart';
import 'package:smart_xdrip/domain/analysis/period_glucose_summary.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';
import 'package:smart_xdrip/domain/insight/narrative_insight.dart';

void main() {
  tearDown(() => AnalysisSessionStore.instance.clear());

  test('facade exposes current snapshot and generated insights', () {
    final now = DateTime(2026, 6, 3, 12);
    AnalysisSessionStore.instance.update(
      AnalysisRefreshResult(
        snapshot: AnalysisSnapshot(
          generatedAt: now,
          windowStart: now.subtract(const Duration(days: 7)),
          windowEnd: now,
          readings: [
            for (var i = 23; i >= 0; i--)
              GlucoseReading(
                timestamp: now.subtract(Duration(hours: i)),
                value: 6.0 + (i % 3),
              ),
          ],
          dailySummaries: [
            for (var i = 0; i < 7; i++)
              DailyGlucoseSummary(
                day: DateTime(2026, 6, 3).subtract(Duration(days: i)),
                readingCount: 288,
                tir: 82,
                tar: 14,
                tbr: 4,
                mean: 6.4,
                cv: 28,
                minValue: 3.8,
                maxValue: 10.6,
                firstReadingValue: 5.9,
              ),
          ],
          periodSummaries: const [
            PeriodGlucoseSummary(
              periodKey: 'morning',
              label: 'Morning',
              readingCount: 72,
              tir: 80,
              tar: 15,
              tbr: 5,
              mean: 6.7,
              cv: 31,
              minValue: 3.8,
              maxValue: 10.6,
            ),
          ],
          events: [
            GlucoseEvent(
              type: GlucoseEventType.highEpisode,
              time: now.subtract(const Duration(hours: 2)),
              value: 10.8,
            ),
          ],
        ),
        insights: [
          NarrativeInsight(
            id: 'i1',
            module: AnalysisModuleCode.insights,
            slot: InsightSlotCode.dailyBrief,
            type: InsightTypeCode.dailyCompleteDay,
            templateCode: 'daily',
            templateVersion: 1,
            title: 'Daily',
            body: 'Daily body',
            facts: const {},
            generatedAt: now,
          ),
        ],
      ),
    );

    final facade = AnalysisFacade.current();

    expect(facade.hasSnapshot, isTrue);
    expect(facade.compactDailySummary(), contains('TIR 82%'));
    expect(facade.averageTirForLastDays(7, now: now), 82);
    expect(facade.averageMeanForLastDays(7, now: now), 6.4);
    expect(facade.averageCvForLastDays(7, now: now), 28);
    expect(facade.latestReading?.value, 6.0);
    expect(facade.readingsForLastHours(4, now: now), hasLength(5));
    expect(facade.readingsForLastHours(4), hasLength(5));
    expect(
      facade.tirForReadings(facade.readingsForLastHours(4, now: now)),
      isNotNull,
    );
    expect(
      facade.hourlyTirForReadings(facade.readingsForLastHours(24)),
      hasLength(24),
    );
    expect(facade.dailyTirMapForLastDays(7, now: now), hasLength(7));
    expect(facade.eventsForLastDays(1, now: now), hasLength(1));
    expect(facade.insightBodiesFor(AnalysisModuleCode.insights), [
      'Daily body',
    ]);
  });

  test('facade TIR uses target range from current settings', () {
    final store = AnalysisSessionStore.instance;
    store.updateSettings(
      const AppSettings(
        lowThreshold: 5.0,
        highThreshold: 8.0,
        veryHighThreshold: 12.0,
      ),
    );
    final facade = AnalysisFacade(store);
    final now = DateTime(2026, 6, 3, 12);
    final readings = [
      GlucoseReading(timestamp: now, value: 4.5),
      GlucoseReading(
        timestamp: now.add(const Duration(minutes: 5)),
        value: 6.0,
      ),
      GlucoseReading(
        timestamp: now.add(const Duration(minutes: 10)),
        value: 8.5,
      ),
    ];

    final result = facade.tirForReadings(readings);

    expect(result.tbr, closeTo(33.333, 0.01));
    expect(result.tir, closeTo(33.333, 0.01));
    expect(result.tar, closeTo(33.333, 0.01));
  });

  test('facade event detection uses high and low thresholds from settings', () {
    final store = AnalysisSessionStore.instance;
    store.updateSettings(
      const AppSettings(
        lowThreshold: 4.5,
        highThreshold: 8.0,
        veryHighThreshold: 12.0,
      ),
    );
    final facade = AnalysisFacade(store);
    final start = DateTime(2026, 6, 3, 9);
    final readings = List.generate(
      8,
      (index) => GlucoseReading(
        timestamp: start.add(Duration(minutes: index * 5)),
        value: index < 2 ? 7.2 : 8.4,
      ),
    );

    final events = facade.detectEventsForReadings(readings);

    expect(
      events.any((event) => event.type == GlucoseEventType.highEpisode),
      isTrue,
    );
  });
}

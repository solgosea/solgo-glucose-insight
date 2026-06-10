import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_engine.dart';
import 'package:smart_xdrip/domain/analysis/analysis_window.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../_support/test_database.dart';

void main() {
  test('AnalysisEngine reads and writes only the requested subject', () async {
    final database = TestDatabase.create();
    addTearDown(database.close);
    final now = DateTime(2026, 6, 6, 12);
    const childSubject = 'external_child_1';

    await database.upsertMany([
      for (var i = 0; i < 36; i++)
        GlucoseReading(
          timestamp: now.subtract(Duration(minutes: (36 - i) * 5)),
          value: 6,
        ),
    ]);
    await database.upsertMany([
      for (var i = 0; i < 36; i++)
        GlucoseReading(
          timestamp: now.subtract(Duration(minutes: (36 - i) * 5)),
          value: 9,
        ),
    ], subjectId: childSubject);

    final snapshot = await AnalysisEngine(database: database).runWindow(
      settings: const AppSettings(),
      subjectId: childSubject,
      window: AnalysisWindow(
        start: now.subtract(const Duration(hours: 4)),
        end: now.add(const Duration(minutes: 1)),
        label: 'test',
      ),
    );

    expect(snapshot.readings, isNotEmpty);
    expect(snapshot.readings.every((reading) => reading.value == 9), isTrue);
    expect(
      await database.latestDailyStats(subjectId: childSubject),
      isNotEmpty,
    );
    expect(await database.latestDailyStats(), isEmpty);
  });
}

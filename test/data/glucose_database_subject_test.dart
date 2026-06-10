import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/data/local/glucose_tables.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_etl/canonical_glucose_candidate.dart';
import 'package:smart_xdrip/domain/glucose_etl/raw_glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../_support/test_database.dart';

void main() {
  test(
    'default self subject keeps existing glucose data flow working',
    () async {
      final db = TestDatabase.create();
      final now = DateTime(2026, 6, 5, 12);

      await db.upsertMany([
        GlucoseReading(timestamp: now, value: 6.1),
      ], source: 'nightscout');

      expect(await db.count(), 1);
      expect((await db.latest())?.value, 6.1);
      expect(
        await db.range(
          now.subtract(const Duration(minutes: 1)),
          now.add(const Duration(minutes: 1)),
        ),
        hasLength(1),
      );

      await db.close();
    },
  );

  test('readings with the same timestamp are isolated by subject id', () async {
    final db = TestDatabase.create();
    final now = DateTime(2026, 6, 5, 12);
    const childSubject = 'external_child_1';

    await db.upsertMany([GlucoseReading(timestamp: now, value: 6.1)]);
    await db.upsertMany([
      GlucoseReading(timestamp: now, value: 4.2),
    ], subjectId: childSubject);

    final self = await db.latest();
    final child = await db.latest(subjectId: childSubject);

    expect(self?.value, 6.1);
    expect(child?.value, 4.2);
    expect(await db.count(), 1);
    expect(await db.count(subjectId: childSubject), 1);

    await db.close();
  });

  test('raw and canonical ETL data are isolated by subject id', () async {
    final db = TestDatabase.create();
    final now = DateTime(2026, 6, 5, 12);
    final bucket = now.millisecondsSinceEpoch;
    const childSubject = 'external_child_1';

    await db.upsertRawReadings([
      RawGlucoseReading(
        id: 'raw_1',
        source: 'nightscout',
        sourceRecordId: 'record_1',
        timestamp: now,
        bucketMs: bucket,
        value: 6.1,
        receivedAt: now,
      ),
    ]);
    await db.upsertRawReadings([
      RawGlucoseReading(
        id: 'raw_1',
        source: 'nightscout',
        sourceRecordId: 'record_1',
        timestamp: now,
        bucketMs: bucket,
        value: 4.2,
        receivedAt: now,
      ),
    ], subjectId: childSubject);

    expect(await db.rawReadingsByBuckets({bucket}), hasLength(1));
    expect(
      (await db.rawReadingsByBuckets({
        bucket,
      }, subjectId: childSubject)).single.value,
      4.2,
    );

    await db.upsertCanonicalReadings([
      CanonicalGlucoseCandidate(
        bucketMs: bucket,
        timestamp: now,
        value: 6.1,
        source: 'nightscout',
        rawId: 'raw_1',
        sourcePriority: 10,
        updatedAt: now,
      ),
    ]);
    await db.upsertCanonicalReadings([
      CanonicalGlucoseCandidate(
        bucketMs: bucket,
        timestamp: now,
        value: 4.2,
        source: 'nightscout',
        rawId: 'raw_1',
        sourcePriority: 10,
        updatedAt: now,
      ),
    ], subjectId: childSubject);

    expect((await db.latest())?.value, 6.1);
    expect((await db.latest(subjectId: childSubject))?.value, 4.2);

    await db.close();
  });

  test('source sync state is scoped by subject id', () async {
    final db = TestDatabase.create();
    const childSubject = 'external_child_1';

    await db.recordSourceSuccess('nightscout', cursor: 'self-cursor');
    await db.recordSourceSuccess(
      'nightscout',
      cursor: 'child-cursor',
      subjectId: childSubject,
    );

    expect((await db.getSourceState('nightscout'))?.lastCursor, 'self-cursor');
    expect(
      (await db.getSourceState(
        'nightscout',
        subjectId: childSubject,
      ))?.lastCursor,
      'child-cursor',
    );

    expect(GlucoseSubject.selfId, 'self');

    await db.close();
  });

  test(
    'v5 database migration keeps existing data under self subject',
    () async {
      sqfliteFfiInit();
      final dir = await Directory.systemTemp.createTemp('smart_xdrip_subject_');
      final path = '${dir.path}/legacy.db';
      final legacy = await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 5,
          onCreate: (db, _) async {
            await _createLegacyV5Schema(db);
            await db.insert(GlucoseTables.readings, {
              'ts_ms': DateTime(2026, 6, 5, 12).millisecondsSinceEpoch,
              'value': 6.7,
              'rate_per_min': null,
              'source': 'nightscout',
              'source_priority': 10,
              'raw_id': 'raw_legacy',
              'updated_at_ms': DateTime(2026, 6, 5, 12).millisecondsSinceEpoch,
            });
            await db.insert(GlucoseTables.sourceState, {
              'source_key': 'nightscout',
              'last_success_at_ms':
                  DateTime(2026, 6, 5, 12).millisecondsSinceEpoch,
              'last_attempt_at_ms':
                  DateTime(2026, 6, 5, 12).millisecondsSinceEpoch,
              'last_cursor': 'legacy-cursor',
              'last_error': null,
              'updated_at_ms': DateTime(2026, 6, 5, 12).millisecondsSinceEpoch,
            });
          },
        ),
      );
      await legacy.close();

      final migrated = GlucoseDatabase(
        databaseFactoryOverride: databaseFactoryFfi,
        databasePathOverride: path,
      );

      expect((await migrated.latest())?.value, 6.7);
      expect(
        (await migrated.getSourceState('nightscout'))?.lastCursor,
        'legacy-cursor',
      );

      await migrated.upsertMany([
        GlucoseReading(timestamp: DateTime(2026, 6, 5, 12), value: 4.4),
      ], subjectId: 'external_child_1');
      expect((await migrated.latest())?.value, 6.7);
      expect(
        (await migrated.latest(subjectId: 'external_child_1'))?.value,
        4.4,
      );

      await migrated.close();
      await dir.delete(recursive: true);
    },
  );
}

Future<void> _createLegacyV5Schema(Database db) async {
  await db.execute('''
    CREATE TABLE ${GlucoseTables.readings} (
      ts_ms INTEGER PRIMARY KEY,
      value REAL NOT NULL,
      rate_per_min REAL,
      source TEXT,
      source_priority INTEGER DEFAULT 100,
      raw_id TEXT,
      updated_at_ms INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.rawReadings} (
      id TEXT PRIMARY KEY,
      source TEXT NOT NULL,
      source_record_id TEXT NOT NULL,
      ts_ms INTEGER NOT NULL,
      bucket_ms INTEGER NOT NULL,
      value REAL NOT NULL,
      rate_per_min REAL,
      received_at_ms INTEGER NOT NULL,
      payload_json TEXT,
      UNIQUE(source, source_record_id),
      UNIQUE(source, ts_ms, value)
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.events} (
      id TEXT PRIMARY KEY,
      event_type TEXT NOT NULL,
      start_ts_ms INTEGER NOT NULL,
      end_ts_ms INTEGER,
      value REAL NOT NULL,
      peak_or_nadir REAL,
      rate_per_min REAL,
      low_severity TEXT,
      is_nocturnal INTEGER NOT NULL DEFAULT 0,
      area_out_of_range REAL,
      created_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.dailyStats} (
      day TEXT PRIMARY KEY,
      reading_count INTEGER NOT NULL,
      tir REAL NOT NULL,
      tar REAL NOT NULL,
      tbr REAL NOT NULL,
      mean REAL NOT NULL,
      cv REAL NOT NULL,
      min_value REAL NOT NULL,
      max_value REAL NOT NULL,
      first_reading_value REAL NOT NULL,
      updated_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.periodStats} (
      period_key TEXT PRIMARY KEY,
      label TEXT NOT NULL,
      reading_count INTEGER NOT NULL,
      tir REAL NOT NULL,
      tar REAL NOT NULL,
      tbr REAL NOT NULL,
      mean REAL NOT NULL,
      cv REAL NOT NULL,
      min_value REAL NOT NULL,
      max_value REAL NOT NULL,
      updated_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.agpSnapshots} (
      snapshot_key TEXT PRIMARY KEY,
      window_start_ms INTEGER NOT NULL,
      window_end_ms INTEGER NOT NULL,
      payload_json TEXT NOT NULL,
      updated_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.patternSnapshots} (
      snapshot_key TEXT PRIMARY KEY,
      module_code TEXT NOT NULL,
      window_start_ms INTEGER NOT NULL,
      window_end_ms INTEGER NOT NULL,
      payload_json TEXT NOT NULL,
      updated_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.generatedInsights} (
      id TEXT PRIMARY KEY,
      module_code TEXT NOT NULL,
      slot_code TEXT NOT NULL,
      insight_type TEXT NOT NULL,
      template_code TEXT NOT NULL,
      template_version INTEGER NOT NULL,
      title TEXT,
      eyebrow TEXT,
      body TEXT NOT NULL,
      footer TEXT,
      facts_json TEXT NOT NULL,
      generated_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.sourceState} (
      source_key TEXT PRIMARY KEY,
      last_success_at_ms INTEGER,
      last_attempt_at_ms INTEGER,
      last_cursor TEXT,
      last_error TEXT,
      updated_at_ms INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE ${GlucoseTables.glucoseGaps} (
      id TEXT PRIMARY KEY,
      start_ts_ms INTEGER NOT NULL,
      end_ts_ms INTEGER NOT NULL,
      duration_minutes INTEGER NOT NULL,
      source TEXT,
      created_at_ms INTEGER NOT NULL
    )
  ''');
}

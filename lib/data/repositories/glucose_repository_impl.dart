import 'dart:async';

import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_result.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_orchestrator.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/entities/glucose_event.dart';
import '../../domain/entities/analysis_results.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_glucose_repository.dart';
import '../../engine/statistics/tir_calculator.dart';
import '../../engine/detection/episode_detector.dart';
import '../local/glucose_database.dart';

/// Coordinates between data sources (xDrip+ HTTP/Nightscout), the local
/// SQLite cache, and the analysis engine.
///
/// Strategy:
///   - Engine and UI always read from local DB (fast, offline-tolerant)
///   - sync() pulls from upstream HTTP source and writes to DB
class GlucoseRepositoryImpl implements IGlucoseRepository {
  final GlucoseDatabase _db;
  final GlucoseSourceSyncOrchestrator _syncOrchestrator;
  AppSettings _settings = const AppSettings();

  final _latestController = StreamController<GlucoseReading>.broadcast();

  GlucoseRepositoryImpl({
    required GlucoseDatabase db,
    GlucoseSyncCoordinator? syncCoordinator,
    GlucoseSyncTargetRegistry? syncTargetRegistry,
  })  : _db = db,
        _syncOrchestrator = GlucoseSourceSyncOrchestrator(
          database: db,
          syncCoordinator:
              syncCoordinator ?? GlucoseSyncCoordinator(database: db),
          targetRegistry: syncTargetRegistry,
        );

  /// Switch to the configured upstream source. Called when settings change.
  Future<void> applySettings(AppSettings settings) async {
    _settings = settings;
  }

  @override
  Stream<GlucoseReading> get latestStream => _latestController.stream;

  @override
  Future<GlucoseReading?> latest() async {
    return _db.latest();
  }

  @override
  Future<List<GlucoseReading>> lastHours(int hours) async {
    final now = DateTime.now();
    return _db.range(now.subtract(Duration(hours: hours)), now);
  }

  @override
  Future<List<GlucoseReading>> lastDays(int days) async {
    final now = DateTime.now();
    return _db.range(now.subtract(Duration(days: days)), now);
  }

  @override
  Future<List<GlucoseReading>> forDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _db.range(start, end);
  }

  Future<GlucoseSourceSyncResult> syncWithResult() async {
    final result = await _syncOrchestrator.syncConfiguredSources(
      settings: _settings,
    );
    _publishLatestFrom(result);
    return result;
  }

  Future<GlucoseSourceSyncResult> syncTargetWithResult(String targetId) async {
    final result = await _syncOrchestrator.syncTarget(
      settings: _settings,
      targetId: targetId,
    );
    _publishLatestFrom(result);
    return result;
  }

  void _publishLatestFrom(GlucoseSourceSyncResult result) {
    final latest = result.sourceResults
        .expand((sourceResult) => sourceResult.readings)
        .fold<GlucoseReading?>(null, (current, reading) {
      if (current == null || reading.timestamp.isAfter(current.timestamp)) {
        return reading;
      }
      return current;
    });
    if (latest != null) {
      _latestController.add(latest);
    }
  }

  @override
  Future<List<GlucoseEvent>> eventsFor(List<GlucoseReading> readings) async {
    return EpisodeDetector.detect(readings);
  }

  @override
  Future<PersonalBaseline> baseline() async {
    final now = DateTime.now();
    final tirs = <double>[];
    final peaks = <double>[];
    final cvs = <double>[];
    final fastings = <double>[];
    final means = <double>[];

    for (int d = 0; d < 60; d++) {
      final day = now.subtract(Duration(days: d));
      final dayReadings = await forDay(day);
      if (dayReadings.length < 48) continue;
      final t = TirCalculator.calculate(dayReadings);
      tirs.add(t.tir);
      peaks
          .add(dayReadings.map((r) => r.value).reduce((a, b) => a > b ? a : b));
      cvs.add(t.cv);
      fastings.add(dayReadings.first.value);
      means.add(t.mean);
    }

    if (tirs.length < 5) {
      return PersonalBaseline(
        tirLow: 65,
        tirHigh: 75,
        peakLow: 7.5,
        peakHigh: 9.5,
        cvLow: 29,
        cvHigh: 35,
        fastingLow: 5.5,
        fastingHigh: 6.8,
        averageMeanLow: 6.8,
        averageMeanHigh: 7.6,
        updatedAt: DateTime.now(),
        daysUsed: tirs.length,
      );
    }

    tirs.sort();
    peaks.sort();
    cvs.sort();
    fastings.sort();
    means.sort();
    double p25(List<double> sorted) => sorted[(sorted.length * 0.25).floor()];
    double p75(List<double> sorted) => sorted[(sorted.length * 0.75).floor()];

    return PersonalBaseline(
      tirLow: p25(tirs),
      tirHigh: p75(tirs),
      peakLow: p25(peaks),
      peakHigh: p75(peaks),
      cvLow: p25(cvs),
      cvHigh: p75(cvs),
      fastingLow: p25(fastings),
      fastingHigh: p75(fastings),
      averageMeanLow: p25(means),
      averageMeanHigh: p75(means),
      updatedAt: DateTime.now(),
      daysUsed: tirs.length,
    );
  }

  void dispose() {
    _latestController.close();
  }
}

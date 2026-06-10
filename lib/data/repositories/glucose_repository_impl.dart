import 'dart:async';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_result.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_orchestrator.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/entities/glucose_event.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_glucose_repository.dart';
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
  Timer? _pollTimer;

  GlucoseRepositoryImpl({
    required GlucoseDatabase db,
    GlucoseSyncCoordinator? syncCoordinator,
    GlucoseSyncTargetRegistry? syncTargetRegistry,
  }) : _db = db,
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

  /// Start periodic polling from the active source. Safe to call multiple times.
  void startPolling({Duration interval = const Duration(minutes: 5)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) => sync());
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
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

  @override
  Future<void> sync() async {
    await syncWithResult();
  }

  Future<GlucoseSourceSyncResult> syncWithResult() async {
    final result = await _syncOrchestrator.syncConfiguredSources(
      settings: _settings,
    );
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
    return result;
  }

  @override
  Future<List<GlucoseEvent>> eventsFor(List<GlucoseReading> readings) async {
    return EpisodeDetector.detect(readings);
  }

  void dispose() {
    _pollTimer?.cancel();
    _latestController.close();
  }
}

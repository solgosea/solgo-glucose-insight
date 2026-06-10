import '../entities/glucose_reading.dart';

/// Data source identifier used to track which backend produced the reading.
enum DataSource { xdripHttp, nightscout }

/// Abstract source interface for each concrete source.
/// implements this. Repository chooses between sources at runtime.
abstract class IGlucoseSource {
  DataSource get type;

  /// Latest single reading (most recent SGV).
  Future<GlucoseReading?> latest();

  /// Most recent N readings, newest last.
  Future<List<GlucoseReading>> recent({int count = 24});

  /// Readings in a time window [from, to].
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  });

  /// Health check: does the source respond?
  Future<bool> isAvailable();
}

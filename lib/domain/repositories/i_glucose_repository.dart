import '../entities/glucose_reading.dart';
import '../entities/glucose_event.dart';

/// Top-level glucose data access. Hides which source (mock/xdrip/nightscout)
/// is in use and provides analysis-ready windows.
abstract class IGlucoseRepository {
  /// Stream of the latest reading (emits when new data arrives).
  Stream<GlucoseReading> get latestStream;

  /// Most recent reading (cached if available).
  Future<GlucoseReading?> latest();

  /// Last N hours of readings.
  Future<List<GlucoseReading>> lastHours(int hours);

  /// Last N days of readings.
  Future<List<GlucoseReading>> lastDays(int days);

  /// Readings for a specific calendar day.
  Future<List<GlucoseReading>> forDay(DateTime day);

  /// Force refresh from upstream source (network call).
  Future<void> sync();

  /// Auto-detected glucose events for a window.
  Future<List<GlucoseEvent>> eventsFor(List<GlucoseReading> readings);
}

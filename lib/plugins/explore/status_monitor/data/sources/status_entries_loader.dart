import '../../../../../domain/entities/glucose_reading.dart';

class StatusEntriesLoader {
  const StatusEntriesLoader();

  List<GlucoseReading> last24h(
    List<GlucoseReading> readings, {
    required DateTime now,
  }) {
    final from = now.subtract(const Duration(hours: 24));
    return readings
        .where(
          (reading) =>
              !reading.timestamp.isBefore(from) &&
              !reading.timestamp.isAfter(now),
        )
        .toList(growable: false);
  }
}

import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class SmartGlucoseSyncMergePolicy {
  const SmartGlucoseSyncMergePolicy();

  List<GlucoseReading> merge({
    required Iterable<GlucoseReading> readings,
    required DateTime from,
    required DateTime to,
  }) {
    final byTimestamp = <int, GlucoseReading>{};
    for (final reading in readings) {
      if (reading.timestamp.isBefore(from) || !reading.timestamp.isBefore(to)) {
        continue;
      }
      byTimestamp[reading.timestamp.millisecondsSinceEpoch] = reading;
    }
    return byTimestamp.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

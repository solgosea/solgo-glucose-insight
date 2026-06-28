import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

class FakeGlucoseSource implements IGlucoseSource {
  @override
  final DataSource type;
  final List<GlucoseReading> readings;
  final bool available;
  final Object? rangeError;
  final Object? availabilityError;

  int availabilityChecks = 0;
  int rangeCalls = 0;
  int recentCalls = 0;
  int latestCalls = 0;
  DateTime? lastRangeFrom;
  DateTime? lastRangeTo;
  final rangeWindows = <({DateTime from, DateTime to})>[];

  FakeGlucoseSource({
    required this.type,
    required this.readings,
    this.available = true,
    this.rangeError,
    this.availabilityError,
  });

  @override
  Future<bool> isAvailable() async {
    availabilityChecks += 1;
    final error = availabilityError;
    if (error != null) throw error;
    return available;
  }

  @override
  Future<GlucoseReading?> latest() async {
    latestCalls += 1;
    if (readings.isEmpty) return null;
    return readings.reduce(
      (a, b) => a.timestamp.isAfter(b.timestamp) ? a : b,
    );
  }

  @override
  Future<List<GlucoseReading>> recent({int count = 24}) async {
    recentCalls += 1;
    final sorted = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    if (sorted.length <= count) return sorted;
    return sorted.sublist(sorted.length - count);
  }

  @override
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  }) async {
    rangeCalls += 1;
    lastRangeFrom = from;
    lastRangeTo = to;
    rangeWindows.add((from: from, to: to));
    final error = rangeError;
    if (error != null) throw error;
    return readings
        .where((reading) =>
            !reading.timestamp.isBefore(from) && reading.timestamp.isBefore(to))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

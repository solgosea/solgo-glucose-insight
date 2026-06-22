import '../../../../../domain/entities/glucose_reading.dart';
import '../../domain/analysis/status_data_quality.dart';

class TimestampSanityResult {
  final StatusDataQuality quality;
  final Duration? futureOffset;

  const TimestampSanityResult({
    required this.quality,
    this.futureOffset,
  });

  bool get hasFutureTimestamp => quality == StatusDataQuality.futureTimestamp;
}

class TimestampSanityPolicy {
  final Duration allowedFutureSkew;

  const TimestampSanityPolicy({
    this.allowedFutureSkew = const Duration(minutes: 2),
  });

  TimestampSanityResult inspectLatest({
    required List<GlucoseReading> readings,
    required DateTime now,
  }) {
    if (readings.isEmpty) {
      return const TimestampSanityResult(
        quality: StatusDataQuality.insufficientData,
      );
    }
    final latest = readings.last.timestamp;
    final futureOffset = latest.difference(now);
    if (futureOffset > allowedFutureSkew) {
      return TimestampSanityResult(
        quality: StatusDataQuality.futureTimestamp,
        futureOffset: futureOffset,
      );
    }
    return const TimestampSanityResult(quality: StatusDataQuality.normal);
  }
}

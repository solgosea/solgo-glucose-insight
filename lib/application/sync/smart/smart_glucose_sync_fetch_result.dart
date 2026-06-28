import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import 'smart_glucose_sync_metrics.dart';

class SmartGlucoseSyncFetchResult {
  final List<GlucoseReading> readings;
  final SmartGlucoseSyncMetrics metrics;

  const SmartGlucoseSyncFetchResult({
    required this.readings,
    required this.metrics,
  });
}

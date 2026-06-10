import '../data_source/data_source_kind.dart';
import 'polling_mode.dart';

class PollingContext {
  final DataSourceKind sourceKind;
  final PollingMode mode;
  final DateTime now;
  final DateTime? lastSuccessAt;
  final DateTime? lastAttemptAt;
  final DateTime? lastReadingAt;
  final double? latestGlucoseValue;
  final double? latestRatePerMin;
  final int consecutiveFailures;
  final bool hasActiveAlert;

  const PollingContext({
    required this.sourceKind,
    required this.mode,
    required this.now,
    this.lastSuccessAt,
    this.lastAttemptAt,
    this.lastReadingAt,
    this.latestGlucoseValue,
    this.latestRatePerMin,
    this.consecutiveFailures = 0,
    this.hasActiveAlert = false,
  });
}

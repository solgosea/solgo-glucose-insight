import '../data_source/data_source_kind.dart';

class PollingSourceProfile {
  final DataSourceKind sourceKind;
  final Duration foregroundNormal;
  final Duration backgroundNormal;
  final Duration dangerous;
  final Duration stale;
  final Duration failureMax;

  const PollingSourceProfile({
    required this.sourceKind,
    required this.foregroundNormal,
    required this.backgroundNormal,
    required this.dangerous,
    required this.stale,
    required this.failureMax,
  });
}

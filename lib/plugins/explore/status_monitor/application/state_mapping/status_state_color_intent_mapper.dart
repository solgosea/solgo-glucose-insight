import '../../domain/state/status_observation_severity.dart';

enum StatusStateColorIntent {
  good,
  attention,
  blocked,
  neutral,
}

class StatusStateColorIntentMapper {
  const StatusStateColorIntentMapper();

  StatusStateColorIntent map(StatusObservationSeverity severity) {
    return switch (severity) {
      StatusObservationSeverity.good => StatusStateColorIntent.good,
      StatusObservationSeverity.attention => StatusStateColorIntent.attention,
      StatusObservationSeverity.blocked => StatusStateColorIntent.blocked,
      StatusObservationSeverity.neutral => StatusStateColorIntent.neutral,
    };
  }
}

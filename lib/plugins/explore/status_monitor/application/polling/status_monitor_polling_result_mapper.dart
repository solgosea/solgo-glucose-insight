import 'package:smart_xdrip/application/polling_runtime/polling_job_result.dart';

import '../../domain/status_report.dart';

class StatusMonitorPollingResultMapper {
  const StatusMonitorPollingResultMapper();

  PollingJobResult success(
    StatusReport report, {
    Duration? nextInterval,
  }) {
    return PollingJobResult.success(
      nextInterval: nextInterval,
      message:
          'Status Monitor refreshed ${report.components.length} components.',
    );
  }

  PollingJobResult failure(Object error) {
    return PollingJobResult.failure(
      error: error,
      message: 'Status Monitor refresh failed.',
    );
  }
}

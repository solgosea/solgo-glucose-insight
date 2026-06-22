import 'package:smart_xdrip/application/polling_runtime/polling_job_policy.dart';

class StatusMonitorPollingPolicy {
  static const foregroundInterval = Duration(minutes: 1);
  static const backgroundInterval = Duration(minutes: 5);

  const StatusMonitorPollingPolicy();

  PollingJobPolicy build() {
    return const PollingJobPolicy(
      runImmediatelyOnStart: false,
      foregroundInterval: foregroundInterval,
      backgroundInterval: backgroundInterval,
      failureBaseDelay: Duration(seconds: 45),
      failureMaxDelay: Duration(minutes: 10),
      retryDelayFactor: Duration(milliseconds: 500),
      retryMaxDelay: Duration(seconds: 5),
      retryMaxAttempts: 2,
    );
  }
}

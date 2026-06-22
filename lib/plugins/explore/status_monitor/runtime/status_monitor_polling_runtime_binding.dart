import 'package:smart_xdrip/application/polling_runtime/polling_runtime.dart';
import 'package:smart_xdrip/domain/polling/polling_mode.dart';

import '../application/polling/status_monitor_polling_job.dart';

class StatusMonitorPollingRuntimeBinding {
  final PollingRuntime runtime;
  final StatusMonitorPollingJob job;
  bool _registered = false;

  StatusMonitorPollingRuntimeBinding({
    required this.runtime,
    required this.job,
  });

  void start({PollingMode mode = PollingMode.foreground}) {
    if (!_registered) {
      runtime.register(job);
      _registered = true;
    }
    if (runtime.isActive) {
      runtime.updateMode(mode);
    } else {
      runtime.start(mode: mode);
    }
  }

  void triggerNow() {
    if (!_registered) {
      runtime.register(job);
      _registered = true;
    }
    runtime.triggerNow(StatusMonitorPollingJob.jobKey);
  }

  void stop() {
    runtime.stop();
  }

  void dispose() {
    runtime.dispose();
    _registered = false;
  }
}

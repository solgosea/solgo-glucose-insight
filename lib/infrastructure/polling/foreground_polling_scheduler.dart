import 'dart:async';

import '../../application/data_source_runtime/data_source_runtime_polling_adapter.dart';
import '../../application/sync_status/sync_schedule_reporter.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/polling/polling_mode.dart';
import '../../domain/sync_status/sync_schedule_mode.dart';

typedef ForegroundPollingAfterSync = Future<void> Function();

class ForegroundPollingScheduler {
  final DataSourceRuntimePollingAdapter pollingAdapter;
  final ForegroundPollingAfterSync? afterSync;
  final SyncScheduleReporter? scheduleReporter;

  Timer? _timer;
  AppSettings? _settings;
  bool _running = false;

  ForegroundPollingScheduler({
    required this.pollingAdapter,
    this.afterSync,
    this.scheduleReporter,
  });

  Future<void> start(AppSettings settings) async {
    _settings = settings;
    await _scheduleNext(initial: true);
  }

  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    await _scheduleNext(initial: true);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _settings = null;
    scheduleReporter?.reportPaused(reason: 'Foreground polling stopped');
  }

  Future<void> _scheduleNext({bool initial = false}) async {
    _timer?.cancel();
    final settings = _settings;
    if (settings == null) return;
    final decision = await pollingAdapter.decide(
      settings: settings,
      mode: PollingMode.foreground,
    );
    if (!decision.shouldSyncNow) {
      scheduleReporter?.reportDecision(
        decision: decision,
        mode: SyncScheduleMode.foreground,
      );
      return;
    }
    final interval = initial ? Duration.zero : decision.nextInterval;
    scheduleReporter?.reportDecision(
      decision: decision,
      mode: SyncScheduleMode.foreground,
      overrideInterval: interval,
    );
    _timer = Timer(interval, _runOnce);
  }

  Future<void> _runOnce() async {
    if (_running) return;
    final settings = _settings;
    if (settings == null) return;
    _running = true;
    try {
      await pollingAdapter.syncExecutor();
      await afterSync?.call();
    } finally {
      _running = false;
      await _scheduleNext();
    }
  }

  void dispose() {
    stop();
  }
}

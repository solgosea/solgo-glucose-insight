import '../../domain/entities/app_settings.dart';
import '../../domain/polling/polling_decision.dart';
import '../polling/polling_decision_service.dart';
import '../../domain/polling/polling_mode.dart';

typedef DataSourceSyncExecutor = Future<void> Function();

class DataSourceRuntimePollingAdapter {
  final PollingDecisionService decisionService;
  final DataSourceSyncExecutor syncExecutor;

  const DataSourceRuntimePollingAdapter({
    required this.decisionService,
    required this.syncExecutor,
  });

  Future<PollingDecision> decide({
    required AppSettings settings,
    required PollingMode mode,
  }) {
    return decisionService.decide(settings: settings, mode: mode);
  }

  Future<PollingDecision> syncAndDecideNext({
    required AppSettings settings,
    required PollingMode mode,
  }) async {
    await syncExecutor();
    return decide(settings: settings, mode: mode);
  }
}

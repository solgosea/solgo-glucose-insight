import '../../domain/entities/app_settings.dart';
import '../../infrastructure/background/flutter_background_service_adapter.dart';
import 'background_runtime_context_loader.dart';
import 'background_runtime_decision.dart';
import 'background_runtime_policy.dart';

class BackgroundRuntimeOrchestrator {
  final BackgroundRuntimeContextLoader contextLoader;
  final BackgroundRuntimePolicy policy;
  final FlutterBackgroundServiceAdapter serviceAdapter;

  const BackgroundRuntimeOrchestrator({
    required this.policy,
    required this.serviceAdapter,
    this.contextLoader = const BackgroundRuntimeContextLoader(),
  });

  Future<BackgroundRuntimeDecision> evaluate(AppSettings settings) async {
    return policy.decide(await contextLoader.load(settings));
  }

  Future<BackgroundRuntimeDecision> sync(AppSettings settings) async {
    final decision = await evaluate(settings);
    await serviceAdapter.syncWithDecision(settings, decision);
    return decision;
  }
}

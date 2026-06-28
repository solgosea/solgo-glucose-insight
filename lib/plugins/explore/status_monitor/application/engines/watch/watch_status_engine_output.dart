import '../../../domain/component_health.dart';
import 'facts/watch_evidence_bundle.dart';

class WatchStatusEngineOutput {
  final WatchEvidenceBundle bundle;
  final ComponentHealth health;

  const WatchStatusEngineOutput({
    required this.bundle,
    required this.health,
  });
}

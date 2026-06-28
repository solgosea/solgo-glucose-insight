import '../../domain/hub/facts/status_hub_fact_bundle.dart';

class StatusHubEngineInput {
  final StatusHubFactBundle facts;
  final DateTime? now;

  const StatusHubEngineInput({
    required this.facts,
    this.now,
  });
}

import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_models.dart';

abstract class StatusHubConnectionPolicy {
  StatusHubConnection evaluate(StatusHubFactBundle facts);
}

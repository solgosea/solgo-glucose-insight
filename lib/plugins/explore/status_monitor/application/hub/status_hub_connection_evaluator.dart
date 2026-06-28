import '../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../domain/hub/status_hub_models.dart';
import 'diagnosis/status_hub_path_diagnosis_policy.dart';
import 'path/status_hub_path_evidence_builder.dart';
import 'policies/cgm_to_xdrip_connection_policy.dart';
import 'policies/juggluco_to_xdrip_connection_policy.dart';
import 'policies/status_hub_connection_policy.dart';
import 'policies/xdrip_to_aaps_connection_policy.dart';
import 'policies/xdrip_to_nightscout_connection_policy.dart';
import 'policies/xdrip_to_watch_connection_policy.dart';

class StatusHubConnectionEvaluator {
  final List<StatusHubConnectionPolicy> policies;
  final StatusHubPathEvidenceBuilder evidenceBuilder;
  final StatusHubPathDiagnosisPolicy diagnosisPolicy;

  const StatusHubConnectionEvaluator({
    this.policies = const [
      CgmToXdripConnectionPolicy(),
      JugglucoToXdripConnectionPolicy(),
      XdripToNightscoutConnectionPolicy(),
      XdripToAapsConnectionPolicy(),
      XdripToWatchConnectionPolicy(),
    ],
    this.evidenceBuilder = const StatusHubPathEvidenceBuilder(),
    this.diagnosisPolicy = const StatusHubPathDiagnosisPolicy(),
  });

  List<StatusHubConnection> evaluate(StatusHubFactBundle facts) {
    final evidenceByPath = {
      for (final evidence in evidenceBuilder.build(facts))
        evidence.pathId: evidence,
    };
    return policies.map((policy) {
      final baseConnection = policy.evaluate(facts);
      final evidence = evidenceByPath[baseConnection.id];
      if (evidence == null) return baseConnection;
      final diagnosis = diagnosisPolicy.diagnose(
        baseConnection: baseConnection,
        evidence: evidence,
      );
      return diagnosisPolicy.toConnection(baseConnection, diagnosis);
    }).toList();
  }
}

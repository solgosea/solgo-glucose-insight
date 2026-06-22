import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/nightscout/nightscout_endpoint_matrix.dart';

class NightscoutEndpointMatrixCalculator {
  const NightscoutEndpointMatrixCalculator();

  NightscoutEndpointMatrix calculate(StatusAnalysisContext context) {
    return NightscoutEndpointMatrix(
      endpoints: context.evidence.nightscoutEvidence.endpointProbes,
    );
  }
}

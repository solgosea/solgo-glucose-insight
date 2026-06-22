import 'nightscout_pipeline_gate_result.dart';

class NightscoutHealthScoreBreakdown {
  final int rawScore;
  final int finalScore;
  final double confidence;
  final double availableWeight;
  final double totalWeight;
  final NightscoutPipelineGateResult gate;

  const NightscoutHealthScoreBreakdown({
    required this.rawScore,
    required this.finalScore,
    required this.confidence,
    required this.availableWeight,
    required this.totalWeight,
    required this.gate,
  });

  Map<String, Object?> toJson() => {
        'rawScore': rawScore,
        'finalScore': finalScore,
        'confidence': confidence,
        'availableWeight': availableWeight,
        'totalWeight': totalWeight,
        'gateMessage': gate.message,
      };
}

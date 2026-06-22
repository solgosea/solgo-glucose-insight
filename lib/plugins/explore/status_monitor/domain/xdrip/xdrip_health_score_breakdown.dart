import 'xdrip_pipeline_gate_result.dart';

class XdripHealthScoreBreakdown {
  final int rawScore;
  final int finalScore;
  final double confidence;
  final double availableWeight;
  final double totalWeight;
  final String readingSourceLabel;
  final XdripPipelineGateResult gate;

  const XdripHealthScoreBreakdown({
    required this.rawScore,
    required this.finalScore,
    required this.confidence,
    required this.availableWeight,
    required this.totalWeight,
    required this.readingSourceLabel,
    required this.gate,
  });

  Map<String, Object?> toJson() => {
        'rawScore': rawScore,
        'finalScore': finalScore,
        'confidence': confidence,
        'availableWeight': availableWeight,
        'totalWeight': totalWeight,
        'readingSourceLabel': readingSourceLabel,
        'gateMessage': gate.message,
      };
}

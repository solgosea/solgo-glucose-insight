import 'cgm_sensor_pipeline_gate_result.dart';

class CgmSensorHealthScoreBreakdown {
  final int rawScore;
  final int finalScore;
  final double confidence;
  final double availableWeight;
  final double totalWeight;
  final String liveSourceLabel;
  final String historySourceLabel;
  final CgmSensorPipelineGateResult gate;

  const CgmSensorHealthScoreBreakdown({
    required this.rawScore,
    required this.finalScore,
    required this.confidence,
    required this.availableWeight,
    required this.totalWeight,
    required this.liveSourceLabel,
    required this.historySourceLabel,
    required this.gate,
  });

  Map<String, Object?> toJson() => {
        'rawScore': rawScore,
        'finalScore': finalScore,
        'confidence': confidence,
        'availableWeight': availableWeight,
        'totalWeight': totalWeight,
        'liveSourceLabel': liveSourceLabel,
        'historySourceLabel': historySourceLabel,
        'gateMessage': gate.message,
      };
}

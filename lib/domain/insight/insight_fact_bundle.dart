import '../analysis/analysis_module_code.dart';
import 'insight_slot_code.dart';
import 'insight_type_code.dart';

class InsightFactBundle {
  final AnalysisModuleCode module;
  final InsightSlotCode slot;
  final InsightTypeCode type;
  final Map<String, Object?> facts;
  final int priority;

  const InsightFactBundle({
    required this.module,
    required this.slot,
    required this.type,
    required this.facts,
    this.priority = 100,
  });
}

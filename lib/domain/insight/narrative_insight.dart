import '../analysis/analysis_module_code.dart';
import 'insight_slot_code.dart';
import 'insight_type_code.dart';

class NarrativeInsight {
  final String id;
  final AnalysisModuleCode module;
  final InsightSlotCode slot;
  final InsightTypeCode type;
  final String templateCode;
  final int templateVersion;
  final String? title;
  final String? eyebrow;
  final String body;
  final String? footer;
  final Map<String, Object?> facts;
  final DateTime generatedAt;

  const NarrativeInsight({
    required this.id,
    required this.module,
    required this.slot,
    required this.type,
    required this.templateCode,
    required this.templateVersion,
    required this.body,
    required this.facts,
    required this.generatedAt,
    this.title,
    this.eyebrow,
    this.footer,
  });
}

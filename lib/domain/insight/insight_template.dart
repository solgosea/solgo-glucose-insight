import '../analysis/analysis_module_code.dart';
import 'insight_slot_code.dart';
import 'insight_type_code.dart';

class InsightTemplate {
  final String code;
  final AnalysisModuleCode module;
  final InsightSlotCode slot;
  final InsightTypeCode type;
  final String locale;
  final int version;
  final String? iconKey;
  final String? tone;
  final String? titleTemplate;
  final String? eyebrowTemplate;
  final String bodyTemplate;
  final String? footerTemplate;
  final List<String> requiredFacts;
  final String? fallbackCode;
  final int priority;
  final bool enabled;

  const InsightTemplate({
    required this.code,
    required this.module,
    required this.slot,
    required this.type,
    required this.bodyTemplate,
    this.locale = 'en',
    this.version = 1,
    this.iconKey,
    this.tone,
    this.titleTemplate,
    this.eyebrowTemplate,
    this.footerTemplate,
    this.requiredFacts = const [],
    this.fallbackCode,
    this.priority = 100,
    this.enabled = true,
  });
}

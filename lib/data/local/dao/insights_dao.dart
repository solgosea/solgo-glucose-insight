import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../domain/analysis/analysis_module_code.dart';
import '../../../domain/insight/insight_template.dart';
import '../../../domain/insight/insight_slot_code.dart';
import '../../../domain/insight/insight_type_code.dart';
import '../../../domain/insight/narrative_insight.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class InsightsDao {
  final Future<Database> Function() _db;

  const InsightsDao(this._db);

  Future<void> upsertTemplates(List<InsightTemplate> templates) async {
    if (templates.isEmpty) return;
    final database = await _db();
    final now = DateTime.now().millisecondsSinceEpoch;
    await database.delete(GlucoseTables.insightTemplates);
    final batch = database.batch();
    for (final t in templates) {
      batch.insert(
        GlucoseTables.insightTemplates,
        {
          'code': t.code,
          'module_code': t.module.code,
          'slot_code': t.slot.code,
          'insight_type': t.type.code,
          'locale': t.locale,
          'version': t.version,
          'icon_key': t.iconKey,
          'tone': t.tone,
          'title_template': t.titleTemplate,
          'eyebrow_template': t.eyebrowTemplate,
          'body_template': t.bodyTemplate,
          'footer_template': t.footerTemplate,
          'required_facts_json': jsonEncode(t.requiredFacts),
          'fallback_code': t.fallbackCode,
          'priority': t.priority,
          'enabled': t.enabled ? 1 : 0,
          'updated_at_ms': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<InsightTemplate>> templatesForModule(
    AnalysisModuleCode module,
  ) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.insightTemplates,
      where: 'module_code = ? AND enabled = 1',
      whereArgs: [module.code],
      orderBy: 'priority ASC, code ASC',
    );
    return rows.map(_toTemplate).toList();
  }

  Future<void> upsertGenerated(
    List<NarrativeInsight> insights, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (insights.isEmpty) return;
    final database = await _db();
    await database.delete(
      GlucoseTables.generatedInsights,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
    );
    final batch = database.batch();
    for (final i in insights) {
      batch.insert(
        GlucoseTables.generatedInsights,
        {
          'id': i.id,
          'subject_id': subjectId,
          'module_code': i.module.code,
          'slot_code': i.slot.code,
          'insight_type': i.type.code,
          'template_code': i.templateCode,
          'template_version': i.templateVersion,
          'title': i.title ?? '',
          'eyebrow': i.eyebrow,
          'body': i.body,
          'footer': i.footer,
          'facts_json': jsonEncode(i.facts),
          'generated_at_ms': i.generatedAt.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<NarrativeInsight>> latestGenerated({
    AnalysisModuleCode? module,
    int limit = 20,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final where =
        module == null
            ? 'subject_id = ?'
            : 'subject_id = ? AND module_code = ?';
    final whereArgs = module == null ? [subjectId] : [subjectId, module.code];
    final rows = await database.query(
      GlucoseTables.generatedInsights,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'generated_at_ms DESC',
      limit: limit,
    );
    return rows.map(_toGenerated).toList();
  }

  InsightTemplate _toTemplate(Map<String, Object?> row) => InsightTemplate(
    code: row['code'] as String,
    module: AnalysisModuleCode.values.firstWhere(
      (m) => m.code == row['module_code'],
      orElse: () => AnalysisModuleCode.insights,
    ),
    slot: InsightSlotCode.fromCode(row['slot_code'] as String?),
    type: InsightTypeCode.fromCode(row['insight_type'] as String?),
    locale: row['locale'] as String? ?? 'en',
    version: row['version'] as int? ?? 1,
    iconKey: row['icon_key'] as String?,
    tone: row['tone'] as String?,
    titleTemplate: row['title_template'] as String?,
    eyebrowTemplate: row['eyebrow_template'] as String?,
    bodyTemplate: row['body_template'] as String,
    footerTemplate: row['footer_template'] as String?,
    requiredFacts: _decodeRequiredFacts(row['required_facts_json'] as String?),
    fallbackCode: row['fallback_code'] as String?,
    priority: row['priority'] as int,
    enabled: row['enabled'] == 1,
  );

  NarrativeInsight _toGenerated(Map<String, Object?> row) => NarrativeInsight(
    id: row['id'] as String,
    module: AnalysisModuleCode.values.firstWhere(
      (m) => m.code == row['module_code'],
      orElse: () => AnalysisModuleCode.insights,
    ),
    slot: InsightSlotCode.fromCode(row['slot_code'] as String?),
    type: InsightTypeCode.fromCode(row['insight_type'] as String?),
    templateCode: row['template_code'] as String,
    templateVersion: row['template_version'] as int? ?? 1,
    title: _emptyToNull(row['title'] as String?),
    eyebrow: row['eyebrow'] as String?,
    body: row['body'] as String,
    footer: row['footer'] as String?,
    facts: _decodeFacts(row['facts_json'] as String?),
    generatedAt: DateTime.fromMillisecondsSinceEpoch(
      row['generated_at_ms'] as int,
    ),
  );

  List<String> _decodeRequiredFacts(String? value) {
    if (value == null || value.isEmpty) return const [];
    final decoded = jsonDecode(value);
    if (decoded is! List) return const [];
    return decoded.map((item) => item.toString()).toList();
  }

  Map<String, Object?> _decodeFacts(String? value) {
    if (value == null || value.isEmpty) return const {};
    final decoded = jsonDecode(value);
    if (decoded is! Map) return const {};
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }

  String? _emptyToNull(String? value) {
    if (value == null || value.isEmpty) return null;
    return value;
  }
}

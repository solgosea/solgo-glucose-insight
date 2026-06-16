import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'plugin_text_template.dart';
import 'plugin_text_template_repository.dart';

class SqlitePluginTextTemplateRepository
    implements PluginTextTemplateRepository {
  final String tableName;
  final Future<Database> Function() databaseProvider;

  const SqlitePluginTextTemplateRepository({
    required this.tableName,
    required this.databaseProvider,
  });

  @override
  Future<void> upsertAll(List<PluginTextTemplate> templates) async {
    if (templates.isEmpty) return;
    final database = await databaseProvider();
    final batch = database.batch();
    for (final template in templates) {
      batch.insert(
        tableName,
        {
          'template_key': template.key,
          'slot': template.slot,
          'type': template.type,
          'locale': template.locale,
          'version': template.version,
          'title_template': template.titleTemplate,
          'body_template': template.bodyTemplate,
          'footer_template': template.footerTemplate,
          'required_facts_json': jsonEncode(template.requiredFacts),
          'enabled': template.enabled ? 1 : 0,
          'priority': template.priority,
          'updated_at_ms': template.updatedAtMs == 0
              ? DateTime.now().millisecondsSinceEpoch
              : template.updatedAtMs,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<PluginTextTemplate>> loadEnabled() async {
    final database = await databaseProvider();
    final rows = await database.query(
      tableName,
      where: 'enabled = 1',
      orderBy: 'priority ASC, template_key ASC',
    );
    return rows.map(_toTemplate).toList(growable: false);
  }

  PluginTextTemplate _toTemplate(Map<String, Object?> row) {
    return PluginTextTemplate(
      key: row['template_key'] as String,
      slot: row['slot'] as String,
      type: row['type'] as String,
      locale: row['locale'] as String? ?? 'en',
      version: row['version'] as int? ?? 1,
      titleTemplate: row['title_template'] as String?,
      bodyTemplate: row['body_template'] as String,
      footerTemplate: row['footer_template'] as String?,
      requiredFacts: _decodeFacts(row['required_facts_json'] as String?),
      enabled: row['enabled'] == 1,
      priority: row['priority'] as int? ?? 100,
      updatedAtMs: row['updated_at_ms'] as int? ?? 0,
    );
  }

  List<String> _decodeFacts(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.map((item) => item.toString()).toList(growable: false);
  }
}

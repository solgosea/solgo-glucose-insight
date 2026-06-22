import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../domain/text/status_text_template.dart';
import 'status_monitor_tables.dart';
import 'status_monitor_template_repository.dart';

class SqliteStatusMonitorTemplateRepository
    implements StatusMonitorTemplateRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteStatusMonitorTemplateRepository({
    required this.databaseProvider,
  });

  @override
  Future<void> upsertAll(List<StatusTextTemplate> templates) async {
    if (templates.isEmpty) return;
    final database = await databaseProvider();
    final batch = database.batch();
    for (final template in templates) {
      batch.insert(
        StatusMonitorTables.textTemplates,
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
}

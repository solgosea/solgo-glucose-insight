import 'package:sqflite/sqflite.dart';

import '../../domain/floating/floating_glance_form_factor.dart';
import '../../domain/floating/floating_glance_mode.dart';
import '../../domain/floating/floating_glance_position.dart';
import '../../domain/floating/floating_glance_preset_source.dart';
import '../../domain/floating/floating_glance_settings.dart';
import '../../domain/floating/floating_glance_size_preset.dart';
import 'glance_tables.dart';

class SqliteFloatingGlanceSettingsRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteFloatingGlanceSettingsRepository({
    required this.databaseProvider,
  });

  Future<FloatingGlanceSettings> get() async {
    final database = await databaseProvider();
    await _ensurePresetColumns(database);
    final rows = await database.query(
      GlanceTables.floatingSettings,
      where: 'id = 1',
      limit: 1,
    );
    if (rows.isEmpty) return const FloatingGlanceSettings();
    final row = rows.first;
    return FloatingGlanceSettings(
      mode: FloatingGlanceMode.fromCode(row['mode'] as String?),
      sizePreset: FloatingGlanceSizePreset.fromCode(
        row['size_preset'] as String?,
      ),
      formFactor: FloatingGlanceFormFactor.fromCode(
        row['form_factor'] as String?,
      ),
      presetSource: FloatingGlancePresetSource.fromCode(
        row['preset_source'] as String?,
      ),
      position: FloatingGlancePosition(
        x: (row['position_x'] as num).toDouble(),
        y: (row['position_y'] as num).toDouble(),
      ),
      collapsed: row['collapsed'] == 1,
    );
  }

  Future<void> save(FloatingGlanceSettings settings) async {
    final database = await databaseProvider();
    await _ensurePresetColumns(database);
    await database.insert(
      GlanceTables.floatingSettings,
      {
        'id': 1,
        'mode': settings.mode.code,
        'display_style': 'pill',
        'size_preset': settings.sizePreset.code,
        'form_factor': settings.formFactor.code,
        'preset_source': settings.presetSource.code,
        'position_x': settings.position.x,
        'position_y': settings.position.y,
        'collapsed': settings.collapsed ? 1 : 0,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _ensurePresetColumns(Database database) async {
    final rows = await database.rawQuery(
      'PRAGMA table_info(${GlanceTables.floatingSettings})',
    );
    final columns = rows.map((row) => row['name']).whereType<String>().toSet();
    if (!columns.contains('size_preset')) {
      await database.execute(
        "ALTER TABLE ${GlanceTables.floatingSettings} "
        "ADD COLUMN size_preset TEXT NOT NULL DEFAULT 'medium'",
      );
    }
    if (!columns.contains('form_factor')) {
      await database.execute(
        "ALTER TABLE ${GlanceTables.floatingSettings} "
        "ADD COLUMN form_factor TEXT NOT NULL DEFAULT 'pill'",
      );
    }
    if (!columns.contains('preset_source')) {
      await database.execute(
        "ALTER TABLE ${GlanceTables.floatingSettings} "
        "ADD COLUMN preset_source TEXT NOT NULL DEFAULT 'automatic'",
      );
    }
  }
}

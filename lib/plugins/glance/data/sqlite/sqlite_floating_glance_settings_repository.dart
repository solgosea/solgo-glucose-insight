import 'package:sqflite/sqflite.dart';

import '../../domain/floating/floating_glance_display_style.dart';
import '../../domain/floating/floating_glance_mode.dart';
import '../../domain/floating/floating_glance_position.dart';
import '../../domain/floating/floating_glance_settings.dart';
import 'glance_tables.dart';

class SqliteFloatingGlanceSettingsRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteFloatingGlanceSettingsRepository({
    required this.databaseProvider,
  });

  Future<FloatingGlanceSettings> get() async {
    final database = await databaseProvider();
    final rows = await database.query(
      GlanceTables.floatingSettings,
      where: 'id = 1',
      limit: 1,
    );
    if (rows.isEmpty) return const FloatingGlanceSettings();
    final row = rows.first;
    return FloatingGlanceSettings(
      mode: FloatingGlanceMode.fromCode(row['mode'] as String?),
      displayStyle: FloatingGlanceDisplayStyle.fromCode(
        row['display_style'] as String?,
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
    await database.insert(
      GlanceTables.floatingSettings,
      {
        'id': 1,
        'mode': settings.mode.code,
        'display_style': settings.displayStyle.code,
        'position_x': settings.position.x,
        'position_y': settings.position.y,
        'collapsed': settings.collapsed ? 1 : 0,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

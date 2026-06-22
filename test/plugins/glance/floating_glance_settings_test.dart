import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:smart_xdrip/plugins/glance/data/sqlite/glance_tables.dart';
import 'package:smart_xdrip/plugins/glance/data/sqlite/sqlite_floating_glance_settings_repository.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_form_factor.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_mode.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_preset_source.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_settings.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_size_preset.dart';

void main() {
  sqfliteFfiInit();

  test('floating glance defaults to enabled pending permission', () {
    const settings = FloatingGlanceSettings();

    expect(settings.mode, FloatingGlanceMode.enabled);
    expect(settings.sizePreset, FloatingGlanceSizePreset.medium);
    expect(settings.formFactor, FloatingGlanceFormFactor.pill);
    expect(settings.presetSource, FloatingGlancePresetSource.automatic);
    expect(settings.enabled, isTrue);
  });

  test('repository self-heals preset columns on existing floating table',
      () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(db.close);
    await db.execute('''
      CREATE TABLE ${GlanceTables.floatingSettings} (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        mode TEXT NOT NULL,
        display_style TEXT NOT NULL,
        position_x REAL NOT NULL,
        position_y REAL NOT NULL,
        collapsed INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    final repository = SqliteFloatingGlanceSettingsRepository(
      databaseProvider: () async => db,
    );

    await repository.save(
      const FloatingGlanceSettings(
        sizePreset: FloatingGlanceSizePreset.large,
        formFactor: FloatingGlanceFormFactor.card,
        presetSource: FloatingGlancePresetSource.user,
      ),
    );
    final settings = await repository.get();
    final columns = await db.rawQuery(
      'PRAGMA table_info(${GlanceTables.floatingSettings})',
    );
    final names = columns.map((row) => row['name']).toSet();

    expect(names, contains('size_preset'));
    expect(names, contains('form_factor'));
    expect(names, contains('preset_source'));
    expect(settings.sizePreset, FloatingGlanceSizePreset.large);
    expect(settings.formFactor, FloatingGlanceFormFactor.card);
    expect(settings.presetSource, FloatingGlancePresetSource.user);
  });
}

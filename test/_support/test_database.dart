import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/alerting/data/sqlite/alerting_schema.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestDatabase {
  const TestDatabase._();

  static GlucoseDatabase create() {
    sqfliteFfiInit();
    return GlucoseDatabase(
      databaseFactoryOverride: databaseFactoryFfi,
      databasePathOverride: inMemoryDatabasePath,
    );
  }

  static Future<GlucoseDatabase> createWithAlerting() async {
    final database = create();
    await const AlertingSchema().create(await database.db);
    return database;
  }
}

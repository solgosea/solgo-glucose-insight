import 'package:sqflite/sqflite.dart';

import 'plugin_schema_context.dart';
import 'plugin_schema_registry.dart';
import 'plugin_schema_version_store.dart';

class PluginSchemaManager {
  final Future<Database> Function() databaseProvider;
  final PluginSchemaRegistry registry;
  final PluginSchemaVersionStore versionStore;

  const PluginSchemaManager({
    required this.databaseProvider,
    required this.registry,
    this.versionStore = const PluginSchemaVersionStore(),
  });

  Future<void> ensureInstalled() async {
    final database = await databaseProvider();
    await versionStore.ensureInitialized(database);
    for (final contributor in registry.contributors) {
      final currentVersion = await versionStore.versionFor(
        database,
        contributor.pluginId,
      );
      final targetVersion = contributor.schemaVersion;
      if (currentVersion == targetVersion) continue;
      if (currentVersion > targetVersion) continue;

      final context = PluginSchemaContext(
        database: database,
        pluginId: contributor.pluginId,
      );
      if (currentVersion == 0) {
        await contributor.install(context);
      } else {
        await contributor.migrate(
          context,
          fromVersion: currentVersion,
          toVersion: targetVersion,
        );
      }
      await versionStore.markInstalled(
        database,
        pluginId: contributor.pluginId,
        schemaVersion: targetVersion,
      );
    }
  }
}

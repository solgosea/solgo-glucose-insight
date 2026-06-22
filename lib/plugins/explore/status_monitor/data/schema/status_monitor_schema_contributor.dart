import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_context.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_contributor.dart';

import '../sqlite/status_monitor_schema.dart';

class StatusMonitorSchemaContributor extends PluginSchemaContributor {
  const StatusMonitorSchemaContributor();

  @override
  String get pluginId => 'explore.statusMonitor';

  @override
  int get schemaVersion => 3;

  @override
  Future<void> install(PluginSchemaContext context) {
    return const StatusMonitorSchema().install(context.database);
  }

  @override
  Future<void> migrate(
    PluginSchemaContext context, {
    required int fromVersion,
    required int toVersion,
  }) {
    return const StatusMonitorSchema().install(context.database);
  }
}

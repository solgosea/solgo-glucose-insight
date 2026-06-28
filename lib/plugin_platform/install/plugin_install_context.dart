import '../composition/plugin_composition_registry.dart';
import '../i18n/plugin_entry_localization_registry.dart';
import '../runtime/contracts/plugin_runtime.dart';
import '../runtime/manager/plugin_runtime_manager.dart';
import '../runtime/manager/plugin_runtime_start_policy.dart';
import '../schema/plugin_schema_contributor.dart';
import '../schema/plugin_schema_registry.dart';
import '../services/plugin_service_registry.dart';

class PluginInstallContext {
  final PluginRuntimeManager runtimeManager;
  final PluginServiceRegistry services;
  final PluginSchemaRegistry schemaRegistry;
  final PluginCompositionRegistry compositionRegistry;
  final PluginEntryLocalizationRegistry entryLocalizers;

  PluginInstallContext({
    required this.runtimeManager,
    required this.services,
    required this.schemaRegistry,
    PluginCompositionRegistry? compositionRegistry,
    PluginEntryLocalizationRegistry? entryLocalizers,
  })  : compositionRegistry =
            compositionRegistry ?? PluginCompositionRegistry(),
        entryLocalizers = entryLocalizers ?? PluginEntryLocalizationRegistry();

  void registerRuntime(
    PluginRuntime runtime, {
    PluginRuntimeStartPolicy startPolicy = PluginRuntimeStartPolicy.onEnter,
  }) {
    runtimeManager.register(runtime, startPolicy: startPolicy);
  }

  void registerSchema(PluginSchemaContributor contributor) {
    schemaRegistry.register(contributor);
  }
}

import '../contracts/plugin_capability.dart';
import '../contracts/plugin_data_requirement.dart';
import '../contracts/plugin_runtime_state.dart';
import '../contracts/plugin_runtime_status.dart';
import '../contracts/smart_feature_plugin.dart';

class PluginRuntimeStateResolver {
  const PluginRuntimeStateResolver();

  PluginRuntimeState resolve(
    SmartFeaturePlugin plugin, {
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final capability = plugin.capability(context);
    if (!capability.visible) {
      return PluginRuntimeState(
        pluginId: plugin.id,
        status: PluginRuntimeStatus.hidden,
        reason: capability.reason,
      );
    }
    if (!capability.enabled) {
      return PluginRuntimeState(
        pluginId: plugin.id,
        status: PluginRuntimeStatus.disabled,
        reason: capability.reason,
      );
    }
    if (plugin.dataRequirements
            .contains(PluginDataRequirement.glucoseReadings) &&
        !context.hasGlucoseData) {
      return _noData(plugin, 'No glucose data available yet');
    }
    if (plugin.dataRequirements.contains(PluginDataRequirement.episodeEvents) &&
        !context.hasGlucoseEvents) {
      return _noData(plugin, 'No glucose events available yet');
    }
    if (plugin.dataRequirements
            .contains(PluginDataRequirement.dailySummaries) &&
        !context.hasDailySummaries) {
      return _noData(plugin, 'No daily summaries available yet');
    }
    if (plugin.dataRequirements
            .contains(PluginDataRequirement.periodSummaries) &&
        !context.hasPeriodSummaries) {
      return _noData(plugin, 'No period summaries available yet');
    }
    if (plugin.dataRequirements.contains(PluginDataRequirement.agpSlots) &&
        !context.hasGlucoseData) {
      return _noData(plugin, 'No AGP data available yet');
    }
    if (plugin.dataRequirements
            .contains(PluginDataRequirement.sourceConnection) &&
        !context.hasConfiguredSource) {
      return PluginRuntimeState(
        pluginId: plugin.id,
        status: PluginRuntimeStatus.missingSource,
        reason: 'No data source configured',
      );
    }
    return PluginRuntimeState(
      pluginId: plugin.id,
      status: PluginRuntimeStatus.available,
    );
  }

  PluginRuntimeState _noData(SmartFeaturePlugin plugin, String reason) {
    return PluginRuntimeState(
      pluginId: plugin.id,
      status: PluginRuntimeStatus.noData,
      reason: reason,
    );
  }
}

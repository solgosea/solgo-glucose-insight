import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_renderable.dart';
import 'package:smart_xdrip/plugins/explore/composition/explore_slots.dart';

import '../composition/status_monitor_placement.dart';
import '../presentation/widgets/status_monitor_entry_card.dart';

class StatusMonitorCompositionRegistrar {
  const StatusMonitorCompositionRegistrar();

  void register(PluginInstallContext context, PluginId pluginId) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: pluginId,
        slot: ExploreSlots.card,
        renderKey: StatusMonitorPlacement.renderKey,
        title: StatusMonitorPlacement.title,
        order: StatusMonitorPlacement.order,
        builder: (renderContext) =>
            StatusMonitorEntryCard(renderContext: renderContext),
      ),
    );
  }
}

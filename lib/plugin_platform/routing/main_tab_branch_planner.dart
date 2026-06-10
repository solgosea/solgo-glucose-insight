import 'package:flutter/widgets.dart';

import '../contracts/plugin_capability.dart';
import '../contracts/plugin_placement.dart';
import '../registry/plugin_registry.dart';
import 'main_tab_branch_plan.dart';

class MainTabBranchPlanner {
  final PluginRegistry registry;

  const MainTabBranchPlanner(this.registry);

  MainTabRoutePlan build({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final plugins = registry
      .enabledFor(PluginPlacement.mainTab, context: context)
      .where((plugin) => plugin.mainTabEntry != null)
      .toList(growable: false)..sort((a, b) {
      final orderCompare = a.mainTabEntry!.order.compareTo(
        b.mainTabEntry!.order,
      );
      if (orderCompare != 0) {
        return orderCompare;
      }
      return a.id.value.compareTo(b.id.value);
    });

    return MainTabRoutePlan([
      for (final plugin in plugins)
        MainTabBranchPlan(
          pluginId: plugin.id.value,
          entry: plugin.mainTabEntry!,
          route: plugin.routes.firstWhere(
            (route) => route.path == plugin.mainTabEntry!.route,
            orElse:
                () =>
                    throw StateError(
                      'Main tab plugin ${plugin.id.value} does not expose '
                      'route ${plugin.mainTabEntry!.route}.',
                    ),
          ),
          navigatorKey: GlobalKey<NavigatorState>(
            debugLabel:
                'branch:${plugin.id.value}:${plugin.mainTabEntry!.route}',
          ),
        ),
    ]);
  }
}

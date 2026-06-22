import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../plugin_platform/registry/plugin_registry.dart';
import '../plugin_platform/i18n/plugin_entry_localization_registry.dart';
import '../plugin_platform/routing/main_tab_branch_planner.dart';
import '../plugin_platform/routing/plugin_route_binder.dart';
import '../presentation/common/widgets/bottom_nav_shell.dart';

const _routeBinder = PluginRouteBinder();

GoRouter createRouter(
  PluginRegistry registry, {
  PluginEntryLocalizationRegistry? entryLocalizers,
}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root:navigator',
  );
  final visiblePlugins = registry.visible().toList(growable: false);
  final mainTabPlan = MainTabBranchPlanner(registry).build();
  final mainTabPluginIds =
      mainTabPlan.branches.map((branch) => branch.pluginId).toSet();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => BottomNavShell(
          shell: shell,
          tabs: mainTabPlan.tabs,
          entryLocalizers: entryLocalizers,
        ),
        branches: [
          for (final branch in mainTabPlan.branches)
            StatefulShellBranch(
              navigatorKey: branch.navigatorKey,
              routes: [
                _routeBinder.bind(
                  branch.route,
                ),
              ],
            ),
        ],
      ),
      ..._routeBinder.bindAll(
        visiblePlugins.where(
          (plugin) => !mainTabPluginIds.contains(plugin.id.value),
        ),
      ),
    ],
  );
}

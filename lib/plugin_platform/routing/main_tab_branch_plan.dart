import 'package:flutter/widgets.dart';

import '../contracts/plugin_entry.dart';
import '../contracts/plugin_route.dart';

class MainTabBranchPlan {
  final String pluginId;
  final MainTabPluginEntry entry;
  final PluginRoute route;
  final GlobalKey<NavigatorState> navigatorKey;

  const MainTabBranchPlan({
    required this.pluginId,
    required this.entry,
    required this.route,
    required this.navigatorKey,
  });
}

class MainTabRoutePlan {
  final List<MainTabBranchPlan> branches;

  const MainTabRoutePlan(this.branches);

  List<MainTabPluginEntry> get tabs =>
      branches.map((branch) => branch.entry).toList(growable: false);
}

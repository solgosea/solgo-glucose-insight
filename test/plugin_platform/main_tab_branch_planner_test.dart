import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/routing/main_tab_branch_planner.dart';
import 'package:smart_xdrip/plugins/builtin_plugins.dart';

void main() {
  test('main tab branch plan is the single source for shell tabs', () {
    final plan = MainTabBranchPlanner(builtInPluginRegistry).build();

    expect(plan.branches.map((branch) => branch.entry.route), [
      '/home',
      '/history',
      '/stats',
      '/explore',
      '/profile',
    ]);
    expect(
      plan.tabs.map((tab) => tab.route),
      plan.branches.map((branch) => branch.entry.route),
    );
  });

  test('main tab branch plan creates one navigator key per branch', () {
    final plan = MainTabBranchPlanner(builtInPluginRegistry).build();
    final keys = plan.branches.map((branch) => branch.navigatorKey).toList();

    expect(keys.toSet(), hasLength(keys.length));
    expect(plan.branches.map((branch) => branch.pluginId), [
      'core.home',
      'core.history',
      'core.statistics',
      'core.explore',
      'core.profile',
    ]);
  });
}

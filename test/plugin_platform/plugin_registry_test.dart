import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_capability.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_runtime_status.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/placement/background_task_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/placement/explore_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/placement/home_widget_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/placement/main_tab_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/placement/section_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry_builder.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_release_overrides.dart';
import 'package:smart_xdrip/plugins/builtin_plugins.dart';

void main() {
  test('main tab plugins resolve in shell order', () {
    final tabs = MainTabPluginResolver(builtInPluginRegistry).resolve();

    expect(tabs.map((tab) => tab.route), [
      '/home',
      '/history',
      '/stats',
      '/explore',
      '/profile',
    ]);
    expect(tabs.map((tab) => tab.label), [
      'Home',
      'History',
      'Stats',
      'Explore',
      'Profile',
    ]);
  });

  test('explore plugins resolve into release-ready sections', () {
    final sections = ExplorePluginResolver(builtInPluginRegistry).resolve();

    expect(sections.map((section) => section.title), ['EPISODES']);
    expect(
      sections.expand((section) => section.entries).map((entry) => entry.route),
      containsAll(['/explore/high-episode', '/explore/low-episode']),
    );
  });

  test('explore plugins resolve with runtime states', () {
    final sections = ExplorePluginResolver(
      builtInPluginRegistry,
    ).resolve(context: const PluginCapabilityContext(hasGlucoseData: false));

    final highEpisode = sections
        .expand((section) => section.resolvedEntries)
        .firstWhere((entry) => entry.entry.route == '/explore/high-episode');

    expect(highEpisode.state.status, PluginRuntimeStatus.noData);
    expect(highEpisode.state.enabled, isFalse);
  });

  test('profile sections are plugin controlled', () {
    final sections =
        SectionPluginResolver(
          registry: builtInPluginRegistry,
          placement: PluginPlacement.profileSection,
        ).resolve();

    expect(sections.map((section) => section.section), [
      'Data Source',
      'Target Range',
      'App Settings',
    ]);
  });

  test(
    'profile sections expose runtime states without changing section order',
    () {
      final sections = SectionPluginResolver(
        registry: builtInPluginRegistry,
        placement: PluginPlacement.profileSection,
      ).resolveWithState(
        context: const PluginCapabilityContext(hasConfiguredSource: false),
      );

      expect(sections.map((section) => section.entry.section), [
        'Data Source',
        'Target Range',
        'App Settings',
      ]);
      expect(
        sections
            .firstWhere((section) => section.entry.section == 'Data Source')
            .state
            .status,
        PluginRuntimeStatus.missingSource,
      );
    },
  );

  test('home widgets resolve in dashboard order', () {
    final widgets = HomeWidgetPluginResolver(builtInPluginRegistry).resolve();

    expect(widgets.map((widget) => widget.entry.widgetKey), [
      'home.header',
      'home.hero_glucose',
      'home.range_chart',
      'home.stats',
      'home.tir',
      'home.insight',
    ]);
  });

  test('settings sections are plugin controlled', () {
    final sections =
        SectionPluginResolver(
          registry: builtInPluginRegistry,
          placement: PluginPlacement.settingsSection,
        ).resolve();

    expect(sections.map((section) => section.section), [
      'Display',
      'Sync Settings',
      'Alerts',
      'Data Storage',
      'Data Export',
      'Danger Zone',
      'About',
    ]);
  });

  test('registry exposes plugin manifests', () {
    final manifests = builtInPluginRegistry.manifests;

    expect(
      manifests.map((manifest) => manifest.id.value),
      containsAll([
        'core.home',
        'home.header',
        'home.range_chart',
        'settings.display',
        'settings.sync',
        'profile.target_range',
        'core.alerting',
      ]),
    );
    expect(
      manifests
          .firstWhere((manifest) => manifest.id.value == 'settings.display')
          .placements,
      contains(PluginPlacement.settingsSection),
    );
  });

  test('background task plugins resolve in execution order', () {
    final tasks = BackgroundTaskPluginResolver(builtInPluginRegistry).resolve();

    expect(tasks.map((task) => task.taskKey), [
      'source.health_check',
      'glucose.sync',
    ]);
    expect(tasks.every((task) => task.foregroundService), isTrue);
  });

  test('plugin runtime state reports missing source for source tasks', () {
    final states = builtInPluginRegistry.runtimeStates(
      context: const PluginCapabilityContext(hasConfiguredSource: false),
    );

    final sourceHealth = states.firstWhere(
      (state) => state.pluginId.value == 'background.source_health',
    );
    final glucoseSync = states.firstWhere(
      (state) => state.pluginId.value == 'background.glucose_sync',
    );

    expect(sourceHealth.status, PluginRuntimeStatus.missingSource);
    expect(sourceHealth.enabled, isFalse);
    expect(glucoseSync.status, PluginRuntimeStatus.missingSource);
    expect(glucoseSync.enabled, isFalse);
  });

  test('plugin runtime state reports no data for episode detail plugins', () {
    final states = builtInPluginRegistry.runtimeStates(
      context: const PluginCapabilityContext(hasGlucoseData: false),
    );

    final highEpisode = states.firstWhere(
      (state) => state.pluginId.value == 'explore.high_episode',
    );

    expect(highEpisode.status, PluginRuntimeStatus.noData);
    expect(highEpisode.enabled, isFalse);
  });

  test('built-in plugin routes are unique', () {
    final routes =
        builtInFeaturePlugins
            .expand((plugin) => plugin.routes)
            .map((route) => route.path)
            .toList();

    expect(routes.toSet(), hasLength(routes.length));
  });

  test('insights plugin keeps legacy and canonical routes available', () {
    final routes = builtInPluginRegistry
        .visible()
        .expand((plugin) => plugin.routes)
        .map((route) => route.path);

    expect(routes, contains('/insight'));
    expect(routes, contains('/insights'));
  });

  test('release overrides can hide an episode plugin from launch surface', () {
    final registry = const PluginRegistryBuilder().build(
      plugins: builtInFeaturePlugins,
      releaseOverrides: const PluginReleaseOverrides(
        stages: {'explore.high_episode': PluginReleaseStage.hidden},
      ),
    );

    final sections = ExplorePluginResolver(registry).resolve();
    final routes = sections
        .expand((section) => section.entries)
        .map((entry) => entry.route);
    final visibleRoutes = registry.visible().expand((plugin) => plugin.routes);

    expect(routes, isNot(contains('/explore/high-episode')));
    expect(
      visibleRoutes.map((route) => route.path),
      isNot(contains('/explore/high-episode')),
    );
  });

  test('registry builder rejects duplicate plugin registration', () {
    expect(
      () => const PluginRegistryBuilder().build(
        plugins: [...builtInFeaturePlugins, builtInFeaturePlugins.first],
      ),
      throwsStateError,
    );
  });

  test('registry builder rejects duplicate main tab routes', () {
    expect(
      () => const PluginRegistryBuilder().build(
        plugins: const [
          _FakeMainTabPlugin(
            idValue: 'test.a',
            tabRoute: '/duplicate',
            routePath: '/duplicate',
            order: 0,
          ),
          _FakeMainTabPlugin(
            idValue: 'test.b',
            tabRoute: '/duplicate',
            routePath: '/duplicate-b',
            order: 10,
          ),
        ],
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('duplicate_main_tab_route'),
        ),
      ),
    );
  });

  test('registry builder rejects a main tab without matching route', () {
    expect(
      () => const PluginRegistryBuilder().build(
        plugins: const [
          _FakeMainTabPlugin(
            idValue: 'test.missing',
            tabRoute: '/missing',
            routePath: '/actual',
            order: 0,
          ),
        ],
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('missing_main_tab_route'),
        ),
      ),
    );
  });
}

class _FakeMainTabPlugin extends SmartFeaturePlugin {
  final String idValue;
  final String tabRoute;
  final String routePath;
  final int order;

  const _FakeMainTabPlugin({
    required this.idValue,
    required this.tabRoute,
    required this.routePath,
    required this.order,
  });

  @override
  PluginId get id => PluginId(idValue);

  @override
  String get title => idValue;

  @override
  String get description => idValue;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {};

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
    label: idValue,
    route: tabRoute,
    icon: Icons.circle_outlined,
    activeIcon: Icons.circle,
    order: order,
  );

  @override
  List<PluginRoute> get routes => [
    PluginRoute(path: routePath, builder: (_) => const SizedBox.shrink()),
  ];
}

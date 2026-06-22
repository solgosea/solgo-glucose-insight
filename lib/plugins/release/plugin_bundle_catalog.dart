import 'plugin_bundle.dart';

class PluginBundleCatalog {
  final List<PluginBundle> bundles;

  const PluginBundleCatalog({
    required this.bundles,
  });

  Set<String> pluginIdsFor(Set<String> bundleKeys) {
    final ids = <String>{};
    for (final bundle in bundles) {
      if (bundleKeys.contains(bundle.key)) {
        ids.addAll(bundle.pluginIds);
      }
    }
    return ids;
  }
}

const coreNavigationBundle = PluginBundle(
  key: 'core_navigation',
  pluginIds: {
    'core.home',
    'core.history',
    'core.statistics',
    'core.explore',
    'core.profile',
    'core.settings',
    'analysis.insights',
  },
);

const homeDashboardBundle = PluginBundle(
  key: 'home_dashboard',
  pluginIds: {
    'home.header',
    'home.hero_glucose',
    'home.range_chart',
    'home.stats',
    'home.tir',
    'home.insight',
  },
);

const profileBasicsBundle = PluginBundle(
  key: 'profile_basics',
  pluginIds: {
    'datasource.core',
    'profile.target_range',
    'glance.layer',
  },
);

const settingsBasicsBundle = PluginBundle(
  key: 'settings_basics',
  pluginIds: {
    'settings.display',
    'settings.sync',
    'settings.storage',
    'settings.export',
    'settings.danger',
    'settings.about',
  },
);

const analysisBasicBundle = PluginBundle(
  key: 'analysis_basic',
  pluginIds: {
    'explore.statusMonitor',
    'explore.report',
    'explore.high_episode',
    'explore.low_episode',
  },
);

const analysisAdvancedBundle = PluginBundle(
  key: 'analysis_advanced',
  pluginIds: {},
);

const connectedCareBundle = PluginBundle(
  key: 'connected_care',
  pluginIds: {
    'core.alerting',
  },
);

const wellnessBundle = PluginBundle(
  key: 'wellness',
  pluginIds: {},
);

const backgroundSyncBundle = PluginBundle(
  key: 'background_sync',
  pluginIds: {
    'background.source_health',
    'background.glucose_sync',
  },
);

const defaultPluginBundleCatalog = PluginBundleCatalog(
  bundles: [
    coreNavigationBundle,
    homeDashboardBundle,
    profileBasicsBundle,
    settingsBasicsBundle,
    analysisBasicBundle,
    analysisAdvancedBundle,
    connectedCareBundle,
    wellnessBundle,
    backgroundSyncBundle,
  ],
);

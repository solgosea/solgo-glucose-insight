import '../plugin_platform/registry/plugin_release_overrides.dart';
import 'plugin_catalog.dart';
import 'release/plugin_release_matrix.dart';
import 'release/plugin_release_matrix_resolver.dart';
import 'release/plugin_release_profile.dart';

const currentPluginReleaseProfile = PluginReleaseProfile.ossPreview;

const ossPreviewPluginReleaseMatrix = PluginReleaseMatrix(
  profile: PluginReleaseProfile.ossPreview,
  enabledBundles: {
    'core_navigation',
    'home_dashboard',
    'profile_basics',
    'settings_basics',
    'analysis_basic',
    'connected_care',
    'background_sync',
  },
  pluginOverrides: {},
);

const publicBetaPluginReleaseMatrix = PluginReleaseMatrix(
  profile: PluginReleaseProfile.publicBeta,
  enabledBundles: {
    'core_navigation',
    'home_dashboard',
    'profile_basics',
    'settings_basics',
    'analysis_basic',
    'analysis_advanced',
    'connected_care',
    'wellness',
    'background_sync',
  },
  pluginOverrides: {},
);

const fullInternalPluginReleaseMatrix = PluginReleaseMatrix(
  profile: PluginReleaseProfile.fullInternal,
  enabledBundles: {
    'core_navigation',
    'home_dashboard',
    'profile_basics',
    'settings_basics',
    'analysis_basic',
    'analysis_advanced',
    'connected_care',
    'wellness',
    'background_sync',
  },
  pluginOverrides: {},
);

const hackathonPluginReleaseMatrix = PluginReleaseMatrix(
  profile: PluginReleaseProfile.hackathon,
  enabledBundles: {
    'core_navigation',
    'home_dashboard',
    'profile_basics',
    'settings_basics',
    'analysis_basic',
    'analysis_advanced',
    'connected_care',
    'wellness',
    'background_sync',
  },
  pluginOverrides: {},
);

const pluginReleaseMatrices = {
  PluginReleaseProfile.ossPreview: ossPreviewPluginReleaseMatrix,
  PluginReleaseProfile.publicBeta: publicBetaPluginReleaseMatrix,
  PluginReleaseProfile.fullInternal: fullInternalPluginReleaseMatrix,
  PluginReleaseProfile.hackathon: hackathonPluginReleaseMatrix,
};

PluginReleaseMatrix get currentPluginReleaseMatrix =>
    pluginReleaseMatrices[currentPluginReleaseProfile] ??
    fullInternalPluginReleaseMatrix;

final PluginReleaseOverrides defaultPluginReleaseOverrides =
    const PluginReleaseMatrixResolver().resolve(
  plugins: pluginCatalog,
  matrix: currentPluginReleaseMatrix,
);

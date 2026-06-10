import '../contracts/plugin_placement.dart';
import '../contracts/smart_feature_plugin.dart';

class PluginRegistryValidationIssue {
  final String code;
  final String message;

  const PluginRegistryValidationIssue({
    required this.code,
    required this.message,
  });

  @override
  String toString() => '$code: $message';
}

class PluginRegistryValidationResult {
  final List<PluginRegistryValidationIssue> issues;

  const PluginRegistryValidationResult(this.issues);

  bool get isValid => issues.isEmpty;
}

class PluginRegistryValidator {
  const PluginRegistryValidator();

  PluginRegistryValidationResult validate(List<SmartFeaturePlugin> plugins) {
    final issues = <PluginRegistryValidationIssue>[];
    _validatePluginIds(plugins, issues);
    _validateRoutes(plugins, issues);
    _validatePlacements(plugins, issues);
    _validateMainTabRoutes(plugins, issues);
    return PluginRegistryValidationResult(issues);
  }

  void _validatePluginIds(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    final seen = <String>{};
    for (final plugin in plugins) {
      if (!seen.add(plugin.id.value)) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'duplicate_plugin_id',
            message: 'Duplicate plugin id: ${plugin.id.value}',
          ),
        );
      }
    }
  }

  void _validateRoutes(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    final seen = <String>{};
    for (final plugin in plugins) {
      for (final route in plugin.routes) {
        if (!seen.add(route.path)) {
          issues.add(
            PluginRegistryValidationIssue(
              code: 'duplicate_route',
              message: 'Duplicate route path: ${route.path}',
            ),
          );
        }
      }
    }
  }

  void _validatePlacements(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    for (final plugin in plugins) {
      if (plugin.placements.contains(PluginPlacement.mainTab) &&
          plugin.mainTabEntry == null) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_main_tab_entry',
            message: 'Main tab plugin ${plugin.id.value} has no tab entry.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.exploreCard) &&
          plugin.exploreEntry == null) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_explore_entry',
            message: 'Explore plugin ${plugin.id.value} has no explore entry.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.profileSection) &&
          plugin.profileEntry == null) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_profile_entry',
            message: 'Profile plugin ${plugin.id.value} has no profile entry.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.settingsSection) &&
          plugin.settingsEntry == null) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_settings_entry',
            message:
                'Settings plugin ${plugin.id.value} has no settings entry.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.homeWidget) &&
          plugin.homeWidgetEntry == null) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_home_widget_entry',
            message:
                'Home widget plugin ${plugin.id.value} has no widget entry.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.backgroundTask) &&
          plugin.backgroundTaskEntry == null) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_background_task_entry',
            message:
                'Background task plugin ${plugin.id.value} has no task entry.',
          ),
        );
      }
    }
  }

  void _validateMainTabRoutes(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    final seenRoutes = <String>{};
    for (final plugin in plugins) {
      if (!plugin.placements.contains(PluginPlacement.mainTab)) {
        continue;
      }
      final entry = plugin.mainTabEntry;
      if (entry == null) {
        continue;
      }
      if (!seenRoutes.add(entry.route)) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'duplicate_main_tab_route',
            message: 'Duplicate main tab route: ${entry.route}',
          ),
        );
      }
      if (!plugin.routes.any((route) => route.path == entry.route)) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_main_tab_route',
            message:
                'Main tab plugin ${plugin.id.value} does not expose route '
                '${entry.route}.',
          ),
        );
      }
    }
  }
}

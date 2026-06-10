import '../../../plugin_platform/placement/explore_plugin_resolver.dart';

class ExploreRuntimeSnapshot {
  final List<ExplorePluginSection> sections;
  final DateTime refreshedAt;
  final String reason;

  const ExploreRuntimeSnapshot({
    required this.sections,
    required this.refreshedAt,
    required this.reason,
  });
}

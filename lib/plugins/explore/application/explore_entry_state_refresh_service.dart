import '../../../plugin_platform/placement/explore_plugin_resolver.dart';
import '../../../plugin_platform/registry/plugin_registry.dart';
import '../runtime/explore_runtime_snapshot.dart';
import 'explore_entry_context_builder.dart';

class ExploreEntryStateRefreshService {
  final PluginRegistry registry;
  final ExploreEntryContextBuilder contextBuilder;
  final DateTime Function() now;

  const ExploreEntryStateRefreshService({
    required this.registry,
    required this.contextBuilder,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  ExploreRuntimeSnapshot refresh({required String reason}) {
    final context = contextBuilder.build();
    final sections = ExplorePluginResolver(registry).resolve(context: context);
    return ExploreRuntimeSnapshot(
      sections: sections,
      refreshedAt: now(),
      reason: reason,
    );
  }
}

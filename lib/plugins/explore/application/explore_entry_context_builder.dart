import '../../../plugin_platform/contracts/plugin_capability.dart';
import '../../../plugin_platform/runtime/plugin_capability_context_factory.dart';

class ExploreEntryContextBuilder {
  final PluginCapabilityContextFactory capabilityContextFactory;

  const ExploreEntryContextBuilder({required this.capabilityContextFactory});

  factory ExploreEntryContextBuilder.current() => ExploreEntryContextBuilder(
    capabilityContextFactory: PluginCapabilityContextFactory.current(),
  );

  PluginCapabilityContext build() => capabilityContextFactory.create();
}

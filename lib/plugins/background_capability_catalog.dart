import '../application/background_capability/background_capability_catalog.dart';
import '../application/background_capability/background_capability_contributor.dart';
import 'plugin_catalog.dart';

final builtInBackgroundCapabilityCatalog = BackgroundCapabilityCatalog(
  contributors:
      pluginCatalog
          .map((plugin) => plugin.backgroundCapabilityContributor)
          .whereType<BackgroundCapabilityContributor>(),
);

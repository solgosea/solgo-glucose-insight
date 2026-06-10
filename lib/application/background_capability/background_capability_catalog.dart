import 'background_capability_contributor.dart';
import 'background_capability_install_context.dart';

class BackgroundCapabilityCatalog {
  final List<BackgroundCapabilityContributor> _contributors;

  BackgroundCapabilityCatalog({
    Iterable<BackgroundCapabilityContributor> contributors = const [],
  }) : _contributors = List.unmodifiable(contributors);

  void installAll(BackgroundCapabilityInstallContext context) {
    for (final contributor in _contributors) {
      contributor.installBackgroundCapabilities(context);
    }
  }
}

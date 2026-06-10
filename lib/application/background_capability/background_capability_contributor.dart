import 'background_capability_install_context.dart';

abstract class BackgroundCapabilityContributor {
  String get pluginId;

  void installBackgroundCapabilities(
    BackgroundCapabilityInstallContext context,
  );
}

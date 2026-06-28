import 'method_channel_package_probe_bridge.dart';
import 'package_probe_snapshot.dart';

class PackageProbePlatformSource {
  final MethodChannelPackageProbeBridge bridge;

  const PackageProbePlatformSource({
    this.bridge = const MethodChannelPackageProbeBridge(),
  });

  Future<PackageProbeSnapshot> query(String packageName) {
    return bridge.query(packageName);
  }
}

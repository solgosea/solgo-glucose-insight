import 'device_probe_snapshot.dart';
import 'method_channel_device_probe_bridge.dart';

class DeviceProbePlatformSource {
  final MethodChannelDeviceProbeBridge bridge;

  const DeviceProbePlatformSource({
    this.bridge = const MethodChannelDeviceProbeBridge(),
  });

  Future<DeviceProbeSnapshot> query() => bridge.query();
}

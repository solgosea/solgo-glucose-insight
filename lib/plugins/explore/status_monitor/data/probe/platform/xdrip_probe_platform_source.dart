import '../../platform/xdrip/xdrip_broadcast_bridge.dart';
import '../../platform/xdrip/xdrip_broadcast_snapshot.dart';
import '../../platform/xdrip/method_channel_xdrip_broadcast_bridge.dart';

class XdripProbePlatformSource {
  final XdripBroadcastBridge bridge;

  const XdripProbePlatformSource({
    this.bridge = const MethodChannelXdripBroadcastBridge(),
  });

  Future<XdripBroadcastSnapshot> latestBroadcast() => bridge.latest();

  bool get isSupported => bridge.isSupported;
}

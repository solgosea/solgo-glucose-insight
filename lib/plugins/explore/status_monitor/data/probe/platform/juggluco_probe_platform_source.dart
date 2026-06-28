import '../../platform/juggluco/juggluco_broadcast_bridge.dart';
import '../../platform/juggluco/juggluco_broadcast_snapshot.dart';
import '../../platform/juggluco/method_channel_juggluco_broadcast_bridge.dart';

class JugglucoProbePlatformSource {
  final JugglucoBroadcastBridge bridge;

  const JugglucoProbePlatformSource({
    this.bridge = const MethodChannelJugglucoBroadcastBridge(),
  });

  Future<JugglucoBroadcastSnapshot> latestBroadcast() => bridge.latest();

  bool get isSupported => bridge.isSupported;
}

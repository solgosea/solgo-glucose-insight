import 'xdrip_broadcast_snapshot.dart';

abstract interface class XdripBroadcastBridge {
  bool get isSupported;

  Future<XdripBroadcastSnapshot> latest();
}

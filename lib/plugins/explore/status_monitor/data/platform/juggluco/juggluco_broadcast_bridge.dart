import 'juggluco_broadcast_snapshot.dart';

abstract interface class JugglucoBroadcastBridge {
  bool get isSupported;

  Future<JugglucoBroadcastSnapshot> latest();
}

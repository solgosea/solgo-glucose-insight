import 'package:flutter/services.dart';

import 'device_probe_snapshot.dart';

class MethodChannelDeviceProbeBridge {
  static const _channel =
      MethodChannel('com.metaguru.smartxdrip/status_probe_device');

  const MethodChannelDeviceProbeBridge();

  Future<DeviceProbeSnapshot> query() async {
    try {
      final raw = await _channel.invokeMapMethod<Object?, Object?>('query');
      if (raw == null) {
        return DeviceProbeSnapshot.unsupported('empty device probe response');
      }
      return DeviceProbeSnapshot.fromMap(raw);
    } catch (error) {
      return DeviceProbeSnapshot.unsupported(error);
    }
  }
}

import 'package:flutter/services.dart';

import 'package_probe_snapshot.dart';

class MethodChannelPackageProbeBridge {
  static const _channel =
      MethodChannel('com.metaguru.smartxdrip/status_probe_package');

  const MethodChannelPackageProbeBridge();

  Future<PackageProbeSnapshot> query(String packageName) async {
    try {
      final raw = await _channel.invokeMapMethod<Object?, Object?>(
        'query',
        {'packageName': packageName},
      );
      if (raw == null) {
        return PackageProbeSnapshot.unsupported(
          packageName,
          'empty package probe response',
        );
      }
      return PackageProbeSnapshot.fromMap(raw);
    } catch (error) {
      return PackageProbeSnapshot.unsupported(packageName, error);
    }
  }
}

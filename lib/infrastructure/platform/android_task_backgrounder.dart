import 'dart:io';

import 'package:flutter/services.dart';

class AndroidTaskBackgrounder {
  static const MethodChannel _channel = MethodChannel(
    'com.metaguru.smartxdrip/app_lifecycle',
  );

  const AndroidTaskBackgrounder();

  Future<bool> moveTaskToBack() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('moveTaskToBack') ?? false;
    } catch (_) {
      return false;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/widget/status_widget_snapshot.dart';
import 'status_monitor_android_widget_payload_mapper.dart';
import 'status_widget_platform_bridge.dart';
import 'status_ios_widget_payload_mapper.dart';

class MethodChannelStatusWidgetBridge implements StatusWidgetPlatformBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;
  final StatusMonitorAndroidWidgetPayloadMapper androidPayloadMapper;
  final StatusIosWidgetPayloadMapper iosPayloadMapper;

  const MethodChannelStatusWidgetBridge({
    this.channel =
        const MethodChannel('com.metaguru.smartxdrip/status_monitor_widget'),
    this.platform,
    this.androidPayloadMapper = const StatusMonitorAndroidWidgetPayloadMapper(),
    this.iosPayloadMapper = const StatusIosWidgetPayloadMapper(),
  });

  TargetPlatform get _platform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported =>
      _platform == TargetPlatform.android || _platform == TargetPlatform.iOS;

  @override
  Future<void> publish(StatusWidgetSnapshot snapshot) async {
    if (!isSupported) return;
    final payload = _platform == TargetPlatform.iOS
        ? iosPayloadMapper.sharedPayload(snapshot)
        : androidPayloadMapper.platformPayload(snapshot);
    await channel.invokeMethod<void>('publishSnapshot', payload);
  }
}

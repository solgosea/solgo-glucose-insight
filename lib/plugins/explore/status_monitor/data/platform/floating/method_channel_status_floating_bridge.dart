import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/floating/status_floating_payload.dart';
import '../../../domain/floating/status_floating_settings.dart';
import 'status_floating_platform_bridge.dart';

class MethodChannelStatusFloatingBridge
    implements StatusFloatingPlatformBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;

  const MethodChannelStatusFloatingBridge({
    this.channel = const MethodChannel(
      'com.metaguru.smartxdrip/status_monitor_floating',
    ),
    this.platform,
  });

  TargetPlatform get _currentPlatform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported => _currentPlatform == TargetPlatform.android;

  @override
  Future<bool> hasOverlayPermission() async {
    if (!isSupported) return false;
    return await channel.invokeMethod<bool>('hasOverlayPermission') ?? false;
  }

  @override
  Future<void> requestOverlayPermission() async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('requestOverlayPermission');
  }

  @override
  Future<void> start({
    required StatusFloatingSettings settings,
    required StatusFloatingPayload payload,
  }) async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('start', _arguments(settings, payload));
  }

  @override
  Future<void> update({
    required StatusFloatingSettings settings,
    required StatusFloatingPayload payload,
  }) async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('update', _arguments(settings, payload));
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('stop');
  }

  Map<String, Object?> _arguments(
    StatusFloatingSettings settings,
    StatusFloatingPayload payload,
  ) {
    return {
      'mode': settings.mode.code,
      'collapsed': settings.collapsed,
      ...payload.toMap(),
    };
  }
}

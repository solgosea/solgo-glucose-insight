import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/floating/floating_glance_settings.dart';
import '../../../domain/glance_snapshot.dart';
import 'floating_glance_platform_bridge.dart';

class MethodChannelFloatingGlanceBridge
    implements FloatingGlancePlatformBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;

  const MethodChannelFloatingGlanceBridge({
    this.channel =
        const MethodChannel('com.metaguru.smartxdrip/floating_glance'),
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
    required FloatingGlanceSettings settings,
    required GlanceSnapshot snapshot,
  }) async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('start', _arguments(settings, snapshot));
  }

  @override
  Future<void> update({
    required FloatingGlanceSettings settings,
    required GlanceSnapshot snapshot,
  }) async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('update', _arguments(settings, snapshot));
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('stop');
  }

  Map<String, Object?> _arguments(
    FloatingGlanceSettings settings,
    GlanceSnapshot snapshot,
  ) {
    return {
      'mode': settings.mode.code,
      'displayStyle': settings.displayStyle.code,
      'collapsed': settings.collapsed,
      'valueLabel': snapshot.valueLabel,
      'unitLabel': snapshot.unitLabel,
      'trendArrow': snapshot.trendArrow,
      'deltaLabel': snapshot.deltaLabel,
      'freshnessLabel': snapshot.freshness.label,
      'rangeState': snapshot.rangeState.code,
      'hasReading': snapshot.hasReading,
      'sourceLabel': snapshot.sourceLabel,
      'isStale': snapshot.freshness.isStale,
    };
  }
}

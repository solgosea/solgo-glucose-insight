import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../application/floating_surface/floating_surface_action.dart';
import '../../../application/floating_surface/floating_surface_payload.dart';
import 'floating_surface_platform_bridge.dart';

class MethodChannelFloatingSurfaceBridge
    implements FloatingSurfacePlatformBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;
  final StreamController<FloatingSurfaceAction> _actionsController =
      StreamController<FloatingSurfaceAction>.broadcast();

  MethodChannelFloatingSurfaceBridge({
    this.channel = const MethodChannel(
      'com.metaguru.smartxdrip/floating_surface',
    ),
    this.platform,
  }) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  TargetPlatform get _currentPlatform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported => _currentPlatform == TargetPlatform.android;

  @override
  Stream<FloatingSurfaceAction> get actions => _actionsController.stream;

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
  Future<void> update(FloatingSurfacePayload payload) async {
    if (!isSupported) return;
    if (payload.isEmpty) {
      await stop();
      return;
    }
    await channel.invokeMethod<void>('update', payload.toMap());
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    await channel.invokeMethod<void>('stop');
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method != 'nativeAction') return null;
    final arguments = call.arguments;
    if (arguments is! Map) return null;
    _actionsController.add(FloatingSurfaceAction.fromMap(arguments));
    return true;
  }
}

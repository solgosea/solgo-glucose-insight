import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../application/render/glance_render_payload_builder.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/render/glance_render_payload.dart';
import '../sqlite/sqlite_glance_settings_repository.dart';
import '../sqlite/sqlite_glance_widget_config_repository.dart';
import 'glance_android_widget_payload_mapper.dart';
import 'glance_ios_widget_payload_mapper.dart';
import 'glance_widget_platform_bridge.dart';

class MethodChannelGlanceWidgetBridge implements GlanceWidgetPlatformBridge {
  final MethodChannel channel;
  final GlanceRenderPayloadBuilder payloadBuilder;
  final GlanceAndroidWidgetPayloadMapper androidPayloadMapper;
  final GlanceIosWidgetPayloadMapper iosPayloadMapper;
  final Future<GlanceNotificationSettings> Function()? settingsProvider;
  final TargetPlatform? platform;

  const MethodChannelGlanceWidgetBridge({
    this.channel = const MethodChannel('com.metaguru.smartxdrip/glance_widget'),
    this.payloadBuilder = const GlanceRenderPayloadBuilder(),
    this.androidPayloadMapper = const GlanceAndroidWidgetPayloadMapper(),
    this.iosPayloadMapper = const GlanceIosWidgetPayloadMapper(),
    this.settingsProvider,
    this.platform,
  });

  TargetPlatform get _currentPlatform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported =>
      _currentPlatform == TargetPlatform.android ||
      _currentPlatform == TargetPlatform.iOS;

  @override
  Future<void> publishSnapshot(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>(
      'publishSnapshot',
      await _snapshotArguments(payload),
    );
  }

  @override
  Future<void> publishConfig(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>(
      'publishConfig',
      await _configArguments(payload),
    );
  }

  @override
  Future<void> updateAll(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>(
      'updateAll',
      await _snapshotArguments(payload),
    );
  }

  @override
  Future<void> updateWidget(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    final configArguments = await _configArguments(payload);
    final snapshotArguments = await _snapshotArguments(payload);
    await channel.invokeMethod<void>('updateWidget', {
      'config': configArguments,
      'snapshot': snapshotArguments,
    });
  }

  Future<Map<String, Object?>> _snapshotArguments(
    GlanceRenderPayload payload,
  ) async {
    if (_currentPlatform == TargetPlatform.iOS) {
      return iosPayloadMapper.sharedPayload(
        payload,
        settings: await _settings(),
      );
    }
    return androidPayloadMapper.snapshot(payload);
  }

  Future<Map<String, Object?>> _configArguments(
    GlanceRenderPayload payload,
  ) async {
    if (_currentPlatform == TargetPlatform.iOS) {
      return iosPayloadMapper.sharedPayload(
        payload,
        settings: await _settings(),
      );
    }
    return androidPayloadMapper.config(payload);
  }

  Future<GlanceNotificationSettings> _settings() async {
    final provider = settingsProvider;
    if (provider == null) return const GlanceNotificationSettings();
    return provider();
  }
}

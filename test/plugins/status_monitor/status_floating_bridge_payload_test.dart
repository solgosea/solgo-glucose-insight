import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/floating/method_channel_status_floating_bridge.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/floating/status_floating_component_payload.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/floating/status_floating_payload.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/floating/status_floating_settings.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelName = 'test/status_monitor_floating';
  const channel = MethodChannel(channelName);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('status floating update does not overwrite native drag position',
      () async {
    MethodCall? capturedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      capturedCall = call;
      return true;
    });

    const bridge = MethodChannelStatusFloatingBridge(
      channel: channel,
      platform: TargetPlatform.android,
    );

    await bridge.update(
      settings: StatusFloatingSettings.defaults(),
      payload: _payload(),
    );

    final arguments = capturedCall!.arguments as Map<Object?, Object?>;
    expect(capturedCall!.method, 'update');
    expect(arguments.containsKey('x'), isFalse);
    expect(arguments.containsKey('y'), isFalse);
    expect(arguments['headline'], 'All links are healthy');
  });
}

StatusFloatingPayload _payload() {
  return const StatusFloatingPayload(
    headline: 'All links are healthy',
    freshnessLabel: 'Updated now',
    level: StatusLevel.healthy,
    hasConfiguredSource: true,
    isStale: false,
    components: [
      StatusFloatingComponentPayload(
        label: 'Sensor',
        level: StatusLevel.healthy,
        glyph: '\u25CF',
        score: 92,
        scoreLabel: '92',
      ),
      StatusFloatingComponentPayload(
        label: 'xDrip+',
        level: StatusLevel.watch,
        glyph: '\u25B2',
        score: 78,
        scoreLabel: '78',
      ),
      StatusFloatingComponentPayload(
        label: 'Nightscout',
        level: StatusLevel.healthy,
        glyph: '\u25CF',
        score: 95,
        scoreLabel: '95',
      ),
      StatusFloatingComponentPayload(
        label: 'AAPS',
        level: StatusLevel.unknown,
        glyph: '\u25CB',
        score: 66,
        scoreLabel: '66',
      ),
    ],
  );
}

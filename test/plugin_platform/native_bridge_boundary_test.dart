import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MainActivity delegates native plugin bridge registration', () {
    final root = Directory.current;
    final mainActivity = File(
      '${root.path}/android/app/src/main/kotlin/com/metaguru/smartxdrip/MainActivity.kt',
    );
    final content = mainActivity.readAsStringSync();

    expect(content, contains('NativeBridgeRegistry.configure'));
    expect(content, isNot(contains('com.metaguru.smartxdrip.glance.')));
    expect(content, isNot(contains('com.metaguru.smartxdrip.statusmonitor.')));
    expect(content, isNot(contains('MethodChannel(')));
  });

  test('native plugin bridges are centralized in NativeBridgeRegistry', () {
    final root = Directory.current;
    final platformDir = Directory(
      '${root.path}/android/app/src/main/kotlin/com/metaguru/smartxdrip/platform',
    );
    final registry = File('${platformDir.path}/NativeBridgeRegistry.kt');
    final registryContent = registry.readAsStringSync();

    for (final bridgeName in const [
      'GlanceWidgetBridge',
      'StatusMonitorWidgetBridge',
      'FloatingSurfaceBridge',
    ]) {
      expect(registryContent, contains(bridgeName));
    }
    expect(registryContent, isNot(contains('FloatingGlanceBridge')));
    expect(registryContent, isNot(contains('StatusFloatingBridge')));

    final androidFiles = Directory(
      '${root.path}/android/app/src/main/kotlin/com/metaguru/smartxdrip',
    ).listSync(recursive: true).whereType<File>().where((file) {
      final path = file.path.replaceAll('\\', '/');
      return path.endsWith('.kt') &&
          !path.endsWith('/platform/NativeBridgeRegistry.kt') &&
          !path.endsWith('/floating/FloatingSurfaceBridge.kt') &&
          !path.contains('/glance/') &&
          !path.contains('/statusmonitor/');
    });

    final violations = <String>[];
    for (final file in androidFiles) {
      final content = file.readAsStringSync();
      if (content.contains('GlanceWidgetBridge') ||
          content.contains('StatusMonitorWidgetBridge') ||
          content.contains('FloatingSurfaceBridge')) {
        violations.add(file.path);
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

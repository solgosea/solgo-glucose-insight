import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const root = 'lib/plugins/explore/status_monitor';

  test('status monitor detail bodies stay as section composers', () {
    for (final path in [
      '$root/presentation/xdrip/widgets/xdrip_detail_body.dart',
      '$root/presentation/nightscout/widgets/nightscout_detail_body.dart',
      '$root/presentation/aaps/widgets/aaps_detail_body.dart',
    ]) {
      final content = File(path).readAsStringSync();
      expect(content.length, lessThan(4500), reason: path);
      expect(content, isNot(contains('class _ResponseBar')));
      expect(content, isNot(contains('class _MatrixRow')));
      expect(content, isNot(contains('class _FreshnessTimeline')));
      expect(content, isNot(contains('class _CompletenessHeat')));
    }
  });

  test('status monitor detail presentation does not import lower layers', () {
    final files = Directory('$root/presentation')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    for (final file in files) {
      final content = file.readAsStringSync();
      expect(content, isNot(contains('/application/rules/')),
          reason: file.path);
      expect(content, isNot(contains('/application/probes/')),
          reason: file.path);
      expect(content, isNot(contains('/data/sources/')), reason: file.path);
      expect(content, isNot(contains('package:dio/')), reason: file.path);
    }
  });
}

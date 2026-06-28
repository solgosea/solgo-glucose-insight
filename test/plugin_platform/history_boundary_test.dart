import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('history architecture keeps engine, mapper, and UI boundaries separated',
      () {
    final root = Directory('lib/plugins/history');
    expect(root.existsSync(), isTrue);
    expect(Directory('${root.path}/analyzers').existsSync(), isFalse);

    for (final file in _dartFiles(Directory('${root.path}/widgets'))) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('/engine/')));
      expect(source, isNot(contains('AnalysisFacade')));
    }

    for (final file in _dartFiles(Directory('${root.path}/engine'))) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('package:flutter')));
      expect(source, isNot(contains('/widgets/')));
      expect(source, isNot(contains('/mappers/')));
    }

    final allHistorySource =
        _dartFiles(root).map((file) => file.readAsStringSync()).join('\n');
    expect(allHistorySource, isNot(contains('/calendar_' 'heatmap/')));
    expect(allHistorySource, isNot(contains('/period_' 'analysis/')));
    expect(allHistorySource, isNot(contains('/status_monitor/')));
  });
}

Iterable<File> _dartFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      yield entity;
    }
  }
}

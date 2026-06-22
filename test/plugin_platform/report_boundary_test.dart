import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('report architecture stays section-first and layered', () {
    final root = Directory('lib/plugins/explore/report');
    expect(root.existsSync(), isTrue);

    final analyzerDir = Directory('lib/plugins/explore/report/analyzers');
    expect(analyzerDir.existsSync(), isFalse);

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
      expect(source, isNot(contains('/pdf/')));
    }

    final allReportSource =
        _dartFiles(root).map((file) => file.readAsStringSync()).join('\n');
    expect(allReportSource, isNot(contains('/calendar_heatmap/')));
    expect(allReportSource, isNot(contains('/period_analysis/')));
    expect(allReportSource, isNot(contains('/status_monitor/')));
    expect(allReportSource, isNot(contains('/agp_detail/')));
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

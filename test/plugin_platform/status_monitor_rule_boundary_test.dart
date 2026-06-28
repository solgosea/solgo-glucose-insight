import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final retiredSingleSourceTerms = <String>[
    'StatusSource' 'Snapshot',
    'StatusSource' 'Probe',
    'leg' 'acy' 'Source',
    'leg' 'acy' 'SourceProbe',
    'readings' '24h',
    'status_source_' 'snapshot',
    'status_source_' 'probe',
    'context.' 'source',
    'context.readings' '24h',
  ];

  test('status monitor rules, datasets, and presentation stay separated', () {
    final root = Directory.current;
    final files =
        root.listSync(recursive: true).whereType<File>().where((file) {
      final path = file.path.replaceAll('\\', '/');
      return path.endsWith('.dart') &&
          path.contains('/lib/plugins/explore/status_monitor/') &&
          !path.contains('/build/');
    }).toList(growable: false);

    final violations = <String>[];
    for (final file in files) {
      final path = file.path.replaceAll('\\', '/');
      final content = file.readAsStringSync();

      final isPresentation = path.contains('/presentation/');
      if (isPresentation &&
          (content.contains('/application/rules/') ||
              content.contains('/application/rule_engine/') ||
              content.contains('/data/sources/status_') ||
              content.contains('_calculator.dart'))) {
        violations.add('$path imports rule/source/calculator internals.');
      }

      if (path.contains('/application/rules/') &&
          (content.contains("package:flutter/") ||
              content.contains('/presentation/') ||
              content.contains('/widgets/') ||
              content.contains('/pages/'))) {
        violations.add('$path mixes rule logic with UI concerns.');
      }

      if (path.contains('/application/rule_engine/') &&
          (content.contains("package:flutter/") ||
              content.contains('/presentation/') ||
              content.contains('/widgets/') ||
              content.contains('/pages/'))) {
        violations.add('$path mixes rule engine logic with UI concerns.');
      }

      final lower = content.toLowerCase();
      if (lower.contains('/plugins/datasource/') ||
          lower.contains('/plugins/glance/') ||
          lower.contains('/plugins/explore/' 'follow/') ||
          lower.contains('/plugins/' 'messaging/') ||
          lower.contains('/alerting/')) {
        violations.add('$path imports another business plugin internals.');
      }

      for (final term in retiredSingleSourceTerms) {
        if (content.contains(term)) {
          violations
              .add('$path still references retired single-source term $term.');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

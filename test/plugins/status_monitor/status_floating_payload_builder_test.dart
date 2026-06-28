import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/floating/status_floating_payload_builder.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/scoring/status_component_score.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';

void main() {
  const builder = StatusFloatingPayloadBuilder();

  test('maps component scores, levels, glyphs and short names', () {
    final now = DateTime(2026, 1, 1, 12);
    final payload = builder.build(
      report: _report(
        generatedAt: now,
        cgm: StatusLevel.healthy,
        juggluco: StatusLevel.healthy,
        xdrip: StatusLevel.watch,
        nightscout: StatusLevel.issue,
        aaps: StatusLevel.watch,
        watch: StatusLevel.healthy,
      ),
      now: now,
    );

    expect(payload.components.map((component) => component.label), [
      'Sensor',
      'Juggluco',
      'xDrip+',
      'Nightscout',
      'AAPS',
      'Watch',
    ]);
    expect(payload.components.map((component) => component.glyph), [
      '\u25CF',
      '\u25CF',
      '\u25B2',
      '\u25A0',
      '\u25B2',
      '\u25CF',
    ]);
    expect(payload.components.map((component) => component.scoreLabel), [
      '92',
      '88',
      '78',
      '45',
      '66',
      '90',
    ]);
  });

  test('stale and missing source are explicit in floating payload', () {
    final now = DateTime(2026, 1, 1, 12);
    final stale = builder.build(
      report: _report(
        generatedAt: now.subtract(const Duration(minutes: 20)),
        cgm: StatusLevel.healthy,
        juggluco: StatusLevel.healthy,
        xdrip: StatusLevel.healthy,
        nightscout: StatusLevel.healthy,
        aaps: StatusLevel.healthy,
        watch: StatusLevel.healthy,
      ),
      now: now,
    );
    final noSource = builder.build(
      report: _report(
        generatedAt: now,
        cgm: StatusLevel.unknown,
        juggluco: StatusLevel.unknown,
        xdrip: StatusLevel.unknown,
        nightscout: StatusLevel.unknown,
        aaps: StatusLevel.unknown,
        watch: StatusLevel.unknown,
        hasConfiguredSource: false,
      ),
      now: now,
    );

    expect(stale.isStale, isTrue);
    expect(stale.headline, 'No recent status');
    expect(noSource.hasConfiguredSource, isFalse);
    expect(noSource.headline, 'Status unavailable');
  });
}

StatusReport _report({
  required DateTime generatedAt,
  required StatusLevel cgm,
  required StatusLevel juggluco,
  required StatusLevel xdrip,
  required StatusLevel nightscout,
  required StatusLevel aaps,
  required StatusLevel watch,
  bool hasConfiguredSource = true,
}) {
  final level = [cgm, juggluco, xdrip, nightscout, aaps, watch].reduce(
    (a, b) => a.severity >= b.severity ? a : b,
  );
  return StatusReport(
    subjectId: 'self',
    sourceKind: 'nightscout',
    sourceLabel: 'Nightscout',
    generatedAt: generatedAt,
    hasConfiguredSource: hasConfiguredSource,
    summary: StatusSummary(
      level: level,
      headline: level == StatusLevel.healthy
          ? 'All links are healthy'
          : '${level.label} status',
      body: 'Status summary',
      meta: '6 components',
      healthyCount: 0,
      totalCount: 6,
    ),
    components: [
      _component(StatusComponentKind.cgmSensor, cgm),
      _component(StatusComponentKind.juggluco, juggluco),
      _component(StatusComponentKind.xdrip, xdrip),
      _component(StatusComponentKind.nightscout, nightscout),
      _component(StatusComponentKind.aapsLoop, aaps),
      _component(StatusComponentKind.watchDisplay, watch),
    ],
    recentEvents: const [],
    capabilities: hasConfiguredSource
        ? const StatusSourceCapabilities.nightscout()
        : const StatusSourceCapabilities.none(),
  );
}

ComponentHealth _component(StatusComponentKind kind, StatusLevel level) {
  return ComponentHealth(
    kind: kind,
    level: level,
    title: kind.title,
    role: kind.role,
    takeaway: '${kind.title} ${level.label}',
    summary: '${kind.title} status',
    metrics: const [],
    score: level == StatusLevel.unknown
        ? null
        : StatusComponentScore(
            value: switch (kind) {
              StatusComponentKind.cgmSensor => 92,
              StatusComponentKind.juggluco => 88,
              StatusComponentKind.xdrip => 78,
              StatusComponentKind.nightscout => 45,
              StatusComponentKind.aapsLoop => 66,
              StatusComponentKind.watchDisplay => 90,
            },
            label: 'Score',
            confidence: 1,
            availableSignals: 3,
            totalSignals: 3,
          ),
  );
}

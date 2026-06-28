import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/watch/watch_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_evidence/status_component_evidence_bundle.dart'
    as component;
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_evidence/status_component_evidence_fact.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_evidence/status_component_evidence_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_evidence/status_component_evidence_source_ref.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_evidence/status_component_evidence_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/watch/watch_detail_data.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('marks watch display unknown when no probe evidence exists', () async {
    final context = const FakeStatusRuleContextFactory().build();

    final component = await const WatchStatusEngine().evaluate(context);

    expect(component.kind, StatusComponentKind.watchDisplay);
    expect(component.level, StatusLevel.unknown);
    expect(component.score?.availableSignals, 0);
    expect(component.score?.totalSignals, 4);
    expect(component.metrics, hasLength(4));
    expect(component.metrics.every((metric) => !metric.available), isTrue);
    expect(component.detailData, isA<WatchDetailData>());
  });

  test('builds watch display metrics and detail data from component evidence',
      () async {
    final now = DateTime.utc(2026, 6, 28, 9, 30);
    final base = const FakeStatusRuleContextFactory().build(now: now);
    final context = StatusAnalysisContext(
      now: now,
      evidence: base.evidence,
      componentEvidence: component.StatusComponentEvidenceBundle(
        subjectId: 'test',
        generatedAt: now,
        statusEvidence: base.evidence,
        snapshots: [
          StatusComponentEvidenceSnapshot(
            kind: StatusComponentKind.watchDisplay,
            state: StatusComponentEvidenceState.healthy,
            latestObservedAt: now.subtract(const Duration(seconds: 20)),
            confidence: 0.92,
            facts: [
              _fact(
                id: 'watch.bridge.package',
                label: 'Watch bridge app',
                valueLabel: 'Installed',
                observedAt: now.subtract(const Duration(minutes: 2)),
              ),
              _fact(
                id: 'watch.xdrip_web_service.reachable',
                label: 'xDrip+ Web Service',
                valueLabel: 'Reachable',
                observedAt: now.subtract(const Duration(seconds: 40)),
              ),
              _fact(
                id: 'watch.xdrip_web_service.entries',
                label: 'xDrip+ entries',
                valueLabel: 'Fresh',
                observedAt: now.subtract(const Duration(seconds: 30)),
              ),
              _fact(
                id: 'watch.display.evidence',
                label: 'Watch display evidence',
                valueLabel: 'Observed',
                observedAt: now.subtract(const Duration(seconds: 20)),
              ),
            ],
          ),
        ],
      ),
    );

    final componentHealth = await const WatchStatusEngine().evaluate(context);

    expect(componentHealth.level, StatusLevel.healthy);
    expect(componentHealth.score?.value, 100);
    expect(componentHealth.score?.availableSignals, 4);
    expect(componentHealth.metrics.map((metric) => metric.id), [
      'watch.bridge.package',
      'watch.xdrip_web_service.reachable',
      'watch.xdrip_web_service.entries',
      'watch.display.evidence',
    ]);
    expect(componentHealth.metrics.every((metric) => metric.available), isTrue);

    final detail = componentHealth.detailData! as WatchDetailData;
    expect(detail.pathChecks, hasLength(4));
    expect(detail.signals, hasLength(4));
    expect(detail.latestWatchEvidenceLabel, 'Yes');
  });
}

StatusComponentEvidenceFact _fact({
  required String id,
  required String label,
  required String valueLabel,
  required DateTime observedAt,
}) {
  return StatusComponentEvidenceFact(
    id: id,
    label: label,
    valueLabel: valueLabel,
    state: StatusComponentEvidenceState.healthy,
    observedAt: observedAt,
    confidence: 0.9,
    source: StatusComponentEvidenceSourceRef.probe(probeId: id),
  );
}

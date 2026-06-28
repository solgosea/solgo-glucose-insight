import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/status_hub_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/status_hub_engine_input.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_enums.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_models.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/hub/mappers/status_hub_view_model_mapper.dart';

import '_status_monitor_hub_fixtures.dart';

void main() {
  test('hub report matches xDrip hub HTML information structure', () {
    const engine = StatusHubEngine();
    const mapper = StatusHubViewModelMapper();
    final output = engine.run(
      StatusHubEngineInput(
        facts: hubTestFacts(now: DateTime(2026, 6, 18, 9, 41)),
      ),
    );
    final vm = mapper.map(output.report);

    expect(vm.summary.headline, contains('xDrip+'));
    expect(vm.focus.headline, isNotEmpty);
    expect(vm.topology.title, 'xDrip-centered connection map');
    expect(vm.nodes.map((node) => node.id), contains(StatusHubNodeId.watch));
    expect(vm.connections.map((connection) => connection.id),
        contains(StatusHubConnectionId.xdripToWatch));
    expect(vm.detailConnections, hasLength(5));
    expect(
      vm.detailConnections.map((connection) => connection.id),
      orderedEquals([
        StatusHubConnectionId.cgmToXdrip,
        StatusHubConnectionId.jugglucoToXdrip,
        StatusHubConnectionId.xdripToNightscout,
        StatusHubConnectionId.xdripToAaps,
        StatusHubConnectionId.xdripToWatch,
      ]),
    );
    expect(vm.observerNote.body, contains('Solgo Insight observes'));
    expect(vm.disclaimer, contains('observable evidence'));
    final metricLabels = vm.detailConnections
        .map((connection) =>
            connection.metrics.map((metric) => metric.label).toList())
        .toList();
    expect(
        metricLabels[0],
        orderedEquals(
          [
            'Latest BG age',
            '24h completeness',
            'Largest gap',
            'BG broadcast',
            'Receiver package',
          ],
        ));
    expect(
        metricLabels[1],
        orderedEquals(
          [
            'Juggluco broadcast age',
            'xDrip-compatible broadcast',
            'Format compatibility',
            'Receiver target',
            'Handoff alignment',
          ],
        ));
    expect(
        metricLabels[2],
        orderedEquals(
          [
            'Cloud reading age',
            'Local vs cloud delay',
            'API status',
            'Entries endpoint',
            'Response time',
            'Device status',
          ],
        ));
    expect(
        metricLabels[3],
        orderedEquals(
          [
            'BG source',
            'Loop context age',
            'Device status age',
            'Context fields',
            'Downstream alignment',
          ],
        ));
    expect(
        metricLabels[4],
        orderedEquals(
          [
            'xDrip+',
            'Watch',
            'Delay',
            'Evidence',
          ],
        ));
    for (final connection in vm.detailConnections) {
      expect(connection.metrics, isNotEmpty);
      for (final metric in connection.metrics) {
        expect(metric.targetLabel, isNotEmpty);
        expect(metric.normalizedScore, isNotNull);
        expect(metric.stars, isNotNull);
      }
    }
  });

  test('hub dynamic fields carry source references', () {
    const engine = StatusHubEngine();
    final report = engine
        .run(
          StatusHubEngineInput(
            facts: hubTestFacts(now: DateTime(2026, 6, 18, 9, 41)),
          ),
        )
        .report;

    expect(report.summary.source.kind, StatusHubSourceKind.derivedPolicy);
    expect(report.focus.source.kind, StatusHubSourceKind.derivedPolicy);
    for (final node in report.nodes) {
      expect(node.source.kind, isNot(StatusHubSourceKind.unavailable));
    }
    for (final connection in report.connections) {
      expect(
        connection.stateSource.kind,
        StatusHubSourceKind.derivedPolicy,
      );
      expect(connection.metrics, isNotEmpty);
      for (final metric in connection.metrics) {
        expect(metric.source.kind, isNot(StatusHubSourceKind.staticCopy));
      }
      for (final evidence in connection.evidence) {
        expect(evidence.source.kind, isNot(StatusHubSourceKind.staticCopy));
      }
    }
  });

  test('AAPS hub path uses BG source evidence, not xDrip Web Server', () {
    const engine = StatusHubEngine();
    final report = engine
        .run(
          StatusHubEngineInput(
            facts: hubTestFacts(now: DateTime(2026, 6, 18, 9, 41)),
          ),
        )
        .report;
    final connection = report.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.xdripToAaps,
    );

    expect(connection.nextCheck, contains('BG source is xDrip+'));
    expect(connection.nextCheck, contains('Web Server is optional'));
    expect(
      connection.evidence.map((item) => item.id),
      contains('aaps_xdrip_bg_source'),
    );
    expect(
      connection.evidence
          .firstWhere((item) => item.id == 'aaps_xdrip_bg_source')
          .source
          .kind,
      StatusHubSourceKind.probeEvidence,
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/status_hub_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/status_hub_engine_input.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_enums.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/hub/mappers/status_hub_view_model_mapper.dart';

import '_status_monitor_hub_fixtures.dart';

void main() {
  test('xDrip fresh and Nightscout stale focuses cloud upload path', () {
    const engine = StatusHubEngine();
    final now = DateTime(2026, 6, 18, 12);
    final facts = hubTestFacts(
      now: now,
      nightscoutAge: const Duration(minutes: 28),
    );

    final hub = engine.run(StatusHubEngineInput(facts: facts)).report;

    expect(hub.focus.connectionId, StatusHubConnectionId.xdripToNightscout);
    expect(hub.focus.reason, StatusHubFocusReason.targetDelayedVsSource);
    final cloud = hub.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.xdripToNightscout,
    );
    expect(cloud.diagnosisReason, StatusHubPathDiagnosisReason.uploadDelayed);
    expect(cloud.diagnosisPriority, greaterThan(0));
  });

  test('Juggluco fresh without xDrip-compatible path focuses handoff', () {
    const engine = StatusHubEngine();
    final now = DateTime(2026, 6, 18, 12);
    final facts = hubTestFacts(
      now: now,
      jugglucoCompatible: false,
      jugglucoObservedPath: 'direct',
      xdripAge: const Duration(minutes: 25),
    );

    final hub = engine.run(StatusHubEngineInput(facts: facts)).report;

    expect(hub.focus.connectionId, StatusHubConnectionId.jugglucoToXdrip);
    final handoff = hub.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.jugglucoToXdrip,
    );
    expect(
      handoff.diagnosisReason,
      StatusHubPathDiagnosisReason.compatiblePathMissing,
    );
  });

  test('Juggluco not-seen broadcast cannot produce a fresh connection', () {
    const engine = StatusHubEngine();
    final now = DateTime(2026, 6, 18, 12);
    final facts = hubTestFacts(
      now: now,
      jugglucoCompatible: true,
      jugglucoObservedPath: 'Not seen',
    );

    final hub = engine.run(StatusHubEngineInput(facts: facts)).report;
    final connection = hub.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.jugglucoToXdrip,
    );

    expect(connection.state, isNot(StatusHubState.fresh));
    expect(connection.state, StatusHubState.limited);
    expect(connection.pathScore.overallScore, lessThanOrEqualTo(64));
  });

  test('Juggluco waiting broadcast metric cannot produce a fresh connection',
      () {
    const engine = StatusHubEngine();
    final now = DateTime(2026, 6, 18, 12);
    final facts = hubTestFacts(
      now: now,
      jugglucoCompatible: true,
      jugglucoObservedPath: 'xDrip+',
      jugglucoBroadcastValue: 'Waiting',
    );

    final hub = engine.run(StatusHubEngineInput(facts: facts)).report;
    final connection = hub.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.jugglucoToXdrip,
    );

    expect(connection.metrics.first.valueLabel, 'Waiting');
    expect(connection.state, StatusHubState.limited);
    expect(connection.diagnosisReason, StatusHubPathDiagnosisReason.hubDelayed);

    final viewModel = const StatusHubViewModelMapper().map(hub);
    final detail = viewModel.detailConnections.firstWhere(
      (item) => item.id == StatusHubConnectionId.jugglucoToXdrip,
    );
    expect(detail.stateLabel, isNot('Fresh'));
    expect(detail.state, StatusHubState.limited);
    expect(detail.pathScore.metrics.first.rawValue, 'Waiting');
  });

  test('AAPS without xDrip BG source evidence focuses AAPS setup path', () {
    const engine = StatusHubEngine();
    final now = DateTime(2026, 6, 18, 12);
    final facts = hubTestFacts(
      now: now,
      aapsBgSourceObserved: false,
      hasAapsBgSourceEvidence: true,
    );

    final hub = engine.run(StatusHubEngineInput(facts: facts)).report;

    expect(hub.focus.connectionId, StatusHubConnectionId.xdripToAaps);
    final aaps = hub.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.xdripToAaps,
    );
    expect(aaps.diagnosisReason, StatusHubPathDiagnosisReason.bgSourceMissing);
    expect(aaps.nextCheck, contains('BG source is xDrip+'));
  });
}

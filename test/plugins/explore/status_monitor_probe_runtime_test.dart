import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_driver.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_suite.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_suite_runner.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_monitor_target_resolution.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_category.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_mode.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_definition.dart';

void main() {
  test('suite runner returns all child results and captures failures',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final suite = _FakeSuite([
      _FakeDriver('probe.ok', StatusProbeState.healthy, now),
      _ThrowingDriver('probe.fail'),
    ]);

    final result = await StatusProbeSuiteRunner(now: () => now).run(
      suite,
      StatusProbeContext(
        subjectId: 'self',
        now: now,
        target: const StatusMonitorTargetResolution.none(subjectId: 'self'),
      ),
    );

    expect(result.results, hasLength(2));
    expect(result.state, StatusProbeState.issue);
    expect(result.results.last.state, StatusProbeState.issue);
    expect(result.results.last.sourceRefs.first.path, 'exception');
  });
}

class _FakeSuite implements StatusProbeSuite {
  _FakeSuite(this.drivers);

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: 'fake',
        label: 'Fake',
        kind: StatusProbeKind.xdrip,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

class _FakeDriver implements StatusProbeDriver {
  _FakeDriver(this.id, this.state, this.now);

  final String id;
  final StatusProbeState state;
  final DateTime now;

  @override
  StatusProbeDefinition get definition => StatusProbeDefinition(
        id: StatusProbeId(id),
        suiteId: 'fake',
        label: id,
        kind: StatusProbeKind.xdrip,
        category: StatusProbeCategory.api,
        runMode: StatusProbeRunMode.active,
        requiredForCorePath: true,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    return StatusProbeResult(
      definition: definition,
      state: state,
      observedAt: now,
      confidence: 1,
      runMode: StatusProbeRunMode.active,
      summary: 'ok',
    );
  }
}

class _ThrowingDriver extends _FakeDriver {
  _ThrowingDriver(String id) : super(id, StatusProbeState.issue, DateTime(0));

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    throw StateError('boom');
  }
}

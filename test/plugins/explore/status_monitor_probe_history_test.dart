import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_driver.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_history_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_suite.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/history/status_probe_history_recorder.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_event_bus.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_registry.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_result_cache.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_runtime.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_monitor_target_resolution.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_category.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_history_sample.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_mode.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_definition.dart';

void main() {
  test('runtime records probe history samples after suite execution', () async {
    final now = DateTime(2026, 6, 26, 12);
    final repository = _MemoryProbeHistoryRepository();
    final runtime = StatusProbeRuntime(
      registry: StatusProbeRegistry(
        suites: [
          _FakeSuite([
            _FakeDriver(
              'xdrip.broadcast.freshness',
              StatusProbeCategory.freshness,
              StatusProbeState.healthy,
              now,
              requiredForCorePath: true,
            ),
            _FakeDriver(
              'watch.display.evidence',
              StatusProbeCategory.optional,
              StatusProbeState.notObserved,
              now,
            ),
          ]),
        ],
      ),
      cache: StatusProbeResultCache(),
      eventBus: StatusProbeEventBus(),
      historyRecorder: StatusProbeHistoryRecorder(repository: repository),
      now: () => now,
    );

    await runtime.runAll(
      StatusProbeContext(
        subjectId: 'self',
        now: now,
        target: const StatusMonitorTargetResolution.none(subjectId: 'self'),
      ),
    );

    expect(repository.samples, hasLength(1));
    expect(repository.samples.single.probeId, 'xdrip.broadcast.freshness');
    expect(repository.samples.single.category, StatusProbeCategory.freshness);
    expect(repository.samples.single.runMode, StatusProbeRunMode.active);
    expect(repository.samples.single.payloadJson, contains('probeId'));
  });
}

class _MemoryProbeHistoryRepository implements StatusProbeHistoryRepository {
  final samples = <StatusProbeHistorySample>[];

  @override
  Future<List<StatusProbeHistorySample>> latest({
    required String subjectId,
    required String probeId,
    int limit = 20,
  }) async {
    return samples
        .where((sample) =>
            sample.subjectId == subjectId && sample.probeId == probeId)
        .take(limit)
        .toList(growable: false);
  }

  @override
  Future<void> save(StatusProbeHistorySample sample) async {
    samples.add(sample);
  }
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
  _FakeDriver(
    this.id,
    this.category,
    this.state,
    this.now, {
    this.requiredForCorePath = false,
  });

  final String id;
  final StatusProbeCategory category;
  final StatusProbeState state;
  final DateTime now;
  final bool requiredForCorePath;

  @override
  StatusProbeDefinition get definition => StatusProbeDefinition(
        id: StatusProbeId(id),
        suiteId: 'fake',
        label: id,
        kind: StatusProbeKind.xdrip,
        category: category,
        runMode: StatusProbeRunMode.active,
        requiredForCorePath: requiredForCorePath,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    return StatusProbeResult(
      definition: definition,
      state: state,
      observedAt: now,
      confidence: state == StatusProbeState.healthy ? 1 : 0,
      runMode: StatusProbeRunMode.active,
      summary: state.name,
    );
  }
}

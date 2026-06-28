import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_result.dart';
import 'package:smart_xdrip/application/sync_runtime/unified_glucose_sync_runtime.dart';
import 'package:smart_xdrip/application/sync_runtime/unified_sync_run_result.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';

void main() {
  test('unified runtime serializes sync runs and reports completion', () async {
    final completer = Completer<GlucoseSourceSyncResult>();
    final completions = <UnifiedSyncRunResult>[];
    var executorCalls = 0;
    final runtime = UnifiedGlucoseSyncRuntime(
      executor: () {
        executorCalls++;
        return completer.future;
      },
      onCompleted: (result) async {
        completions.add(result);
      },
      now: () => DateTime(2026, 1, 1, 12),
    );

    final first = runtime.run(trigger: 'foregroundPolling');
    final second = await runtime.run(trigger: 'appResumed');

    expect(second, isNull);
    expect(executorCalls, 1);
    expect(runtime.running, isTrue);

    completer.complete(const GlucoseSourceSyncResult(sourceResults: []));
    final firstResult = await first;

    expect(firstResult, isNotNull);
    expect(firstResult!.trigger, 'foregroundPolling');
    expect(completions.single.trigger, 'foregroundPolling');
    expect(runtime.running, isFalse);
  });

  test('target sync uses the same completion pipeline', () async {
    final completions = <UnifiedSyncRunResult>[];
    final runtime = UnifiedGlucoseSyncRuntime(
      executor: () async => const GlucoseSourceSyncResult(sourceResults: []),
      targetExecutor: (
          {required target, required settings, explicitPlan}) async {
        return GlucoseSyncResult(
          source: target.source.type,
          subjectId: target.subjectId,
          success: true,
          available: true,
          fetchedCount: 2,
          storedCount: 2,
          cursor: DateTime(2026, 1, 1, 12, 5),
          error: null,
          readings: const [],
        );
      },
      onCompleted: (result) async {
        completions.add(result);
      },
      now: () => DateTime(2026, 1, 1, 12),
    );

    final result = await runtime.runTarget(
      target: const GlucoseSyncTarget(
        targetId: 'target.remote.1',
        subjectId: 'remote-1',
        label: 'Remote 1',
        kind: GlucoseSyncTargetKind('remote'),
        source: _FakeGlucoseSource(),
      ),
      settings: const AppSettings(),
      trigger: 'remoteFullAnalysis',
    );

    expect(result, isNotNull);
    expect(result!.storedCount, 2);
    expect(result.updatedSubjectIds, {'remote-1'});
    expect(completions.single.trigger, 'remoteFullAnalysis');
  });

  test(
      'target sync runs different targets concurrently but dedupes same target',
      () async {
    final completions = <UnifiedSyncRunResult>[];
    final pending = <String, Completer<GlucoseSyncResult>>{};
    var executorCalls = 0;
    final runtime = UnifiedGlucoseSyncRuntime(
      executor: () async => const GlucoseSourceSyncResult(sourceResults: []),
      targetExecutor: ({required target, required settings, explicitPlan}) {
        executorCalls++;
        final completer = Completer<GlucoseSyncResult>();
        pending[target.targetId] = completer;
        return completer.future;
      },
      onCompleted: (result) async {
        completions.add(result);
      },
      now: () => DateTime(2026, 1, 1, 12),
    );

    final targetA = _target('target.remote.a', 'remote-a');
    final targetB = _target('target.remote.b', 'remote-b');
    final firstA = runtime.runTarget(
      target: targetA,
      settings: const AppSettings(),
      trigger: 'remoteList',
    );
    final secondA = await runtime.runTarget(
      target: targetA,
      settings: const AppSettings(),
      trigger: 'remoteList',
    );
    final firstB = runtime.runTarget(
      target: targetB,
      settings: const AppSettings(),
      trigger: 'remoteList',
    );

    expect(secondA, isNull);
    expect(executorCalls, 2);
    expect(pending.keys, containsAll(['target.remote.a', 'target.remote.b']));

    pending['target.remote.a']!.complete(_resultFor(targetA));
    pending['target.remote.b']!.complete(_resultFor(targetB));

    expect(await firstA, isNotNull);
    expect(await firstB, isNotNull);
    expect(completions.map((result) => result.updatedSubjectIds).toList(), [
      {'remote-a'},
      {'remote-b'},
    ]);
  });
}

GlucoseSyncTarget _target(String targetId, String subjectId) {
  return GlucoseSyncTarget(
    targetId: targetId,
    subjectId: subjectId,
    label: targetId,
    kind: const GlucoseSyncTargetKind('remote'),
    source: const _FakeGlucoseSource(),
  );
}

GlucoseSyncResult _resultFor(GlucoseSyncTarget target) {
  return GlucoseSyncResult(
    source: target.source.type,
    subjectId: target.subjectId,
    success: true,
    available: true,
    fetchedCount: 1,
    storedCount: 1,
    cursor: DateTime(2026, 1, 1, 12, 5),
    error: null,
    readings: const [],
  );
}

class _FakeGlucoseSource implements IGlucoseSource {
  const _FakeGlucoseSource();

  @override
  DataSource get type => DataSource.nightscout;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<GlucoseReading?> latest() async => null;

  @override
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  }) async =>
      const [];

  @override
  Future<List<GlucoseReading>> recent({int count = 24}) async => const [];
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_result.dart';
import 'package:smart_xdrip/application/sync_runtime/unified_glucose_sync_runtime.dart';
import 'package:smart_xdrip/application/sync_status/subject_sync_status_store.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_provider.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_submitter.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';

void main() {
  test('submitter dispatches multiple targets concurrently', () async {
    final targetA = _target('remote:a', 'subject-a');
    final targetB = _target('remote:b', 'subject-b');
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
      onCompleted: (_) async {},
      now: () => DateTime(2026, 6, 22, 10),
    );
    final submitter = GlucoseSyncTargetSubmitter(
      registry: GlucoseSyncTargetRegistry(
        providers: [
          _Provider([targetA, targetB])
        ],
      ),
      runtime: runtime,
      subjectStatusStore: SubjectSyncStatusStore(),
      settingsProvider: () => const AppSettings(),
      now: () => DateTime(2026, 6, 22, 10),
    );

    final future = submitter.submitTargetIds(
      targetIds: ['remote:a', 'remote:b'],
      trigger: 'remoteStreamRefresh',
    );

    await Future<void>.delayed(Duration.zero);

    expect(executorCalls, 2);
    expect(pending.keys, containsAll(['remote:a', 'remote:b']));

    pending['remote:a']!.complete(_resultFor(targetA));
    pending['remote:b']!.complete(_resultFor(targetB));

    final results = await future;

    expect(results, hasLength(2));
    expect(
      results.map((result) => result.updatedSubjectIds).toSet(),
      {
        {'subject-a'},
        {'subject-b'},
      },
    );
  });
}

GlucoseSyncTarget _target(String targetId, String subjectId) {
  return GlucoseSyncTarget(
    targetId: targetId,
    subjectId: subjectId,
    label: targetId,
    kind: const GlucoseSyncTargetKind('remote'),
    source: const _Source(),
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
    cursor: DateTime(2026, 6, 22, 10),
    error: null,
    readings: const [],
  );
}

class _Provider implements GlucoseSyncTargetProvider {
  final List<GlucoseSyncTarget> targets;

  const _Provider(this.targets);

  @override
  Future<List<GlucoseSyncTarget>> targetsFor(AppSettings settings) async {
    return targets;
  }
}

class _Source implements IGlucoseSource {
  const _Source();

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

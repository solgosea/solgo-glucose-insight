import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_provider.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_owner.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_source_metadata.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_monitor_target_resolution.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_monitor_target_resolver.dart';

void main() {
  test('resolves active remote Nightscout target for active subject', () async {
    final resolver = StatusMonitorTargetResolver(
      targetRegistry: GlucoseSyncTargetRegistry(
        providers: [
          _Provider([
            _target(
              targetId: 'remote:kid:nightscout',
              subjectId: 'remote:kid',
              label: 'Kid Nightscout',
              owner: GlucoseSyncTargetOwner.remote,
            ),
          ]),
        ],
      ),
      settingsProvider: () => const AppSettings(),
    );

    final resolution = await resolver.resolve(
      const AnalysisSubject(
        id: 'remote:kid',
        displayName: 'Kid',
        sourceLabel: 'Remote Nightscout',
        origin: AnalysisSubjectOrigin.external,
      ),
    );

    expect(resolution.sourceKind, StatusMonitorTargetSourceKind.nightscout);
    expect(resolution.subjectId, 'remote:kid');
    expect(resolution.targetId, 'remote:kid:nightscout');
    expect(resolution.baseUrl, 'http://localhost:1337');
    expect(resolution.token, 'token');
    expect(resolution.enabled, isTrue);
  });

  test('xDrip local device probe is available beyond self subject', () async {
    final resolver = StatusMonitorTargetResolver(
      targetRegistry: GlucoseSyncTargetRegistry(),
      settingsProvider: () => const AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        xdripSyncEnabled: true,
      ),
    );

    final selfResolution = await resolver.resolve(
      const AnalysisSubject(
        id: GlucoseSubject.selfId,
        displayName: 'Me',
        sourceLabel: 'Self',
        origin: AnalysisSubjectOrigin.self,
      ),
    );
    final remoteSubject = const AnalysisSubject(
      id: 'remote:kid',
      displayName: 'Kid',
      sourceLabel: 'Remote Nightscout',
      origin: AnalysisSubjectOrigin.external,
    );
    final remotePrimary = await resolver.resolve(remoteSubject);
    final remoteXdripProbe = resolver.resolveSelfXdripLocal(remoteSubject);

    expect(selfResolution.sourceKind, StatusMonitorTargetSourceKind.xdripLocal);
    expect(remotePrimary.sourceKind, StatusMonitorTargetSourceKind.none);
    expect(remoteXdripProbe, isNotNull);
    expect(
      remoteXdripProbe!.sourceKind,
      StatusMonitorTargetSourceKind.xdripLocal,
    );
  });

  test('xDrip local monitor uses default URL when strategy is enabled', () {
    final resolver = StatusMonitorTargetResolver(
      targetRegistry: GlucoseSyncTargetRegistry(),
      settingsProvider: () => const AppSettings(
        xdripSyncEnabled: true,
      ),
    );

    final resolution = resolver.resolveSelfXdripLocal(
      const AnalysisSubject(
        id: GlucoseSubject.selfId,
        displayName: 'Me',
        sourceLabel: 'Self',
        origin: AnalysisSubjectOrigin.self,
      ),
    );

    expect(resolution, isNotNull);
    expect(resolution!.baseUrl, 'http://127.0.0.1:17580');
    expect(resolution.enabled, isTrue);
  });

  test('prefers self xDrip local over enabled self Nightscout target',
      () async {
    final resolver = StatusMonitorTargetResolver(
      targetRegistry: GlucoseSyncTargetRegistry(
        providers: [
          _Provider([
            _target(
              targetId: 'self:nightscout',
              subjectId: GlucoseSubject.selfId,
              label: 'Self Nightscout',
              owner: GlucoseSyncTargetOwner.self,
              kind: GlucoseSyncTargetKind.selfNightscout,
            ),
          ]),
        ],
      ),
      settingsProvider: () => const AppSettings(
        xdripBaseUrl: 'http://127.0.0.1:17580',
        xdripSyncEnabled: true,
        nightscoutBaseUrl: 'http://localhost:1340',
        nightscoutSyncEnabled: true,
      ),
    );

    final resolution = await resolver.resolve(
      const AnalysisSubject(
        id: GlucoseSubject.selfId,
        displayName: 'Me',
        sourceLabel: 'Self',
        origin: AnalysisSubjectOrigin.self,
      ),
    );

    expect(resolution.sourceKind, StatusMonitorTargetSourceKind.xdripLocal);
    expect(resolution.targetId, 'self:xdrip-local');
    expect(resolution.enabled, isTrue);
  });
}

GlucoseSyncTarget _target({
  required String targetId,
  required String subjectId,
  required String label,
  required GlucoseSyncTargetOwner owner,
  GlucoseSyncTargetKind kind = GlucoseSyncTargetKind.remoteNightscout,
}) {
  return GlucoseSyncTarget(
    targetId: targetId,
    subjectId: subjectId,
    label: label,
    kind: kind,
    source: _FakeNightscoutSource(),
    owner: owner,
    metadata: const GlucoseSyncTargetSourceMetadata(
      nightscoutUrl: 'http://localhost:1337',
      accessToken: 'token',
    ),
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

class _FakeNightscoutSource implements IGlucoseSource {
  @override
  DataSource get type => DataSource.nightscout;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<GlucoseReading?> latest() async => null;

  @override
  Future<List<GlucoseReading>> recent({int count = 24}) async => const [];

  @override
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  }) async =>
      const [];
}

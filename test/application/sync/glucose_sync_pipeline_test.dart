import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_context.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_pipeline.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_step.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../../_support/fakes/fake_glucose_source.dart';
import '../../_support/fixtures/app_settings_fixture.dart';
import '../../_support/test_database.dart';

void main() {
  group('GlucoseSyncPipeline', () {
    test('executes steps in order', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final calls = <String>[];
      final context = GlucoseSyncContext(
        database: database,
        source: FakeGlucoseSource(
          type: DataSource.nightscout,
          readings: const [],
        ),
        settings: AppSettingsFixture.nightscout,
      );

      await GlucoseSyncPipeline(
        steps: [
          _RecordingStep('one', calls),
          _RecordingStep('two', calls),
          _RecordingStep('three', calls),
        ],
      ).run(context);

      expect(calls, ['one', 'two', 'three']);
    });

    test('stops when a step writes a result', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final calls = <String>[];
      final context = GlucoseSyncContext(
        database: database,
        source: FakeGlucoseSource(
          type: DataSource.xdripHttp,
          readings: const [],
        ),
        settings: AppSettingsFixture.xdrip,
      );

      await GlucoseSyncPipeline(
        steps: [
          _RecordingStep('before-stop', calls),
          _StopStep(calls),
          _RecordingStep('after-stop', calls),
        ],
      ).run(context);

      expect(calls, ['before-stop', 'stop']);
      expect(context.result?.success, isFalse);
    });
  });
}

class _RecordingStep extends GlucoseSyncStep {
  final String name;
  final List<String> calls;

  const _RecordingStep(this.name, this.calls);

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    calls.add(name);
  }
}

class _StopStep extends GlucoseSyncStep {
  final List<String> calls;

  const _StopStep(this.calls);

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    calls.add('stop');
    context.stopWith(
      GlucoseSyncResult.failure(
        source: context.source.type,
        error: 'stopped_by_test',
      ),
    );
  }
}

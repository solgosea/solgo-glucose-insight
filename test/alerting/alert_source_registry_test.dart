import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/source/alert_source_registry.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_input.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_input_origin.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source_id.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source_sink.dart';

void main() {
  test('registry starts plugin alert sources through a shared sink', () async {
    final registry = AlertSourceRegistry();
    final source = _FakeAlertSource();
    final sink = _FakeAlertSourceSink();

    registry.register(source);
    await registry.startAll(sink);

    expect(source.started, isTrue);
    expect(sink.inputs.single.messageType, 'fake.alert');

    await registry.stopAll();
    expect(source.stopped, isTrue);
  });

  test(
    'registry auto starts sources registered after the sink is active',
    () async {
      final registry = AlertSourceRegistry();
      final sink = _FakeAlertSourceSink();

      await registry.startAll(sink);
      final source = _FakeAlertSource();
      registry.register(source);
      await pumpEventQueue();

      expect(source.started, isTrue);
      expect(sink.inputs.single.messageType, 'fake.alert');
    },
  );
}

class _FakeAlertSource implements AlertSource {
  bool started = false;
  bool stopped = false;

  @override
  AlertSourceId get sourceId => const AlertSourceId('fake.source');

  @override
  Future<void> start(AlertSourceSink sink) async {
    started = true;
    await sink.ingest(
      const AlertInput(
        sourceId: AlertSourceId('fake.source'),
        origin: AlertInputOrigin.system,
        messageType: 'fake.alert',
      ),
    );
  }

  @override
  Future<void> stop() async {
    stopped = true;
  }
}

class _FakeAlertSourceSink implements AlertSourceSink {
  final inputs = <AlertInput>[];

  @override
  Future<void> ingest(AlertInput input) async {
    inputs.add(input);
  }
}

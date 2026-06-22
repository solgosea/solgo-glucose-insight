import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sources/status_monitor_source_client.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sources/status_xdrip_local_probe_loader.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test('keeps local service reachable when glucose endpoints have no data',
      () async {
    final loader = StatusXdripLocalProbeLoader(
      client: _FakeStatusClient(
        serviceResult: const StatusHttpResult(
          reachable: true,
          statusCode: 200,
          elapsed: Duration(milliseconds: 40),
        ),
        throwForAuxiliary: true,
      ),
    );

    final bundle = await loader.load(now: DateTime(2026, 6, 15, 10));

    expect(bundle.statusProbe, isNotNull);
    expect(bundle.statusProbe!.reachable, isTrue);
    expect(bundle.statusProbe!.level, StatusLevel.healthy);
    expect(bundle.pebble, isNull);
    expect(bundle.sensorContext, isNull);
    expect(bundle.collectorContext, isNull);
  });
}

class _FakeStatusClient implements StatusMonitorSourceClient {
  const _FakeStatusClient({
    required this.serviceResult,
    this.throwForAuxiliary = false,
  });

  final StatusHttpResult serviceResult;
  final bool throwForAuxiliary;

  @override
  Future<StatusHttpResult> checkService() async => serviceResult;

  @override
  Future<StatusHttpResult> get(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    if (throwForAuxiliary) {
      throw StateError('no glucose payload');
    }
    return const StatusHttpResult(
      reachable: true,
      statusCode: 200,
      elapsed: Duration(milliseconds: 50),
      data: <String, Object?>{},
    );
  }

  @override
  Future<List<GlucoseReading>> loadEntries24h(DateTime now) async {
    return const <GlucoseReading>[];
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/history/engine/status_history_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_component_history_sample.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_bucket_reason.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_sample_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test('uses latest sample inside each hour and aggregates worst daily level',
      () {
    final now = DateTime.utc(2026, 6, 12, 10, 30);
    final component = const StatusHistoryEngine().calculateComponent(
      component: _component(StatusComponentKind.nightscout),
      samples: [
        _sample(
          DateTime.utc(2026, 6, 12, 8, 10),
          StatusComponentKind.nightscout,
          StatusLevel.watch,
          score: 66,
        ),
        _sample(
          DateTime.utc(2026, 6, 12, 8, 40),
          StatusComponentKind.nightscout,
          StatusLevel.issue,
          score: 22,
        ),
      ],
      now: now,
    );

    expect(component.hourlyBuckets.last[8].level, StatusLevel.issue);
    expect(component.hourlyBuckets.last[8].score, 22);
    expect(
      component.hourlyBuckets.last[8].reason,
      StatusHistoryBucketReason.recordedSample,
    );
    expect(component.dailyBuckets.last.level, StatusLevel.issue);
  });

  test('uses component specific carry-forward TTLs', () {
    final now = DateTime.utc(2026, 6, 12, 11, 30);
    final engine = const StatusHistoryEngine();
    final cgmResult = engine.calculateComponent(
      component: _component(StatusComponentKind.cgmSensor),
      samples: [
        _sample(
          DateTime.utc(2026, 6, 12, 10, 42),
          StatusComponentKind.cgmSensor,
          StatusLevel.healthy,
        ),
      ],
      now: now,
    );
    final xdripResult = engine.calculateComponent(
      component: _component(StatusComponentKind.xdrip),
      samples: [
        _sample(
          DateTime.utc(2026, 6, 12, 10, 42),
          StatusComponentKind.xdrip,
          StatusLevel.healthy,
        ),
      ],
      now: now,
    );

    final cgm = cgmResult.hourlyBuckets.last[11];
    final xdrip = xdripResult.hourlyBuckets.last[11];
    expect(cgm.reason, StatusHistoryBucketReason.carriedForward);
    expect(cgm.level, StatusLevel.healthy);
    expect(xdrip.reason, StatusHistoryBucketReason.noSample);
    expect(xdrip.level, StatusLevel.unknown);
  });
}

ComponentHealth _component(StatusComponentKind kind) {
  return ComponentHealth(
    kind: kind,
    level: StatusLevel.healthy,
    title: kind.title,
    role: kind.role,
    takeaway: '',
    summary: '',
    metrics: const [],
  );
}

StatusComponentHistorySample _sample(
  DateTime at,
  StatusComponentKind component,
  StatusLevel level, {
  int? score,
}) {
  return StatusComponentHistorySample(
    at: at,
    component: component,
    level: level,
    score: score,
    confidence: .8,
    summary: level.label,
    source: const StatusHistorySampleSource(
      targetId: 'nightscout',
      kind: 'nightscout',
      label: 'Nightscout',
    ),
  );
}

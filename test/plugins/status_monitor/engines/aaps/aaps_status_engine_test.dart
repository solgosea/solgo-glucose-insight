import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/aaps/aaps_metric_ids.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/aaps/aaps_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/aaps/aaps_detail_data.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/detail/status_response_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('marks AAPS unknown when Nightscout is not configured', () async {
    final context = const FakeStatusRuleContextFactory().build();

    final component = await const AapsStatusEngine().evaluate(context);

    expect(component.kind, StatusComponentKind.aapsLoop);
    expect(component.level, StatusLevel.unknown);
    expect(component.score?.availableSignals, 0);
    expect(component.score?.totalSignals, 3);
  });

  test(
    'keeps AAPS unknown when Nightscout has no AAPS/openaps context',
    () async {
      final now = DateTime.utc(2026, 6, 15, 12);
      final context = const FakeStatusRuleContextFactory().build(
        now: now,
        nightscout: NightscoutEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'Nightscout',
          generatedAt: now,
          status: const StatusResponseSnapshot(
            reachable: true,
            elapsed: Duration(milliseconds: 120),
          ),
          deviceStatus: [
            {
              'created_at':
                  now.subtract(const Duration(minutes: 4)).toIso8601String(),
              'uploader': {'battery': 90},
            },
          ],
        ),
      );

      final component = await const AapsStatusEngine().evaluate(context);

      expect(component.level, StatusLevel.unknown);
      expect(component.score?.availableSignals, 0);
      final sync = component.metrics.firstWhere(
        (metric) => metric.id == AapsMetricIds.syncFreshness,
      );
      expect(sync.available, isFalse);
    },
  );

  test('scores fresh AAPS Nightscout evidence as healthy', () async {
    final now = DateTime.utc(2026, 6, 15, 12);
    final context = const FakeStatusRuleContextFactory().build(
      now: now,
      nightscout: NightscoutEvidence(
        configured: true,
        enabled: true,
        sourceLabel: 'Nightscout',
        generatedAt: now,
        status: const StatusResponseSnapshot(
          reachable: true,
          elapsed: Duration(milliseconds: 120),
        ),
        deviceStatus: [
          {
            'created_at':
                now.subtract(const Duration(minutes: 4)).toIso8601String(),
            'openaps': {
              'suggested': {'timestamp': now.toIso8601String()},
              'iob': {'iob': 1.2},
              'cob': 18,
              'profile': 'Default',
            },
            'pump': {
              'status': 'normal',
              'reservoir': 132,
              'battery': {'percent': 72},
            },
          },
        ],
      ),
    );

    final component = await const AapsStatusEngine().evaluate(context);

    expect(component.level, StatusLevel.healthy);
    expect(component.score?.availableSignals, 3);
    expect(component.detailData, isA<AapsDetailData>());
    final detail = component.detailData! as AapsDetailData;
    expect(detail.timeline.length, 36);
    expect(detail.evidenceMatrix.length, 4);
  });
}

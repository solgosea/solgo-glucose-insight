import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/cgm_sensor/cgm_sensor_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/xdrip/xdrip_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/evidence/aaps_evidence_parser.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/detail/status_endpoint_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/cgm_reading_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/status_evidence_bundle.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/status_evidence_selection.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/xdrip_local_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test(
    'xDrip service uses local probe while freshness falls back to Nightscout',
    () async {
      final now = DateTime.utc(2026, 6, 15, 12);
      final nightscoutReadings = List.generate(
        288,
        (index) => GlucoseReading(
          value: 7.1,
          timestamp: now
              .subtract(const Duration(hours: 24))
              .add(Duration(minutes: index * 5)),
        ),
      );
      final evidence = _evidence(
        now: now,
        xdrip: XdripLocalEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'xDrip+ Local',
          generatedAt: now,
          serviceProbe: StatusEndpointProbe(
            endpoint: '/status.json',
            label: 'local service',
            level: StatusLevel.healthy,
            reachable: true,
            statusCode: 200,
            elapsed: const Duration(milliseconds: 40),
            checkedAt: now,
          ),
          readings: const [],
        ),
        nightscout: NightscoutEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'Nightscout',
          generatedAt: now,
          readings: nightscoutReadings,
        ),
      );

      final component = await const XdripStatusEngine().evaluate(
        StatusAnalysisContext(
          now: now,
          evidence: evidence,
        ),
      );

      final localService = component.metrics
          .firstWhere((metric) => metric.id == 'local_service');
      final freshness =
          component.metrics.firstWhere((metric) => metric.id == 'freshness');
      final completeness = component.metrics
          .firstWhere((metric) => metric.id == 'completeness_24h');

      expect(localService.level, StatusLevel.healthy);
      expect(localService.valueLabel, '40ms');
      expect(freshness.level, StatusLevel.healthy);
      expect(freshness.note, contains('Nightscout'));
      expect(completeness.level, StatusLevel.healthy);
      expect(completeness.note, contains('Nightscout'));
    },
  );

  test(
    'xDrip local service alone is partial evidence instead of 100 percent',
    () async {
      final now = DateTime.utc(2026, 6, 15, 12);
      final evidence = _evidence(
        now: now,
        xdrip: XdripLocalEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'xDrip+ Local',
          generatedAt: now,
          serviceProbe: StatusEndpointProbe(
            endpoint: '/status.json',
            label: 'local service',
            level: StatusLevel.healthy,
            reachable: true,
            statusCode: 200,
            elapsed: const Duration(milliseconds: 40),
            checkedAt: now,
          ),
          readings: const [],
        ),
      );

      final component = await const XdripStatusEngine().evaluate(
        StatusAnalysisContext(
          now: now,
          evidence: evidence,
        ),
      );

      final freshness =
          component.metrics.firstWhere((metric) => metric.id == 'freshness');
      final completeness = component.metrics
          .firstWhere((metric) => metric.id == 'completeness_24h');

      expect(component.level, StatusLevel.watch);
      expect(component.score?.value, lessThan(100));
      expect(component.score?.value, 25);
      expect(component.score?.label, 'Service reachable, no readings');
      expect(component.score?.confidence, closeTo(.25, .001));
      expect(freshness.level, StatusLevel.unknown);
      expect(completeness.level, StatusLevel.unknown);
    },
  );

  test('CGM engine falls back to Nightscout readings when active is empty',
      () async {
    final now = DateTime.utc(2026, 6, 15, 12);
    final nightscoutReadings = List.generate(
      24,
      (index) => GlucoseReading(
        value: 7.0,
        timestamp: now
            .subtract(const Duration(hours: 2))
            .add(Duration(minutes: index * 5)),
      ),
    );
    final evidence = _evidence(
      now: now,
      nightscout: NightscoutEvidence(
        configured: true,
        enabled: true,
        sourceLabel: 'Nightscout',
        generatedAt: now,
        readings: nightscoutReadings,
      ),
    );

    final component = await const CgmSensorStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: evidence,
      ),
    );

    final freshness = component.metrics
        .firstWhere((metric) => metric.id == 'sensor_freshness');
    expect(freshness.level, StatusLevel.healthy);
    expect(component.detailData, isNotNull);
  });

  test('CGM current status ignores cached readings when no live source exists',
      () async {
    final now = DateTime.utc(2026, 6, 15, 12);
    final cachedReadings = List.generate(
      288,
      (index) => GlucoseReading(
        value: 7.0,
        timestamp: now
            .subtract(const Duration(hours: 24))
            .add(Duration(minutes: index * 5)),
      ),
    );
    final evidence = _evidence(
      now: now,
      cached: CgmReadingEvidence(
        sourceLabel: 'Cached 24h local readings',
        readings: cachedReadings,
        generatedAt: now,
      ),
    );

    final component = await const CgmSensorStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: evidence,
      ),
    );

    final freshness = component.metrics
        .firstWhere((metric) => metric.id == 'sensor_freshness');
    final cv =
        component.metrics.firstWhere((metric) => metric.id == 'cgm_cv_24h');

    expect(freshness.level, StatusLevel.unknown);
    expect(component.level, StatusLevel.unknown);
    expect(cv.valueLabel, isNot('Unknown'));
    expect(component.score!.availableSignals, 0);
  });
}

StatusEvidenceBundle _evidence({
  required DateTime now,
  XdripLocalEvidence xdrip = const XdripLocalEvidence.none(),
  NightscoutEvidence nightscout = const NightscoutEvidence.none(),
  CgmReadingEvidence cached = const CgmReadingEvidence.none(),
}) {
  final cgmLive = StatusEvidenceBundle.selectCgmLiveReadings(
    xdrip: xdrip,
    nightscout: nightscout,
  );
  final cgmHistory = StatusEvidenceBundle.selectCgmHistoryReadings(
    cached: cached,
  );
  final xdripLive = StatusEvidenceBundle.selectXdripLiveReadings(
    xdrip: xdrip,
    nightscout: nightscout,
  );
  return StatusEvidenceBundle(
    subjectId: 'self',
    xdripLocalEvidence: xdrip,
    nightscoutEvidence: nightscout,
    aapsEvidence: const AapsEvidenceParser().parse(
      nightscout: nightscout,
      now: now,
    ),
    cachedReadingEvidence: cached,
    selection: StatusEvidenceSelection(
      cgmLiveReadings: cgmLive,
      cgmHistoryReadings: cgmHistory,
      xdripLiveReadings: xdripLive,
    ),
  );
}

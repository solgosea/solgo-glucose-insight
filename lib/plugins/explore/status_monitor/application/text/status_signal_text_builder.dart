import '../../domain/status_metric.dart';
import 'status_text_renderer.dart';

class StatusSignalTextBuilder {
  final StatusTextRenderer renderer;

  const StatusSignalTextBuilder({
    this.renderer = const StatusTextRenderer(),
  });

  String cgmSessionDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.cgm.session.detail.available.v1',
        unavailableKey: 'status.cgm.session.detail.unavailable.v1',
        facts: {
          'threshold': metric.threshold?.compact ?? 'Reported by device status'
        },
        fallbackReason: 'Not reported by source',
      );

  String cgmSessionSource() =>
      renderer.render('status.cgm.session.source.v1', const {}).body;

  String cgmVariabilityDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.cgm.variability.detail.available.v1',
        unavailableKey: 'status.cgm.variability.detail.unavailable.v1',
        facts: {
          'threshold': metric.threshold?.compact ?? 'Based on 24h readings'
        },
        fallbackReason: 'Needs more readings',
      );

  String cgmVariabilitySource() =>
      renderer.render('status.cgm.variability.source.v1', const {}).body;

  String cgmJumpsDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.cgm.jumps.detail.available.v1',
        unavailableKey: 'status.cgm.jumps.detail.unavailable.v1',
        facts: const {'hours': 24},
        fallbackReason: 'Needs adjacent readings',
      );

  String cgmJumpsSource() => renderer.render(
        'status.cgm.jumps.source.v1',
        const {
          'jumpThreshold': '5.0',
          'glucoseUnit': 'mmol/L',
          'cadenceMin': 5,
        },
      ).body;

  String cgmFlatDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.cgm.flat.detail.available.v1',
        unavailableKey: 'status.cgm.flat.detail.unavailable.v1',
        facts: const {'hours': 24, 'watchMinutes': 30},
        fallbackReason: 'Needs adjacent readings',
      );

  String cgmFlatSource() => renderer.render(
        'status.cgm.flat.source.v1',
        const {'flatThreshold': '0.1', 'glucoseUnit': 'mmol/L'},
      ).body;

  String xdripFreshnessDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.xdrip.freshness.detail.available.v1',
        unavailableKey: 'status.xdrip.freshness.detail.unavailable.v1',
        facts: const {},
        fallbackReason: 'No recent glucose reading',
      );

  String xdripFreshnessSource() =>
      renderer.render('status.xdrip.freshness.source.v1', const {}).body;

  String xdripCompletenessDetail(StatusMetric metric) => renderer.render(
        'status.xdrip.completeness.detail.available.v1',
        {
          'note':
              metric.note ?? 'Expected readings found in the last 24 hours.',
        },
      ).body;

  String xdripCompletenessSource() => renderer.render(
        'status.xdrip.completeness.source.v1',
        const {'cadenceMin': 5},
      ).body;

  String xdripLatencyDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.xdrip.latency.detail.available.v1',
        unavailableKey: 'status.xdrip.latency.detail.unavailable.v1',
        facts: const {},
        fallbackReason: 'Not reliably exposed by this source',
      );

  String xdripLatencySource() =>
      renderer.render('status.xdrip.latency.source.v1', const {}).body;

  String xdripBatteryDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.xdrip.battery.detail.available.v1',
        unavailableKey: 'status.xdrip.battery.detail.unavailable.v1',
        facts: const {},
        fallbackReason: 'Battery data is not reported',
      );

  String xdripBatterySource() =>
      renderer.render('status.xdrip.battery.source.v1', const {}).body;

  String nightscoutReachabilityDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.nightscout.reachability.detail.available.v1',
        unavailableKey: 'status.nightscout.reachability.detail.unavailable.v1',
        facts: const {},
        fallbackReason: 'Status endpoint not available',
      );

  String nightscoutReachabilitySource() => renderer
      .render('status.nightscout.reachability.source.v1', const {}).body;

  String nightscoutResponseDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.nightscout.response.detail.available.v1',
        unavailableKey: 'status.nightscout.response.detail.unavailable.v1',
        facts: const {},
        fallbackReason: 'No completed status request',
      );

  String nightscoutResponseSource() =>
      renderer.render('status.nightscout.response.source.v1', const {}).body;

  String nightscoutDeviceStatusDetail(StatusMetric metric) => _available(
        metric,
        availableKey: 'status.nightscout.device_status.detail.available.v1',
        unavailableKey: 'status.nightscout.device_status.detail.unavailable.v1',
        facts: {'note': metric.note ?? 'Uploader context is available.'},
        fallbackReason: 'No uploader context reported',
      );

  String nightscoutDeviceStatusSource() => renderer
      .render('status.nightscout.device_status.source.v1', const {}).body;

  String _available(
    StatusMetric metric, {
    required String availableKey,
    required String unavailableKey,
    required Map<String, Object?> facts,
    required String fallbackReason,
  }) {
    if (metric.available) {
      return renderer.render(availableKey, facts).body;
    }
    return renderer.render(unavailableKey, {
      'reason': metric.unavailableReason ?? fallbackReason,
    }).body;
  }
}

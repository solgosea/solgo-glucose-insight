import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/path/status_hub_connection_metric_requirement.dart';
import '../../../domain/hub/status_hub_models.dart';
import 'status_hub_connection_metric_factory.dart';
import 'status_hub_metric_source_resolver.dart';

class XdripNightscoutMetricBuilder {
  final StatusHubConnectionMetricFactory factory;
  final StatusHubMetricSourceResolver sources;

  const XdripNightscoutMetricBuilder({
    this.factory = const StatusHubConnectionMetricFactory(),
    this.sources = const StatusHubMetricSourceResolver(),
  });

  List<StatusHubMetricFact> build(StatusHubFactBundle facts) {
    final xdrip = facts.xdrip.component;
    final nightscout = facts.nightscout.component;
    final delay = _delay(xdrip.age, nightscout.age);
    return [
      factory.age(
        id: 'cloud_reading_age',
        label: 'Cloud reading age',
        age: nightscout.age,
        source: sources.sourceFor(nightscout, 'server_data_freshness'),
        meaning: 'How recent the latest Nightscout entry is.',
      ),
      factory.delay(
        id: 'local_vs_cloud_delay',
        label: 'Local vs cloud delay',
        delay: delay,
        source: const StatusHubSourceRef.derivedPolicy(
          'xdrip_nightscout_metric_builder.local_vs_cloud_delay',
        ),
        meaning:
            'How far Nightscout is behind the latest local xDrip+ evidence.',
      ),
      factory.yesNo(
        id: 'api_status',
        label: 'API status',
        observed: sources.evidenceObserved(nightscout, 'api_reachable'),
        source: sources.sourceFor(nightscout, 'api_reachable'),
        valueOverride: sources.valueFor(nightscout, 'api_reachable'),
        meaning: 'Whether the Nightscout status endpoint is reachable.',
      ),
      factory.yesNo(
        id: 'entries_endpoint',
        label: 'Entries endpoint',
        observed: sources.evidenceObserved(nightscout, 'server_data_freshness'),
        source: sources.sourceFor(nightscout, 'server_data_freshness'),
        meaning: 'Whether entries endpoint returns recent glucose data.',
      ),
      factory.responseMs(
        id: 'response_time',
        label: 'Response time',
        value: facts.nightscout.medianResponseMs,
        source: sources.sourceFor(nightscout, 'api_reachable'),
        meaning: 'How quickly Nightscout responded to the latest probe.',
      ),
      factory.yesNo(
        id: 'device_status',
        label: 'Device status',
        observed: sources.evidenceObserved(nightscout, 'devicestatus_visible'),
        source: sources.sourceFor(nightscout, 'devicestatus_visible'),
        requirement: StatusHubConnectionMetricRequirement.optional,
        meaning: 'Optional loop/device context exposed by Nightscout.',
      ),
    ];
  }

  Duration? _delay(Duration? sourceAge, Duration? targetAge) {
    if (sourceAge == null || targetAge == null) return null;
    return targetAge - sourceAge;
  }
}

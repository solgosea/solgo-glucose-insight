import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/nightscout/nightscout_capability_context.dart';
import '../../../domain/status_level.dart';

class NightscoutCapabilityContextCalculator {
  const NightscoutCapabilityContextCalculator();

  List<NightscoutCapabilityContext> calculate(StatusAnalysisContext context) {
    final probes = context.evidence.nightscoutEvidence.endpointProbes;
    final hasStatus = probes.any(
      (probe) => probe.endpoint.contains('status.json') && probe.reachable,
    );
    final hasEntries = probes.any(
      (probe) => probe.endpoint.contains('/entries/') && probe.reachable,
    );
    final hasDeviceStatus = probes.any(
      (probe) => probe.endpoint.contains('/devicestatus') && probe.reachable,
    );
    return [
      NightscoutCapabilityContext(
        label: 'Access token',
        valueLabel: _tokenLabel(context),
        level: _tokenLevel(context),
      ),
      NightscoutCapabilityContext(
        label: 'Status endpoint',
        valueLabel: hasStatus ? 'Available' : 'Unavailable',
        level: hasStatus ? StatusLevel.healthy : StatusLevel.issue,
      ),
      NightscoutCapabilityContext(
        label: 'Entries endpoint',
        valueLabel: hasEntries ? 'Available' : 'Unavailable',
        level: hasEntries ? StatusLevel.healthy : StatusLevel.issue,
      ),
      NightscoutCapabilityContext(
        label: 'devicestatus',
        valueLabel: hasDeviceStatus ? 'Available' : 'Unknown',
        level: hasDeviceStatus ? StatusLevel.healthy : StatusLevel.unknown,
        note: hasDeviceStatus
            ? null
            : 'Missing devicestatus lowers context, not API health.',
      ),
      const NightscoutCapabilityContext(
        label: 'Version context',
        valueLabel: 'Context only',
        level: StatusLevel.unknown,
        note: 'Not included in health score.',
      ),
    ];
  }

  String _tokenLabel(StatusAnalysisContext context) {
    final rejected = context.evidence.nightscoutEvidence.endpointProbes.any(
      (probe) => probe.statusCode == 401 || probe.statusCode == 403,
    );
    return rejected ? 'Rejected' : 'Accepted or not required';
  }

  StatusLevel _tokenLevel(StatusAnalysisContext context) {
    final rejected = context.evidence.nightscoutEvidence.endpointProbes.any(
      (probe) => probe.statusCode == 401 || probe.statusCode == 403,
    );
    return rejected ? StatusLevel.issue : StatusLevel.healthy;
  }
}

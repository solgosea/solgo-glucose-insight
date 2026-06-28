import '../../sources/status_monitor_source_client.dart';
import '../../sources/status_nightscout_probe_loader.dart';

class NightscoutProbeRemoteSource {
  final StatusMonitorSourceClient client;

  const NightscoutProbeRemoteSource({
    required this.client,
  });

  Future<StatusNightscoutProbeBundle> load({required DateTime now}) {
    return StatusNightscoutProbeLoader(client: client).load(now: now);
  }
}

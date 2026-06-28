import '../../sources/status_monitor_source_client.dart';
import '../../sources/status_xdrip_local_probe_loader.dart';

class XdripWebServiceProbeRemoteSource {
  final StatusMonitorSourceClient client;

  const XdripWebServiceProbeRemoteSource({
    required this.client,
  });

  Future<StatusXdripLocalProbeBundle> load({required DateTime now}) {
    return StatusXdripLocalProbeLoader(client: client).load(now: now);
  }
}

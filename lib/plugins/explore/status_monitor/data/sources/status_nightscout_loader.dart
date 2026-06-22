import '../../domain/detail/status_probe_message_sanitizer.dart';
import '../../domain/detail/status_response_snapshot.dart';
import 'status_monitor_source_client.dart';

class StatusNightscoutLoader {
  final StatusMonitorSourceClient client;
  final StatusProbeMessageSanitizer messageSanitizer;

  const StatusNightscoutLoader({
    required this.client,
    this.messageSanitizer = const StatusProbeMessageSanitizer(),
  });

  Future<StatusResponseSnapshot> loadStatus() async {
    final result = await client.get('/api/v1/status.json');
    return StatusResponseSnapshot(
      reachable: result.reachable && result.statusCode == 200,
      statusCode: result.statusCode,
      elapsed: result.elapsed,
      errorLabel: messageSanitizer.fromHttpResult(
        reachable: result.reachable,
        statusCode: result.statusCode,
        error: result.error,
      ),
    );
  }
}

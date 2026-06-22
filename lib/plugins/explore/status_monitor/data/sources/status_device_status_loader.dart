import 'status_monitor_source_client.dart';

class StatusDeviceStatusLoader {
  final StatusMonitorSourceClient client;

  const StatusDeviceStatusLoader({required this.client});

  Future<List<Map<String, dynamic>>> loadDeviceStatus() async {
    final result = await client.get(
      '/api/v1/devicestatus.json',
      queryParameters: {'count': 10},
    );
    if (result.data is! List) return const [];
    return (result.data as List)
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList(growable: false);
  }
}

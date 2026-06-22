import '../detail/status_endpoint_probe.dart';

class NightscoutEndpointMatrix {
  final List<StatusEndpointProbe> endpoints;

  const NightscoutEndpointMatrix({required this.endpoints});

  Map<String, Object?> toJson() => {
        'endpoints': endpoints.map((endpoint) => endpoint.toJson()).toList(),
      };
}

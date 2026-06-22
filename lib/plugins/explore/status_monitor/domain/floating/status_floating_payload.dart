import '../status_level.dart';
import 'status_floating_component_payload.dart';

class StatusFloatingPayload {
  final StatusLevel level;
  final String headline;
  final String freshnessLabel;
  final bool hasConfiguredSource;
  final bool isStale;
  final List<StatusFloatingComponentPayload> components;

  const StatusFloatingPayload({
    required this.level,
    required this.headline,
    required this.freshnessLabel,
    required this.hasConfiguredSource,
    required this.isStale,
    required this.components,
  });

  Map<String, Object?> toMap() => {
        'level': level.name,
        'headline': headline,
        'freshnessLabel': freshnessLabel,
        'hasConfiguredSource': hasConfiguredSource,
        'isStale': isStale,
        'components': components.map((component) => component.toMap()).toList(),
      };
}

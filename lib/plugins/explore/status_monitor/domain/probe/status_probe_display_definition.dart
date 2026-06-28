import 'status_probe_action_definition.dart';

class StatusProbeDisplayDefinition {
  final String titleKey;
  final String descriptionKey;
  final String? iconKey;
  final String? guideRoute;
  final List<StatusProbeActionDefinition> actions;

  const StatusProbeDisplayDefinition({
    required this.titleKey,
    required this.descriptionKey,
    this.iconKey,
    this.guideRoute,
    this.actions = const [],
  });

  Map<String, Object?> toJson() => {
        'titleKey': titleKey,
        'descriptionKey': descriptionKey,
        'iconKey': iconKey,
        'guideRoute': guideRoute,
        'actions': actions.map((action) => action.toJson()).toList(),
      };
}

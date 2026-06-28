import 'contracts/status_check_component_definition.dart';
import '../../domain/status_component_kind.dart';

class StatusCheckComponentRegistry {
  final List<StatusCheckComponentDefinition> _definitions;

  const StatusCheckComponentRegistry({
    required List<StatusCheckComponentDefinition> definitions,
  }) : _definitions = definitions;

  List<StatusCheckComponentDefinition> get definitions =>
      List.unmodifiable(_definitions);

  StatusCheckComponentDefinition definitionFor(StatusComponentKind kind) {
    return _definitions.firstWhere((definition) => definition.kind == kind);
  }
}

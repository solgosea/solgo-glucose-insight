import '../../contracts/plugin_id.dart';
import 'plugin_runtime_event_type.dart';

class PluginRuntimeEvent {
  final PluginRuntimeEventType type;
  final PluginId? targetPluginId;
  final Map<String, Object?> payload;
  final DateTime occurredAt;

  const PluginRuntimeEvent({
    required this.type,
    required this.occurredAt,
    this.targetPluginId,
    this.payload = const {},
  });
}

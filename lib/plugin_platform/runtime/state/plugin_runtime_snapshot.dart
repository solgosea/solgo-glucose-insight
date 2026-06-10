import '../../contracts/plugin_id.dart';
import '../contracts/plugin_runtime_capability.dart';
import '../contracts/plugin_runtime_lifecycle.dart';

class PluginRuntimeSnapshot {
  final PluginId pluginId;
  final PluginRuntimeCapability capability;
  final PluginRuntimeLifecycle lifecycle;
  final String? message;
  final DateTime updatedAt;

  const PluginRuntimeSnapshot({
    required this.pluginId,
    required this.capability,
    required this.lifecycle,
    required this.updatedAt,
    this.message,
  });

  PluginRuntimeSnapshot copyWith({
    PluginRuntimeCapability? capability,
    PluginRuntimeLifecycle? lifecycle,
    String? message,
    bool clearMessage = false,
    DateTime? updatedAt,
  }) {
    return PluginRuntimeSnapshot(
      pluginId: pluginId,
      capability: capability ?? this.capability,
      lifecycle: lifecycle ?? this.lifecycle,
      message: clearMessage ? null : message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

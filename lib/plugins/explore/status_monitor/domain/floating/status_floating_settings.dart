import 'status_floating_mode.dart';
import 'status_floating_position.dart';

class StatusFloatingSettings {
  final StatusFloatingMode mode;
  final StatusFloatingPosition position;
  final bool collapsed;
  final DateTime updatedAt;

  StatusFloatingSettings({
    this.mode = StatusFloatingMode.enabled,
    this.position = StatusFloatingPosition.defaultPosition,
    this.collapsed = false,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory StatusFloatingSettings.defaults() {
    return StatusFloatingSettings();
  }

  bool get enabled => mode == StatusFloatingMode.enabled;

  StatusFloatingSettings copyWith({
    StatusFloatingMode? mode,
    StatusFloatingPosition? position,
    bool? collapsed,
    DateTime? updatedAt,
  }) {
    return StatusFloatingSettings(
      mode: mode ?? this.mode,
      position: position ?? this.position,
      collapsed: collapsed ?? this.collapsed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

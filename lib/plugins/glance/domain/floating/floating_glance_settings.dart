import 'floating_glance_display_style.dart';
import 'floating_glance_mode.dart';
import 'floating_glance_position.dart';

class FloatingGlanceSettings {
  final FloatingGlanceMode mode;
  final FloatingGlanceDisplayStyle displayStyle;
  final FloatingGlancePosition position;
  final bool collapsed;
  final bool dismissedForSession;

  const FloatingGlanceSettings({
    this.mode = FloatingGlanceMode.enabled,
    this.displayStyle = FloatingGlanceDisplayStyle.pill,
    this.position = FloatingGlancePosition.defaultPosition,
    this.collapsed = false,
    this.dismissedForSession = false,
  });

  bool get enabled => mode == FloatingGlanceMode.enabled;

  FloatingGlanceSettings copyWith({
    FloatingGlanceMode? mode,
    FloatingGlanceDisplayStyle? displayStyle,
    FloatingGlancePosition? position,
    bool? collapsed,
    bool? dismissedForSession,
  }) {
    return FloatingGlanceSettings(
      mode: mode ?? this.mode,
      displayStyle: displayStyle ?? this.displayStyle,
      position: position ?? this.position,
      collapsed: collapsed ?? this.collapsed,
      dismissedForSession: dismissedForSession ?? this.dismissedForSession,
    );
  }
}

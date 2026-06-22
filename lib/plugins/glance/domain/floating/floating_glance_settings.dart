import 'floating_glance_form_factor.dart';
import 'floating_glance_mode.dart';
import 'floating_glance_position.dart';
import 'floating_glance_preset_source.dart';
import 'floating_glance_size_preset.dart';

class FloatingGlanceSettings {
  final FloatingGlanceMode mode;
  final FloatingGlancePosition position;
  final FloatingGlanceSizePreset sizePreset;
  final FloatingGlanceFormFactor formFactor;
  final FloatingGlancePresetSource presetSource;
  final bool collapsed;
  final bool dismissedForSession;

  const FloatingGlanceSettings({
    this.mode = FloatingGlanceMode.enabled,
    this.position = FloatingGlancePosition.defaultPosition,
    this.sizePreset = FloatingGlanceSizePreset.medium,
    this.formFactor = FloatingGlanceFormFactor.pill,
    this.presetSource = FloatingGlancePresetSource.automatic,
    this.collapsed = false,
    this.dismissedForSession = false,
  });

  bool get enabled => mode == FloatingGlanceMode.enabled;

  FloatingGlanceSettings copyWith({
    FloatingGlanceMode? mode,
    FloatingGlancePosition? position,
    FloatingGlanceSizePreset? sizePreset,
    FloatingGlanceFormFactor? formFactor,
    FloatingGlancePresetSource? presetSource,
    bool? collapsed,
    bool? dismissedForSession,
  }) {
    return FloatingGlanceSettings(
      mode: mode ?? this.mode,
      position: position ?? this.position,
      sizePreset: sizePreset ?? this.sizePreset,
      formFactor: formFactor ?? this.formFactor,
      presetSource: presetSource ?? this.presetSource,
      collapsed: collapsed ?? this.collapsed,
      dismissedForSession: dismissedForSession ?? this.dismissedForSession,
    );
  }
}

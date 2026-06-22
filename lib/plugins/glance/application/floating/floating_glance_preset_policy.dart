import '../../domain/floating/floating_glance_device_class.dart';
import '../../domain/floating/floating_glance_form_factor.dart';
import '../../domain/floating/floating_glance_preset_source.dart';
import '../../domain/floating/floating_glance_settings.dart';
import '../../domain/floating/floating_glance_size_preset.dart';

class FloatingGlancePresetRecommendation {
  final FloatingGlanceDeviceClass deviceClass;
  final FloatingGlanceSizePreset sizePreset;
  final FloatingGlanceFormFactor formFactor;

  const FloatingGlancePresetRecommendation({
    required this.deviceClass,
    required this.sizePreset,
    required this.formFactor,
  });
}

class FloatingGlancePresetPolicy {
  const FloatingGlancePresetPolicy();

  FloatingGlanceDeviceClass classify({
    required double width,
    required double height,
  }) {
    final shortestSide = width < height ? width : height;
    if (shortestSide < 360) return FloatingGlanceDeviceClass.compactPhone;
    if (shortestSide < 600) return FloatingGlanceDeviceClass.phone;
    if (shortestSide < 840) return FloatingGlanceDeviceClass.largePhone;
    return FloatingGlanceDeviceClass.tablet;
  }

  FloatingGlancePresetRecommendation recommend({
    required double width,
    required double height,
  }) {
    final deviceClass = classify(width: width, height: height);
    return switch (deviceClass) {
      FloatingGlanceDeviceClass.compactPhone =>
        const FloatingGlancePresetRecommendation(
          deviceClass: FloatingGlanceDeviceClass.compactPhone,
          sizePreset: FloatingGlanceSizePreset.small,
          formFactor: FloatingGlanceFormFactor.pill,
        ),
      FloatingGlanceDeviceClass.phone =>
        const FloatingGlancePresetRecommendation(
          deviceClass: FloatingGlanceDeviceClass.phone,
          sizePreset: FloatingGlanceSizePreset.medium,
          formFactor: FloatingGlanceFormFactor.pill,
        ),
      FloatingGlanceDeviceClass.largePhone =>
        const FloatingGlancePresetRecommendation(
          deviceClass: FloatingGlanceDeviceClass.largePhone,
          sizePreset: FloatingGlanceSizePreset.medium,
          formFactor: FloatingGlanceFormFactor.card,
        ),
      FloatingGlanceDeviceClass.tablet =>
        const FloatingGlancePresetRecommendation(
          deviceClass: FloatingGlanceDeviceClass.tablet,
          sizePreset: FloatingGlanceSizePreset.large,
          formFactor: FloatingGlanceFormFactor.card,
        ),
    };
  }

  FloatingGlanceSettings effectiveSettings({
    required FloatingGlanceSettings settings,
    required double width,
    required double height,
  }) {
    if (settings.presetSource == FloatingGlancePresetSource.user) {
      return settings;
    }
    final recommendation = recommend(width: width, height: height);
    return settings.copyWith(
      sizePreset: recommendation.sizePreset,
      formFactor: recommendation.formFactor,
      presetSource: FloatingGlancePresetSource.automatic,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/glance/application/floating/floating_glance_preset_policy.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_device_class.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_form_factor.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_preset_source.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_settings.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_size_preset.dart';

void main() {
  const policy = FloatingGlancePresetPolicy();

  test('recommends presets from logical screen size', () {
    expect(
      policy.classify(width: 320, height: 700),
      FloatingGlanceDeviceClass.compactPhone,
    );
    expect(
      policy.recommend(width: 320, height: 700).sizePreset,
      FloatingGlanceSizePreset.small,
    );
    expect(
      policy.recommend(width: 390, height: 820).formFactor,
      FloatingGlanceFormFactor.pill,
    );
    expect(
      policy.recommend(width: 700, height: 1000).formFactor,
      FloatingGlanceFormFactor.card,
    );
    expect(
      policy.recommend(width: 900, height: 1200).sizePreset,
      FloatingGlanceSizePreset.large,
    );
  });

  test('automatic preset follows recommendation while user preset is stable',
      () {
    final automatic = policy.effectiveSettings(
      settings: const FloatingGlanceSettings(),
      width: 900,
      height: 1200,
    );
    expect(automatic.sizePreset, FloatingGlanceSizePreset.large);
    expect(automatic.formFactor, FloatingGlanceFormFactor.card);
    expect(automatic.presetSource, FloatingGlancePresetSource.automatic);

    final user = policy.effectiveSettings(
      settings: const FloatingGlanceSettings(
        sizePreset: FloatingGlanceSizePreset.small,
        formFactor: FloatingGlanceFormFactor.pill,
        presetSource: FloatingGlancePresetSource.user,
      ),
      width: 900,
      height: 1200,
    );
    expect(user.sizePreset, FloatingGlanceSizePreset.small);
    expect(user.formFactor, FloatingGlanceFormFactor.pill);
  });
}

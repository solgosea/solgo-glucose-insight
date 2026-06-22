import 'package:flutter/material.dart';

import '../../application/floating/floating_glance_preset_policy.dart';
import '../../application/i18n/glance_l10n.dart';
import '../../domain/floating/floating_glance_form_factor.dart';
import '../../domain/floating/floating_glance_preset_source.dart';
import '../../domain/floating/floating_glance_settings.dart';
import '../../domain/floating/floating_glance_setup_state.dart';
import '../../domain/floating/floating_glance_size_preset.dart';
import '../../domain/glance_snapshot.dart';
import '../../l10n/generated/glance_localizations.dart';
import '../styles/glance_theme.dart';
import 'floating_glance_preview.dart';
import 'floating_glance_setup_status.dart';

class FloatingGlanceCard extends StatelessWidget {
  final bool enabled;
  final bool permissionGranted;
  final FloatingGlanceSetupState setupState;
  final GlanceSnapshot snapshot;
  final FloatingGlanceSettings settings;
  final FloatingGlancePresetRecommendation recommendation;
  final VoidCallback onRequestPermission;
  final VoidCallback onShow;
  final VoidCallback onHide;
  final VoidCallback onUseRecommended;
  final ValueChanged<FloatingGlanceSizePreset> onSizePresetChanged;
  final ValueChanged<FloatingGlanceFormFactor> onFormFactorChanged;

  const FloatingGlanceCard({
    super.key,
    required this.enabled,
    required this.permissionGranted,
    required this.setupState,
    required this.snapshot,
    required this.settings,
    required this.recommendation,
    required this.onRequestPermission,
    required this.onShow,
    required this.onHide,
    required this.onUseRecommended,
    required this.onSizePresetChanged,
    required this.onFormFactorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.glanceL10n;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.picture_in_picture_alt_outlined,
                color: GlanceTheme.green,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  l10n.glanceFloatingCardTitle,
                  style: GlanceTheme.label.copyWith(
                    color: GlanceTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _FloatingStatePill(
                enabled: enabled,
                permissionGranted: permissionGranted,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.glanceFloatingCardBody,
            style: GlanceTheme.label.copyWith(
              color: GlanceTheme.soft,
              fontSize: 11.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          FloatingGlancePreview(
            snapshot: snapshot,
            sizePreset: settings.sizePreset,
            formFactor: settings.formFactor,
          ),
          const SizedBox(height: 14),
          FloatingGlanceSizeSelector(
            selected:
                settings.presetSource == FloatingGlancePresetSource.automatic
                    ? null
                    : settings.sizePreset,
            autoSelected:
                settings.presetSource == FloatingGlancePresetSource.automatic,
            recommendation: recommendation,
            onAutoSelected: onUseRecommended,
            onChanged: onSizePresetChanged,
          ),
          const SizedBox(height: 10),
          FloatingGlanceShapeSelector(
            selected: settings.formFactor,
            onChanged: onFormFactorChanged,
          ),
          const SizedBox(height: 9),
          FloatingGlanceAutoPresetNote(
            automatic:
                settings.presetSource == FloatingGlancePresetSource.automatic,
            recommendation: recommendation,
          ),
          const SizedBox(height: 12),
          FloatingGlanceSetupStatus(
            state: setupState,
            onRequestPermission: onRequestPermission,
            onShow: onShow,
            onHide: onHide,
          ),
        ],
      ),
    );
  }
}

class _FloatingStatePill extends StatelessWidget {
  final bool enabled;
  final bool permissionGranted;

  const _FloatingStatePill({
    required this.enabled,
    required this.permissionGranted,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && permissionGranted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: active ? GlanceTheme.green.withOpacity(.12) : GlanceTheme.card2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? GlanceTheme.green.withOpacity(.34)
              : GlanceTheme.borderMid,
        ),
      ),
      child: Text(
        active
            ? context.glanceL10n.glanceFloatingVisiblePill
            : context.glanceL10n.glanceFloatingSetupPill,
        style: GlanceTheme.mono.copyWith(
          color: active ? GlanceTheme.green : GlanceTheme.dim,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class FloatingGlanceSizeSelector extends StatelessWidget {
  final FloatingGlanceSizePreset? selected;
  final bool autoSelected;
  final FloatingGlancePresetRecommendation recommendation;
  final VoidCallback onAutoSelected;
  final ValueChanged<FloatingGlanceSizePreset> onChanged;

  const FloatingGlanceSizeSelector({
    super.key,
    required this.selected,
    required this.autoSelected,
    required this.recommendation,
    required this.onAutoSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.glanceL10n;
    return _FloatingOptionGroup(
      label: l10n.glanceFloatingSizeTitle,
      children: [
        _FloatingOptionChip(
          label: l10n.glanceFloatingSizeAuto,
          selected: autoSelected,
          onTap: onAutoSelected,
        ),
        for (final preset in FloatingGlanceSizePreset.values)
          _FloatingOptionChip(
            label: _sizeLabel(preset, l10n),
            selected: !autoSelected && selected == preset,
            onTap: () => onChanged(preset),
          ),
      ],
    );
  }

  String _sizeLabel(
    FloatingGlanceSizePreset preset,
    GlanceLocalizations l10n,
  ) {
    return switch (preset) {
      FloatingGlanceSizePreset.small => l10n.glanceFloatingSizeSmall,
      FloatingGlanceSizePreset.medium => l10n.glanceFloatingSizeMedium,
      FloatingGlanceSizePreset.large => l10n.glanceFloatingSizeLarge,
    };
  }
}

class FloatingGlanceShapeSelector extends StatelessWidget {
  final FloatingGlanceFormFactor selected;
  final ValueChanged<FloatingGlanceFormFactor> onChanged;

  const FloatingGlanceShapeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.glanceL10n;
    return _FloatingOptionGroup(
      label: l10n.glanceFloatingShapeTitle,
      children: [
        _FloatingOptionChip(
          label: l10n.glanceFloatingShapePill,
          selected: selected == FloatingGlanceFormFactor.pill,
          onTap: () => onChanged(FloatingGlanceFormFactor.pill),
        ),
        _FloatingOptionChip(
          label: l10n.glanceFloatingShapeCard,
          selected: selected == FloatingGlanceFormFactor.card,
          onTap: () => onChanged(FloatingGlanceFormFactor.card),
        ),
      ],
    );
  }
}

class FloatingGlanceAutoPresetNote extends StatelessWidget {
  final bool automatic;
  final FloatingGlancePresetRecommendation recommendation;

  const FloatingGlanceAutoPresetNote({
    super.key,
    required this.automatic,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.glanceL10n;
    final size = switch (recommendation.sizePreset) {
      FloatingGlanceSizePreset.small => l10n.glanceFloatingSizeSmall,
      FloatingGlanceSizePreset.medium => l10n.glanceFloatingSizeMedium,
      FloatingGlanceSizePreset.large => l10n.glanceFloatingSizeLarge,
    };
    final shape = switch (recommendation.formFactor) {
      FloatingGlanceFormFactor.pill => l10n.glanceFloatingShapePill,
      FloatingGlanceFormFactor.card => l10n.glanceFloatingShapeCard,
    };
    final text = automatic
        ? l10n.glanceFloatingRecommendedPreset(size, shape)
        : l10n.glanceFloatingCustomPreset;
    return Text(
      text,
      style: GlanceTheme.label.copyWith(
        color: GlanceTheme.dim,
        fontSize: 10.5,
        height: 1.35,
      ),
    );
  }
}

class _FloatingOptionGroup extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _FloatingOptionGroup({
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GlanceTheme.mono.copyWith(
            color: GlanceTheme.dim,
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: children,
        ),
      ],
    );
  }
}

class _FloatingOptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FloatingOptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color:
              selected ? GlanceTheme.green.withOpacity(.14) : GlanceTheme.card2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? GlanceTheme.green.withOpacity(.42)
                : GlanceTheme.borderMid,
          ),
        ),
        child: Text(
          label,
          style: GlanceTheme.label.copyWith(
            color: selected ? GlanceTheme.green : GlanceTheme.soft,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

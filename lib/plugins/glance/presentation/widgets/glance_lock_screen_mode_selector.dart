import 'package:flutter/material.dart';

import '../../domain/glance_lock_screen_mode.dart';
import '../styles/glance_theme.dart';

class GlanceLockScreenModeSelector extends StatelessWidget {
  final GlanceLockScreenMode value;
  final ValueChanged<GlanceLockScreenMode> onChanged;

  const GlanceLockScreenModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _ModeWrap(
      children: [
        for (final mode in GlanceLockScreenMode.values)
          _ModeChip(
            label: mode.label,
            selected: value == mode,
            onTap: () => onChanged(mode),
          ),
      ],
    );
  }
}

class _ModeWrap extends StatelessWidget {
  final List<Widget> children;

  const _ModeWrap({required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: children);
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color:
              selected ? GlanceTheme.green.withOpacity(.14) : GlanceTheme.card2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? GlanceTheme.green : GlanceTheme.border,
          ),
        ),
        child: Text(
          label,
          style: GlanceTheme.label.copyWith(
            color: selected ? GlanceTheme.green : GlanceTheme.soft,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

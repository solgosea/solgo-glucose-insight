import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../domain/date_filter_preset.dart';
import '../domain/date_filter_selection.dart';

class DateFilterPresetRow extends StatelessWidget {
  final List<DateFilterPreset> presets;
  final DateFilterSelection selection;
  final DateTime now;
  final ValueChanged<DateFilterSelection> onSelected;

  const DateFilterPresetRow({
    super.key,
    required this.presets,
    required this.selection,
    required this.now,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (presets.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (final preset in presets) ...[
            _PresetButton(
              preset: preset,
              active: _sameSelection(selection, preset.resolve(now)),
              onTap: () => onSelected(preset.resolve(now)),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  bool _sameSelection(DateFilterSelection a, DateFilterSelection b) {
    return _sameDay(a.start, b.start) && _sameDay(a.end, b.end);
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _PresetButton extends StatelessWidget {
  final DateFilterPreset preset;
  final bool active;
  final VoidCallback onTap;

  const _PresetButton({
    required this.preset,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active
        ? AppColors.blue.withValues(alpha: 0.11)
        : AppColors.bgCard.withValues(alpha: 0.78);
    final color = active ? AppColors.blue : AppColors.textSoft;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? AppColors.blue.withValues(alpha: 0.38)
                  : AppColors.border,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            preset.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

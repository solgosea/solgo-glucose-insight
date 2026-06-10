import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../foundation/theme/app_colors.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_runtime_state.dart';
import '../contracts/plugin_runtime_status.dart';

class PluginEntryCard extends StatelessWidget {
  final ExplorePluginEntry entry;
  final PluginRuntimeState? state;

  const PluginEntryCard({super.key, required this.entry, this.state});

  @override
  Widget build(BuildContext context) {
    final color = entry.accentColor ?? AppColors.green;
    final enabled = state?.enabled ?? true;
    final effectiveColor = enabled ? color : AppColors.textDim;
    return GestureDetector(
      onTap: enabled ? () => context.push(entry.route) : null,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                enabled
                    ? entry.accentColor?.withOpacity(0.18) ?? AppColors.border
                    : AppColors.border.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.bgCard2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(entry.icon, color: effectiveColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: enabled ? AppColors.text : AppColors.textDim,
                    ),
                  ),
                  Text(
                    state?.reason ?? entry.subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            if (enabled)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textDim,
                size: 20,
              )
            else
              _DisabledPill(label: _disabledLabel(state)),
          ],
        ),
      ),
    );
  }

  String _disabledLabel(PluginRuntimeState? state) {
    return switch (state?.status) {
      PluginRuntimeStatus.noData => 'No data',
      PluginRuntimeStatus.missingSource => 'No source',
      PluginRuntimeStatus.disabled => 'Disabled',
      PluginRuntimeStatus.hidden => 'Hidden',
      PluginRuntimeStatus.available || null => 'Unavailable',
    };
  }
}

class _DisabledPill extends StatelessWidget {
  final String label;

  const _DisabledPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 104),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textDim,
        ),
      ),
    );
  }
}

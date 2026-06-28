import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../../domain/history/status_component_history_load_state.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/status_component_history_section_view_model.dart';
import 'status_component_history_card.dart';

class StatusComponentHistorySection extends StatelessWidget {
  final StatusComponentHistorySectionViewModel section;

  const StatusComponentHistorySection({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return switch (section.state) {
      StatusComponentHistoryLoadState.ready => section.history == null
          ? _empty(context)
          : StatusComponentHistoryCard(
              component: section.history!,
            ),
      StatusComponentHistoryLoadState.empty => _empty(context),
      StatusComponentHistoryLoadState.failed => _messageCard(
          context,
          message: context.statusMonitorL10n.pageHistoryComponentFailed,
          icon: Icons.error_outline_rounded,
        ),
      StatusComponentHistoryLoadState.queued ||
      StatusComponentHistoryLoadState.loading =>
        _loading(context),
    };
  }

  Widget _loading(BuildContext context) {
    return _messageCard(
      context,
      message: context.statusMonitorL10n.pageHistoryLoadingComponent,
      icon: Icons.hourglass_top_rounded,
      trailing: const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          color: StatusMonitorTheme.green,
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return _messageCard(
      context,
      message: context.statusMonitorL10n.pageHistoryNoComponentData,
      icon: Icons.history_toggle_off_rounded,
    );
  }

  Widget _messageCard(
    BuildContext context, {
    required String message,
    required IconData icon,
    Widget? trailing,
  }) {
    final color = StatusMonitorTheme.colorFor(section.currentLevel);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: color.withOpacity(.24)),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing,
          ],
        ],
      ),
    );
  }
}

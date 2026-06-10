import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/di/app_container.dart';
import '../../../foundation/theme/app_colors.dart';
import '../../domain/action/alert_action.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_level.dart';
import '../banner/alert_banner_action.dart';
import '../widgets/alert_banner_action_row.dart';

class AlertOverlayHost extends StatefulWidget {
  final Widget child;

  const AlertOverlayHost({super.key, required this.child});

  @override
  State<AlertOverlayHost> createState() => _AlertOverlayHostState();
}

class _AlertOverlayHostState extends State<AlertOverlayHost> {
  StreamSubscription<AlertEvent>? _subscription;
  AlertEvent? _event;

  @override
  void initState() {
    super.initState();
    final bus = context.read<AppContainer>().alertOverlaySignalBus;
    _subscription = bus.events.listen(_show);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _show(AlertEvent event) {
    setState(() => _event = event);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_event != null)
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 12,
            child: _AlertCard(
              event: _event!,
              onAction: _handleAction,
              onClose: () => setState(() => _event = null),
            ),
          ),
      ],
    );
  }

  Future<void> _handleAction(AlertEvent event, AlertBannerAction action) async {
    final mapped = switch (action.type) {
      AlertBannerActionType.snooze => AlertAction.snooze,
      AlertBannerActionType.acknowledge => AlertAction.acknowledge,
      AlertBannerActionType.dismiss => AlertAction.dismiss,
      AlertBannerActionType.stop ||
      AlertBannerActionType.openDetail => AlertAction.stop,
    };
    await context
        .read<AppContainer>()
        .alertingRuntimeFactory
        .actionOrchestrator()
        .apply(event, mapped);
    if (mounted) {
      setState(() => _event = null);
    }
  }
}

class _AlertCard extends StatelessWidget {
  final AlertEvent event;
  final void Function(AlertEvent event, AlertBannerAction action) onAction;
  final VoidCallback onClose;

  const _AlertCard({
    required this.event,
    required this.onAction,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        event.level == AlertLevel.critical ? AppColors.rose : AppColors.amber;
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: .55)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .45),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.body,
                      style: const TextStyle(
                        color: AppColors.textSoft,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AlertBannerActionRow(
                      actions: const [
                        AlertBannerAction(
                          type: AlertBannerActionType.snooze,
                          label: 'Snooze 5m',
                        ),
                        AlertBannerAction(
                          type: AlertBannerActionType.dismiss,
                          label: 'Dismiss',
                        ),
                        AlertBannerAction(
                          type: AlertBannerActionType.stop,
                          label: 'Stop',
                        ),
                      ],
                      color: color,
                      onAction: (action) => onAction(event, action),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, color: AppColors.textDim),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

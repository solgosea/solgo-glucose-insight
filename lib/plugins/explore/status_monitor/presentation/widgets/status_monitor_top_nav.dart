import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../styles/status_monitor_theme.dart';

enum StatusMonitorTopNavDestination {
  dashboard,
  hub,
  checklist,
}

class StatusMonitorTopNav extends StatelessWidget {
  final StatusMonitorTopNavDestination current;

  const StatusMonitorTopNav({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final items = [
      _StatusMonitorTopNavItem(
        destination: StatusMonitorTopNavDestination.dashboard,
        icon: Icons.dashboard_customize_rounded,
        label: l10n.pageDashboardNavDashboard,
        route: '/explore/status',
      ),
      _StatusMonitorTopNavItem(
        destination: StatusMonitorTopNavDestination.hub,
        icon: Icons.hub_rounded,
        label: l10n.pageDashboardNavHub,
        route: '/explore/status/hub',
      ),
      _StatusMonitorTopNavItem(
        destination: StatusMonitorTopNavDestination.checklist,
        icon: Icons.fact_check_rounded,
        label: l10n.pageDashboardNavChecklist,
        route: '/explore/status/probe-checklist',
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: StatusMonitorTheme.card2.withOpacity(.88),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: StatusMonitorTheme.green.withOpacity(.14),
          ),
        ),
        child: Row(
          children: [
            for (final item in items)
              Expanded(
                child: _StatusMonitorTopNavButton(
                  item: item,
                  selected: item.destination == current,
                  onTap: () {
                    if (item.destination == current) return;
                    context.go(item.route);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusMonitorTopNavItem {
  final StatusMonitorTopNavDestination destination;
  final IconData icon;
  final String label;
  final String route;

  const _StatusMonitorTopNavItem({
    required this.destination,
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _StatusMonitorTopNavButton extends StatelessWidget {
  final _StatusMonitorTopNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _StatusMonitorTopNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? StatusMonitorTheme.bg : StatusMonitorTheme.soft;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? StatusMonitorTheme.green : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: StatusMonitorTheme.green.withOpacity(.26),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 16, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
